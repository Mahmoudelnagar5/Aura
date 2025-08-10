import 'package:app_links/app_links.dart';
import 'package:aura/core/themes/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/helpers/database/user_cache_helper.dart';
import 'core/routing/app_router.dart';
import 'core/themes/dark_theme.dart';
import 'core/themes/light_theme.dart';
import 'core/themes/theme_cubit.dart';

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
    // AppRouter.router.push(AppRouter.homeView);
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
