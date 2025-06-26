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
      userData: UserData.fromJson(json['userData']),
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
      userToken: json['userToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userToken': userToken,
    };
  }
}





// {
//     "statusCode": 201,
//     "message": "User registered successfully.",
//     "userData": {
//         "userToken": "5|p289J0NaB2QjtuqG4uKmu1RD1mEVHy6ahZQMZMmP123aea74"
//     }
// }