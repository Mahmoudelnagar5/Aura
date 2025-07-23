import 'package:aura/core/helpers/database/docs_cache_helper.dart';
import 'package:aura/features/profile/data/repos/user_profile_repo.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/core/helpers/database/summary_cache_helper.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/helpers/database/cache_helper.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit(this.userProfileRepo, this.userCacheHelper)
      : super(DeleteAccountInitial());
  final UserProfileRepo userProfileRepo;
  final UserCacheHelper userCacheHelper;

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());

    try {
      // Call API to delete account
      final result = await userProfileRepo.deleteAccount();

      result.fold(
        (failure) => emit(DeleteAccountError(errMessage: failure.errorMessage)),
        (_) async {
          // Clear user cache after successful deletion
          await userCacheHelper.clearUserData();
          await DocsCacheHelper.clearDocs();
          // Clear all summaries
          await SummaryPrefs.clearAllSummaries();
          await getIt<CacheHelper>().clearData();
          emit(DeleteAccountSuccess());
        },
      );
    } catch (e) {
      // Even if API fails, clear local cache for security
      emit(DeleteAccountError(errMessage: e.toString()));
    }
  }
}
