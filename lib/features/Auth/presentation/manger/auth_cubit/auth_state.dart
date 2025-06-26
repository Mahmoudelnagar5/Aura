part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserModel userModel;
  AuthSuccess({required this.userModel});
}

final class AuthError extends AuthState {
  final String errMessage;
  AuthError({required this.errMessage});
}

// Form validation state
final class FormValidationState extends AuthState {}

// Password visibility state
final class PasswordVisibilityUpdated extends AuthState {}
