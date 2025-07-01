import 'package:aura/features/profile/data/repos/user_profile_repo.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_profile_model.dart';

part 'get_user_state.dart';

class GetUserCubit extends Cubit<GetUserState> {
  GetUserCubit(
    this.userProfileRepo,
    this.userCacheHelper,
  ) : super(GetUserInitial());

  final UserProfileRepo userProfileRepo;
  final UserCacheHelper userCacheHelper;

  Future<void> getUserProfile() async {
    emit(GetUserLoading());

    final result = await userProfileRepo.getProfile();

    result.fold(
      (failure) => emit(GetUserError(errMessage: failure.errorMessage)),
      (userProfile) {
        // Save to cache
        userCacheHelper.saveUserProfile(userProfile);
        emit(GetUserSuccess(userProfile: userProfile));
      },
    );
  }

  Future<void> getUserProfileFromCache() async {
    emit(GetUserLoading());

    final userProfile = userCacheHelper.getUserProfile();

    if (userProfile != null) {
      emit(GetUserSuccess(userProfile: userProfile));
    } else {
      emit(GetUserError(errMessage: 'No user profile found in cache'));
    }
  }

  Future<void> refreshUserProfile() async {
    // First try to get from cache for immediate response
    final cachedProfile = userCacheHelper.getUserProfile();
    if (cachedProfile != null) {
      emit(GetUserSuccess(userProfile: cachedProfile));
    }
  }
}
