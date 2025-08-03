import 'package:animate_do/animate_do.dart';
import 'package:app_links/app_links.dart';
import 'package:aura/core/themes/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'core/di/service_locator.dart';
import 'core/helpers/database/user_cache_helper.dart';
import 'core/routing/app_router.dart';
import 'core/themes/dark_theme.dart';
import 'core/themes/light_theme.dart';
import 'core/themes/theme_cubit.dart';
import 'core/widgets/gradient_background.dart';

class Aura extends StatefulWidget {
  const Aura({super.key});

  @override
  State<Aura> createState() => _AuraState();
}

class _AuraState extends State<Aura> {
  late final AppLinks _appLinks;
  @override
  void initState() {
    super.initState();

    _appLinks = AppLinks();
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

  void _handleDeepLink(Uri uri) async {
    final token = uri.queryParameters['token'];
    debugPrint("token from app $token");
    if (token == null || token.isEmpty) {
      debugPrint("No token found in deep link");
      return;
    }
    await getIt<UserCacheHelper>().saveUserToken(token);
    await getIt<UserCacheHelper>().setLoggedIn(true);
    // Prefix path of route /auth/callback
    AppRouter.router.push(AppRouter.homeView);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, theme) {
            final themeCubit = context.read<ThemeCubit>();
            return MaterialApp.router(
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              title: 'AURA',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeCubit.getTheme(),
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
            );
          },
        );
      },
    );
  }
}

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: ZoomInDown(
          duration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/offline.json',
                width: 150.w,
                height: 150.h,
                fit: BoxFit.cover,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'No internet connection'.tr(),
                  style: GoogleFonts.sura(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Please check your internet connection and try again'.tr(),
                style: GoogleFonts.mali(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
