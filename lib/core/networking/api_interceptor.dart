import 'package:aura/core/di/service_locator.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Set default headers
    options.headers['Accept'] = 'application/json';
    // Set api key
    options.headers['X-API-KEY'] = '${dotenv.env['API_KEY']}';
    final token = getIt<UserCacheHelper>().getUserToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
