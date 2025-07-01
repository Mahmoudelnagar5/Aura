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
  UpdateProfileError({required this.errMessage});
}

// Form validation state
final class FormValidationState extends UpdateProfileState {}

// Password visibility states
final class PasswordVisibilityUpdated extends UpdateProfileState {}

final class ConfirmPasswordVisibilityUpdated extends UpdateProfileState {}
