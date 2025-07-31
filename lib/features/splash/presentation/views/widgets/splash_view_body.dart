import 'package:animate_do/animate_do.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aura/core/utils/assets.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/core/di/service_locator.dart';
import 'package:aura/core/widgets/gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app_links/app_links.dart';

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
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initializeCacheHelper();
    _setupDeepLinkHandler();
  }

  void _setupDeepLinkHandler() async {
    // Handle incoming deep links
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('Deep link received: $uri');
        _handleDeepLink(uri);
      }
    });

    // Handle initial deep link
    final Uri? initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      debugPrint('Initial deep link: $initialLink');
      _handleDeepLink(initialLink);
    }
  }

  void _handleDeepLink(Uri uri) {
    final token = uri.queryParameters['token'];
    debugPrint("token $token");
    if (token != null && mounted) {
      getIt<UserCacheHelper>().saveUserToken(token);
      getIt<UserCacheHelper>().setLoggedIn(true);
      context.pushReplacement(AppRouter.homeView);
    }
  }

  Future<void> _initializeCacheHelper() async {
    try {
      userCacheHelper = getIt<UserCacheHelper>();
      await userCacheHelper.init();
      executeNavigation();
    } catch (e) {
      print('Error initializing cache helper: $e');
      // Fallback: navigate to onboarding after delay
      executeFallbackNavigation();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientBackground(
      child: ZoomInDown(
        duration: const Duration(seconds: 3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.assetsLogo,
                height: 112.h,
                width: 135.w,
              ),
              Text(
                'AURA',
                style: GoogleFonts.mali(
                    fontSize: 24.sp,
                    color: isDark
                        ? const Color(0xff5271FF)
                        : const Color(0xff212E67),
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'splash_subtitle'.tr(),
                style: GoogleFonts.sora(
                    fontSize: 14.sp,
                    color: isDark
                        ? Theme.of(context).textTheme.bodyMedium?.color
                        : const Color(0xff212E67),
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }

  void executeNavigation() {
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

  void executeFallbackNavigation() {
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
