import 'package:animate_do/animate_do.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:aura/core/utils/assets.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/core/di/service_locator.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({
    super.key,
  });

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  late UserCacheHelper userCacheHelper;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeCacheHelper();
  }

  Future<void> _initializeCacheHelper() async {
    try {
      userCacheHelper = getIt<UserCacheHelper>();
      await userCacheHelper.init();
      _executeNavigation();
    } catch (e) {
      print('Error initializing cache helper: $e');
      // Fallback: navigate to onboarding after delay
      _executeFallbackNavigation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomInDown(
      duration: const Duration(seconds: 3),
      child: Center(
        child: SvgPicture.asset(
          Assets.assetsAuraLogo,
        ),
      ),
    );
  }

  void _executeNavigation() {
    Future.delayed(
      const Duration(seconds: 4),
      () async {
        if (_isNavigating) return;
        _isNavigating = true;

        try {
          final isLoggedIn = userCacheHelper.isLoggedIn();
          if (isLoggedIn && mounted) {
            context.pushReplacement(AppRouter.homeView);
          } else if (mounted) {
            context.pushReplacement(AppRouter.onBoardingView);
          }
        } catch (e) {
          print('Navigation error: $e');
          if (mounted) {
            context.pushReplacement(AppRouter.onBoardingView);
          }
        }
      },
    );
  }

  void _executeFallbackNavigation() {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (_isNavigating) return;
        _isNavigating = true;

        if (mounted) {
          context.pushReplacement(AppRouter.onBoardingView);
        }
      },
    );
  }
}
