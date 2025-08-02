import 'package:aura/core/networking/api_failure.dart';
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
      (failure) {
        if (failure is ServerFailure) {
          emit(AuthError(
              errMessage: failure.errorMessage, errors: failure.errors));
        } else {
          emit(AuthError(errMessage: failure.errorMessage));
        }
      },
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
      (failure) {
        if (failure is ServerFailure) {
          emit(AuthError(
              errMessage: failure.errorMessage, errors: failure.errors));
        } else {
          emit(AuthError(errMessage: failure.errorMessage));
        }
      },
      (userModel) => emit(AuthSuccess(userModel: userModel)),
    );
  }

  Future<void> emailVerify(String email, String otp) async {
    emit(AuthLoading());
    final result = await authRepo.emailVerify(email, otp);

    result.fold(
      (failure) => emit(AuthError(errMessage: failure.errorMessage)),
      (userModel) => emit(AuthVerifySuccess(userModel: userModel)),
    );
  }

  Future<void> resendEmailVerification(String email) async {
    emit(AuthResendLoading());
    final result = await authRepo.resendEmailVerification(email);

    result.fold(
      (failure) => emit(AuthError(errMessage: failure.errorMessage)),
      (userModel) => emit(AuthResendSuccess(userModel: userModel)),
    );
  }
}
