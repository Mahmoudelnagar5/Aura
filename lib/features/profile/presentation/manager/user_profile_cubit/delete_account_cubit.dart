import 'package:aura/features/profile/data/repos/user_profile_repo.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          emit(DeleteAccountSuccess());
        },
      );
    } catch (e) {
      // Even if API fails, clear local cache for security
      await userCacheHelper.clearUserData();
      emit(DeleteAccountError(errMessage: e.toString()));
    }
  }
}
