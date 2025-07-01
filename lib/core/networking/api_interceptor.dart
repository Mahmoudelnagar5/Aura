import 'package:aura/core/di/service_locator.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Set default headers
    options.headers['Accept'] = 'application/json';

    final token = getIt<UserCacheHelper>().getUserToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
