import 'package:aura/aura.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aura/core/helpers/database/docs_cache_helper.dart';
import 'core/di/service_locator.dart';
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
        enabled: false,
        // enabled: !kReleaseMode, // Only show device preview in debug mode
        builder: (context) => BlocProvider(
          create: (_) => ThemeCubit(),
          child: const Aura(),
        ),
      ),
    ),
  );
}
