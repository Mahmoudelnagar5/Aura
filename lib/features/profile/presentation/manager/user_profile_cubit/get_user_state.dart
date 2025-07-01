part of 'get_user_cubit.dart';

abstract class GetUserState {}

class GetUserInitial extends GetUserState {}

class GetUserLoading extends GetUserState {}

class GetUserSuccess extends GetUserState {
  final UserProfileModel userProfile;

  GetUserSuccess({required this.userProfile});
}

class GetUserError extends GetUserState {
  final String errMessage;

  GetUserError({required this.errMessage});
}
