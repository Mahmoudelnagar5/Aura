import 'package:aura/features/Auth/data/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/login_model.dart';
import '../../../data/models/sign_up_model.dart';
import '../../../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());
  final AuthRepo authRepo;

  // Form management
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode validationMode = AutovalidateMode.disabled;

  // Register fields
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? confirmPassword;

  // Login fields
  String? emailLogin;
  String? passwordLogin;

  // Password visibility
  bool isPasswordObscured = true;

  Future<void> performLogin() async {
    if (!_validateForm()) return;
    formKey.currentState!.save();
    await login();
  }

  Future<void> performRegister() async {
    if (!_validateForm()) return;
    formKey.currentState!.save();
    await register();
  }

  bool _validateForm() {
    if (formKey.currentState!.validate()) return true;
    validationMode = AutovalidateMode.always;
    emit(FormValidationState());
    return false;
  }

  Future<void> login() async {
    emit(AuthLoading());
    final result = await authRepo.login(
      LoginModel(
        email: emailLogin!,
        password: passwordLogin!,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(errMessage: failure.errorMessage)),
      (userModel) => emit(AuthSuccess(userModel: userModel)),
    );
  }

  Future<void> register() async {
    emit(AuthLoading());
    final result = await authRepo.register(
      RegisterModel(
        firstName: firstName!,
        lastName: lastName!,
        email: email!,
        password: password!,
        confirmPassword: confirmPassword!,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(errMessage: failure.errorMessage)),
      (userModel) => emit(AuthSuccess(userModel: userModel)),
    );
  }

  Future<void> loginWithGithub() async {
    emit(AuthLoading());
    final result = await authRepo.loginWithGithub();

    result.fold(
      (failure) => emit(AuthError(errMessage: failure.errorMessage)),
      (userModel) => emit(AuthSuccess(userModel: userModel)),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    final result = await authRepo.loginWithGoogle();

    result.fold(
      (failure) => emit(AuthError(errMessage: failure.errorMessage)),
      (userModel) => emit(AuthSuccess(userModel: userModel)),
    );
  }

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    emit(PasswordVisibilityUpdated());
  }

  Widget buildVisibilityToggleIcon() {
    return IconButton(
      color: const Color.fromARGB(255, 177, 177, 177),
      icon: Icon(
        isPasswordObscured ? Icons.visibility : Icons.visibility_off,
        color: const Color.fromARGB(255, 177, 177, 177),
      ),
      onPressed: togglePasswordVisibility,
    );
  }
}
