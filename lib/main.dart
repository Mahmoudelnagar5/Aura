import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aura/core/helpers/database/docs_cache_helper.dart';
import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:aura/features/profile/data/models/user_profile_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserProfileModelAdapter());
  }

  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  await DocsCacheHelper.init();

  // Initialize dependency injection
  await setupGetIt();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Only show device preview in debug mode
      builder: (context) => const Aura(),
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
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          title: 'Aura',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:aura/core/helpers/database/docs_cache_helper.dart';
// import 'core/di/service_locator.dart';
// import 'core/routing/app_router.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:aura/features/profile/data/models/user_profile_model.dart';

// Future<void> main() async {
//   try {
//     WidgetsFlutterBinding.ensureInitialized();

//     // Initialize Hive first
//     await Hive.initFlutter();
//     if (!Hive.isAdapterRegistered(0)) {
//       Hive.registerAdapter(UserProfileModelAdapter());
//     }

//     // Load environment variables from .env file
//     try {
//       await dotenv.load(fileName: '.env').catchError((e) {
//         debugPrint('Warning: Could not load .env file: $e');
//       });
//     } catch (e) {
//       debugPrint('Warning: Could not load .env file: $e');
//     }

//     // Initialize dependency injection before cache helpers
//     try {
//       await setupGetIt().catchError((e) {
//         debugPrint('Error: Could not setup dependency injection: $e');
//         throw Exception('Dependency injection failed: $e');
//       });
//     } catch (e) {
//       debugPrint('Error: Could not setup dependency injection: $e');
//       throw Exception('Dependency injection failed: $e');
//     }

//     // Initialize cache helper last
//     try {
//       await DocsCacheHelper.init().catchError((e) {
//         debugPrint('Error: Could not initialize cache helper: $e');
//         throw Exception('Cache initialization failed: $e');
//       });
//     } catch (e) {
//       debugPrint('Error: Could not initialize cache helper: $e');
//       throw Exception('Cache initialization failed: $e');
//     }

//     runApp(const Aura());
//   } catch (e) {
//     debugPrint('Critical Error in main: $e');
//     runApp(const FallbackApp());
//   }
// }

// class Aura extends StatelessWidget {
//   const Aura({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 640),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp.router(
//           routerConfig: AppRouter.router,
//           debugShowCheckedModeBanner: false,
//           title: 'Aura',
//           theme: ThemeData(
//             appBarTheme: const AppBarTheme(
//               backgroundColor: Colors.white,
//               elevation: 0,
//             ),
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//         );
//       },
//     );
//   }
// }

// class FallbackApp extends StatelessWidget {
//   const FallbackApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Aura',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Oops! Something went wrong',
//                 style: TextStyle(fontSize: 24),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   main();
//                 },
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
