import 'package:aura/core/networking/api_failure.dart';
import 'package:aura/features/Auth/data/models/login_model.dart';
import 'package:aura/features/Auth/data/models/sign_up_model.dart';
import 'package:aura/features/Auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> login(
    LoginModel loginModel,
  );
  Future<Either<Failure, UserModel>> register(
    RegisterModel signUpModel,
  );
  Future<Either<Failure, UserModel>> emailVerify(
    String email,
    String otp,
  );
}
