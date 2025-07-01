import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/core/networking/api_consumer.dart';
import 'package:aura/core/networking/api_failure.dart';
import 'package:aura/core/networking/endpoints.dart';
import 'package:aura/features/Auth/data/models/login_model.dart';
import 'package:aura/features/Auth/data/models/sign_up_model.dart';
import 'package:aura/features/Auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

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
  Future<Either<Failure, UserModel>> loginWithGoogle() async {
    try {
      // Present the auth screen to the user
      final result = await FlutterWebAuth2.authenticate(
        url: Endpoints.authAccount(
          provideName: 'google',
        ),
        callbackUrlScheme: "aura",
      );

      // Parse the returned URL for the token
      final uri = Uri.parse(result);
      final userToken = uri.queryParameters['userToken'] ?? '';
      // Create a UserModel from the token
      final user = UserData(userToken: userToken);
      final userModel = UserModel(
        statusCode: 200,
        message: 'Successfully logged in with Google',
        userData: user,
      );

      // Save token and set login status
      print(
          'AuthRepoImpl - Saving token: ${userModel.userData.userToken}'); // Debug print
      await userCacheHelper.saveUserToken(userModel.userData.userToken);
      await userCacheHelper.setLoggedIn(true);
      print('AuthRepoImpl - Token saved and login status set'); // Debug print

      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginWithGithub() async {
    try {
      // Present the auth screen to the user
      final result = await FlutterWebAuth2.authenticate(
        url: Endpoints.authAccount(
          provideName: 'github',
        ),
        callbackUrlScheme: "aura",
      );

      // Extract the query parameters
      final queryParams = Uri.parse(result).queryParameters;

      // Create a UserModel from the query parameters
      final user = UserData(
        userToken: queryParams['token'] ?? '',
      );
      final userModel = UserModel(
        statusCode: 200,
        message: 'Successfully logged in with GitHub',
        userData: user,
      );

      // Save token and set login status
      print(
          'AuthRepoImpl - Saving token: ${userModel.userData.userToken}'); // Debug print
      await userCacheHelper.saveUserToken(userModel.userData.userToken);
      await userCacheHelper.setLoggedIn(true);
      print('AuthRepoImpl - Token saved and login status set'); // Debug print

      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
