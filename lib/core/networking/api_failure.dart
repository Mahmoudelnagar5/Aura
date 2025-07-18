import 'package:dio/dio.dart';
import 'api_error_model.dart';

class Failure implements Exception {
  final String errorMessage;

  Failure(this.errorMessage);
}

/// ServerFailure is a class that extends Failure and contains the error message for the API.
class ServerFailure extends Failure {
  final Map<String, dynamic>? errors;

  ServerFailure(super.errorMessage, {this.errors});
  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          'Connection time out for api service',
        );
      case DioExceptionType.sendTimeout:
        return ServerFailure(
          'Send time out for api service',
        );
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          'Receive time out for api service',
        );
      case DioExceptionType.badCertificate:
        return ServerFailure(
          'Certificate is invalid Your browser failed to validate your certificate',
        );
      case DioExceptionType.connectionError:
        return ServerFailure(
          'No internet connection, please resolve and try again.',
        );
      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailure(
            'No internet connection, please resolve and try again.',
          );
        } else {
          return ServerFailure('oops there was an error  , please try later ');
        }
      case DioExceptionType.cancel:
        return ServerFailure('Requset to api service canceld');

      /// this is the case for the bad response from the server
      case DioExceptionType.badResponse:
        final apiErrorModel = ApiErrorModel.fromJson(dioError.response!.data);
        return ServerFailure.fromResponse(
          statuscode: dioError.response!.statusCode ?? 500,
          response: apiErrorModel,
        );
    }
  }

  factory ServerFailure.fromResponse(
      {required int statuscode, required ApiErrorModel response}) {
    if (statuscode == 400 ||
        statuscode == 401 ||
        statuscode == 403 ||
        statuscode == 409 ||
        statuscode == 422) {
      return ServerFailure(response.errorMessage, errors: response.errors);
    } else if (statuscode == 404) {
      return ServerFailure(
        response.errorMessage,
      );
    } else if (statuscode == 500) {
      return ServerFailure(
        'internet server error , please try later',
      );
    } else {
      return ServerFailure(
        'oops there was an server error  , please try later',
      );
    }
  }
}
