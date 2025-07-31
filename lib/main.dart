import 'package:aura/core/themes/dark_theme.dart';
import 'package:aura/core/themes/light_theme.dart';
import 'package:aura/core/themes/theme_state.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aura/core/helpers/database/docs_cache_helper.dart';
import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/themes/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: '.env');
    debugPrint('Environment variables loaded successfully');
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
    debugPrint('Make sure .env file exists in the project root');
  }

  // Initialize dependency injection
  await DocsCacheHelper.init();
  await setupGetIt();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: DevicePreview(
        // enabled: false,
        enabled: !kReleaseMode, // Only show device preview in debug mode
        builder: (context) => BlocProvider(
          create: (_) => ThemeCubit(),
          child: const Aura(),
        ),
      ),
    ),
  );
}

class Aura extends StatelessWidget {
  const Aura({super.key});

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
