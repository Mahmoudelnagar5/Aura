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
    }

    return ApiErrorModel(
      statusCode: jsonData['statusCode'] ?? 500,
      errorMessage: errorMessage,
      errors: errors,
    );
  }
}
