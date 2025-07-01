class UserModel {
  final int statusCode;
  final String message;
  final UserData userData;

  UserModel({
    required this.statusCode,
    required this.message,
    required this.userData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      statusCode: json['statusCode'],
      message: json['message'],
      userData: json['userData'] is String && json['userData'].isEmpty
          ? UserData(
              userToken:
                  '') // Create empty UserData if userData is empty string
          : UserData.fromJson(json['userData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'userData': userData.toJson(),
    };
  }
}

class UserData {
  String userToken;

  UserData({
    required this.userToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userToken: json['userToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userToken': userToken,
    };
  }
}
