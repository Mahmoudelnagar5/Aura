part of 'update_profile_cubit.dart';

@immutable
sealed class UpdateProfileState {}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoading extends UpdateProfileState {}

final class UpdateProfileSuccess extends UpdateProfileState {
  final UserModel userModel;
  UpdateProfileSuccess({required this.userModel});
}

final class UpdateProfileError extends UpdateProfileState {
  final String errMessage;
  final Map<String, dynamic>? errors;
  UpdateProfileError({required this.errMessage, this.errors});
}

// Edit profile image state
final class EditProfileImageChanged extends UpdateProfileState {}

// Password visibility states
final class CurrentPasswordVisibilityUpdated extends UpdateProfileState {}

final class PasswordVisibilityUpdated extends UpdateProfileState {}

final class ConfirmPasswordVisibilityUpdated extends UpdateProfileState {}
