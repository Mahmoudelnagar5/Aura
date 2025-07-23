import 'package:aura/features/profile/data/repos/user_profile_repo.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this.userProfileRepo, this.userCacheHelper)
      : super(LogoutInitial());
  final UserProfileRepo userProfileRepo;
  final UserCacheHelper userCacheHelper;

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      // Call API logout
      final result = await userProfileRepo.logout();

      result.fold(
        (failure) => emit(LogoutError(errMessage: failure.errorMessage)),
        (_) async {
          // Clear user cache
          await userCacheHelper.clearUserData();
          if (!isClosed) emit(LogoutSuccess());
        },
      );
    } catch (e) {
      if (!isClosed) emit(LogoutError(errMessage: e.toString()));
    }
  }
}
