import 'package:aura/core/di/service_locator.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import '../helpers/database/cache_helper.dart';
import '../helpers/database/docs_cache_helper.dart';
import '../helpers/database/summary_cache_helper.dart';
import '../routing/app_router.dart';

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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final navigatorKey = GlobalKey<NavigatorState>();

    // Handle unauthorized errors
    if (err.response?.statusCode == 401) {
      await getIt<UserCacheHelper>().clearUserData();
      await DocsCacheHelper.clearDocs();
      // Clear all summaries
      await SummaryPrefs.clearAllSummaries();
      await getIt<CacheHelper>().clearData();
      // Navigate to onboarding view
      debugPrint("Unauthorized error: ${err.message}");
      navigatorKey.currentContext?.go(AppRouter.onBoardingView);
    }

    super.onError(err, handler);
  }
}
