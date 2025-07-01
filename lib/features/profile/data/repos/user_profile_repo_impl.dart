import 'package:aura/core/di/service_locator.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/core/networking/api_consumer.dart';
import 'package:aura/core/networking/api_failure.dart';
import 'package:aura/core/networking/endpoints.dart';
import 'package:aura/core/networking/upload_image_to_api.dart';

import 'package:aura/features/profile/data/models/user_profile_model.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../Auth/data/models/user_model.dart';
import 'user_profile_repo.dart';

class UserProfileRepoImpl implements UserProfileRepo {
  final ApiConsumer apiConsumer;
  final UserCacheHelper userCacheHelper;
  UserProfileRepoImpl(
      {required this.apiConsumer, required this.userCacheHelper});

  @override
  Future<Either<Failure, UserProfileModel>> getProfile() async {
    try {
      final response = await apiConsumer.get(
        Endpoints.getProfile,
      );
      // Check if response is a Map
      if (response is! Map<String, dynamic>) {
        return Left(ServerFailure('Invalid response format from server'));
      }

      // Check if userData exists
      if (!response.containsKey('userData')) {
        return Left(ServerFailure('No user data in response'));
      }

      final userData = response['userData'];
      // Check if userData is a Map
      if (userData is! Map<String, dynamic>) {
        return Left(ServerFailure('Invalid user data format'));
      }

      final userModel = UserProfileModel.fromJson(userData);
      return Right(userModel);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile(
    UserProfileModel userProfile,
  ) async {
    try {
      final current = getIt<UserCacheHelper>().getUserProfile();
      final data = <String, dynamic>{};

      if (userProfile.email != null &&
          userProfile.email!.isNotEmpty &&
          userProfile.email != current?.email)
        data['email'] = userProfile.email;
      if (userProfile.firstName != null &&
          userProfile.firstName!.isNotEmpty &&
          userProfile.firstName != current?.firstName)
        data['first_name'] = userProfile.firstName;
      if (userProfile.lastName != null &&
          userProfile.lastName!.isNotEmpty &&
          userProfile.lastName != current?.lastName)
        data['last_name'] = userProfile.lastName;
      if (userProfile.password != null &&
          userProfile.password!.isNotEmpty &&
          userProfile.password != current?.password)
        data['password'] = userProfile.password;
      if (userProfile.passwordConfirmation != null &&
          userProfile.passwordConfirmation!.isNotEmpty &&
          userProfile.passwordConfirmation != current?.passwordConfirmation)
        data['password_confirmation'] = userProfile.passwordConfirmation;
      if (userProfile.profilePic != null)
        data['profile_image'] = await uploadImageToAPI(userProfile.profilePic!);

      final response = await apiConsumer.post(
        Endpoints.updateProfile,
        data: FormData.fromMap(data),
        isFromData: true,
      );

      final userModel = UserModel.fromJson(response);

      // Don't update cache here, it will be updated by getProfile in the cubit
      return Right(userModel);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await apiConsumer.post(Endpoints.logout);
      await userCacheHelper.clearUserData();
      return Right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await apiConsumer.delete(Endpoints.deleteAccount);
      await userCacheHelper.clearUserData();
      return Right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
