import 'package:dartz/dartz.dart';

import 'package:aura/core/networking/api_failure.dart';
import 'package:aura/features/profile/data/models/user_profile_model.dart';
import '../../../Auth/data/models/user_model.dart';

abstract class UserProfileRepo {
  Future<Either<Failure, UserProfileModel>> getProfile();
  Future<Either<Failure, UserModel>> updateProfile(
      UserProfileModel userProfile);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> deleteAccount();
  // Future<Either<Failure, String>> uploadProfileImage(XFile image);
}
