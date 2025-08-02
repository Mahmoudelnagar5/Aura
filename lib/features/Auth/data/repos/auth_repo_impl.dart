import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/core/networking/api_consumer.dart';
import 'package:aura/core/networking/api_failure.dart';
import 'package:aura/core/networking/endpoints.dart';
import 'package:aura/features/Auth/data/models/login_model.dart';
import 'package:aura/features/Auth/data/models/sign_up_model.dart';
import 'package:aura/features/Auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/networking/api_constants.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer apiConsumer;
  final UserCacheHelper userCacheHelper;

  AuthRepoImpl(this.userCacheHelper, {required this.apiConsumer});

  @override
  Future<Either<Failure, UserModel>> login(LoginModel loginModel) async {
    try {
      final response = await apiConsumer.post(
        Endpoints.login,
        data: {
          ApiConstants.email: loginModel.email,
          ApiConstants.password: loginModel.password,
        },
        isFromData: true,
      );

      final userModel = UserModel.fromJson(response);

      // Save token and set login status

      await userCacheHelper.saveUserToken(userModel.userData.userToken);
      await userCacheHelper.setLoggedIn(true);

      return Right(userModel);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register(
      RegisterModel registerModel) async {
    try {
      final response = await apiConsumer.post(
        Endpoints.register,
        data: {
          ApiConstants.firstName: registerModel.firstName,
          ApiConstants.lastName: registerModel.lastName,
          ApiConstants.email: registerModel.email,
          ApiConstants.password: registerModel.password,
          ApiConstants.passwordConfirmation: registerModel.confirmPassword,
        },
        isFromData: true,
      );

      final userModel = UserModel.fromJson(response);

      // await userCacheHelper.saveUserToken(userModel.userData.userToken);
      // await userCacheHelper.setLoggedIn(true);

      return Right(userModel);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> emailVerify(
      String email, String otp) async {
    try {
      final response = await apiConsumer.post(
        Endpoints.emailVerify,
        data: {
          ApiConstants.email: email,
          ApiConstants.verificationCode: otp,
        },
        isFromData: true,
      );

      final userModel = UserModel.fromJson(response);

      await userCacheHelper.saveUserToken(userModel.userData.userToken);
      await userCacheHelper.setLoggedIn(true);

      return Right(userModel);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> resendEmailVerification(
      String email) async {
    try {
      final response = await apiConsumer.post(
        Endpoints.emailResend,
        data: {
          ApiConstants.email: email,
        },
        isFromData: true,
      );

      final userModel = UserModel.fromJson(response);

      return Right(userModel);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
