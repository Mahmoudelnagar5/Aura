import 'package:aura/features/Auth/data/models/user_model.dart';
import 'package:aura/features/profile/data/repos/user_profile_repo.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/user_profile_model.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(
    this.userProfileRepo,
    this.userCacheHelper,
  ) : super(UpdateProfileInitial());

  final UserProfileRepo userProfileRepo;
  final UserCacheHelper userCacheHelper;

  // Form state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Password visibility state
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Selected image
  XFile? selectedImage;

  // Password visibility methods
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityUpdated());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(ConfirmPasswordVisibilityUpdated());
  }

  // Image picking
  Future<void> pickImage({required ImageSource source}) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source);

      if (picked != null) {
        selectedImage = XFile(picked.path);
        emit(EditProfileImageChanged()); // Trigger UI rebuild
      }
    } catch (e) {
      emit(UpdateProfileError(errMessage: 'Failed to pick image: $e'));
    }
  }

  // Profile update
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? passwordConfirmation,
    XFile? profilePic,
  }) async {
    emit(UpdateProfileLoading());

    try {
      final userProfileModel = _buildUserProfileModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        profilePic: profilePic,
      );

      final result = await userProfileRepo.updateProfile(userProfileModel);

      result.fold(
        (failure) => emit(UpdateProfileError(errMessage: failure.errorMessage)),
        (userModel) async => await _handleSuccessfulUpdate(userModel),
      );
    } catch (e) {
      emit(UpdateProfileError(errMessage: 'Update failed: $e'));
    }
  }

  UserProfileModel _buildUserProfileModel({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? passwordConfirmation,
    XFile? profilePic,
  }) {
    final currentProfile = userCacheHelper.getUserProfile();

    final userProfileModel = UserProfileModel(
      firstName: firstName ?? currentProfile?.firstName ?? '',
      lastName: lastName ?? currentProfile?.lastName ?? '',
      email: email ?? currentProfile?.email ?? '',
      password: password ?? currentProfile?.password ?? '',
      passwordConfirmation:
          passwordConfirmation ?? currentProfile?.passwordConfirmation ?? '',
      userProfileImageUrl: currentProfile?.userProfileImageUrl ?? '',
      accountCreatedAt: currentProfile?.accountCreatedAt,
    );

    // Set profile pic if provided
    if (profilePic != null) {
      userProfileModel.profilePic = profilePic;
    } else if (selectedImage != null) {
      userProfileModel.profilePic = selectedImage;
    }

    return userProfileModel;
  }

  Future<void> _handleSuccessfulUpdate(UserModel userModel) async {
    try {
      final getProfileResult = await userProfileRepo.getProfile();

      getProfileResult.fold(
        (getFailure) =>
            emit(UpdateProfileError(errMessage: getFailure.errorMessage)),
        (updatedProfile) => _completeUpdate(updatedProfile, userModel),
      );
    } catch (e) {
      emit(UpdateProfileError(errMessage: 'Failed to refresh profile: $e'));
    }
  }

  void _completeUpdate(UserProfileModel updatedProfile, UserModel userModel) {
    // Update cache with latest data from server
    userCacheHelper.saveUserProfile(updatedProfile);

    // Clear selected image after successful update
    selectedImage = null;

    // Emit success
    emit(UpdateProfileSuccess(userModel: userModel));
  }

  bool get hasSelectedImage => selectedImage != null;
}
