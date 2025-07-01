// {
//     "statusCode": 422,
//     "message": "Validation failed.",
//     "errors": {
//         "email": [
//             "The email has already been taken."
//         ],
//         "password": [
//             "The password field confirmation does not match."
//         ]
//     }
// }
/// ApiErrorModel is a class that contains the error message and status code for the API.
class ApiErrorModel implements Exception {
  final int statusCode;
  final String errorMessage;
  final Map<String, dynamic>? errors;

  ApiErrorModel(
      {required this.statusCode, required this.errorMessage, this.errors});
  factory ApiErrorModel.fromJson(Map<String, dynamic> jsonData) {
    String errorMessage = jsonData['message'] ?? 'An unknown error occurred.';
    Map<String, dynamic>? errors;

    if (jsonData['errors'] is Map) {
      errors = jsonData['errors'] as Map<String, dynamic>;
      // You can still construct a general message if you need one elsewhere
      // final errorMessages =
      //     errors.values.expand((list) => list as List).join('\n');
      // if (errorMessages.isNotEmpty) {
      //   errorMessage = errorMessages;
      // }
    }

    return ApiErrorModel(
      statusCode: jsonData['statusCode'] ?? 500,
      errorMessage: errorMessage,
      errors: errors,
    );
  }
}
