import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../../../../core/networking/upload_image_to_api.dart';
import '../../../../core/utils/assets.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  String? firstName;

  @HiveField(1)
  String? lastName;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? password;

  @HiveField(4)
  String? passwordConfirmation;

  @HiveField(5)
  String? profilePicPath;

  @HiveField(6)
  String? userProfileImageUrl;

  @HiveField(7)
  String? accountCreatedAt;

  XFile? profilePic;

  UserProfileModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.profilePic,
    this.profilePicPath,
    this.userProfileImageUrl,
    this.accountCreatedAt,
  });

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : firstName = json['userFirstName'] ?? '',
        lastName = json['userLastName'] ?? '',
        email = json['userEmail'] ?? '',
        password = json['password'] ?? '',
        passwordConfirmation = json['password_confirmation'] ?? '',
        userProfileImageUrl = json['userProfileImage'] ?? Assets.assetsAvatar,
        accountCreatedAt = json['userAccountCreatedAt'];

  Future<Map<String, dynamic>> toJson() async {
    final map = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    if (profilePic != null) {
      map['profile_image'] = await uploadImageToAPI(profilePic!);
    }
    return map;
  }
}
