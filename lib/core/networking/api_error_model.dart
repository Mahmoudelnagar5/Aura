/// ApiErrorModel is a class that contains the error message and status code for the API.
class ApiErrorModel implements Exception {
  final int statusCode;
  final String errorMessage;

  ApiErrorModel({required this.statusCode, required this.errorMessage});
  factory ApiErrorModel.fromJson(Map<String, dynamic> jsonData) {
    String errorMessage = jsonData['message'] ?? 'An unknown error occurred.';

    if (jsonData['errors'] is Map) {
      final errors = jsonData['errors'] as Map<String, dynamic>;
      final errorMessages =
          errors.values.expand((list) => list as List).join('\n');
      if (errorMessages.isNotEmpty) {
        errorMessage = errorMessages;
      }
    }

    return ApiErrorModel(
      statusCode: jsonData['statusCode'] ?? 500,
      errorMessage: errorMessage,
    );
  }
}
