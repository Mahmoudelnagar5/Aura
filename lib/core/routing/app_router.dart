import 'package:aura/features/Auth/presentation/views/sign_in_view.dart';
import 'package:aura/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/Auth/presentation/views/sign_up_view.dart';
import '../../features/home/presentation/views/widgets/home_layout.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../di/service_locator.dart';
import '../helpers/database/user_cache_helper.dart';
import 'package:aura/features/Auth/presentation/views/otp_verfication_view.dart';

// شاشة استقبال التوكن من deep link
class AuthCallbackScreen extends StatelessWidget {
  final String? token;
  final String? provider;
  const AuthCallbackScreen({super.key, this.token, this.provider});

  @override
  Widget build(BuildContext context) {
    if (token != null && token!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('token:from auth callback screen $token');
        debugPrint('provider: $provider');
        getIt<UserCacheHelper>().saveUserToken(token!);
        getIt<UserCacheHelper>().setLoggedIn(true);

        GoRouter.of(context).go(AppRouter.homeView);
      });
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

abstract class AppRouter {
  static const String splashView = '/';
  static const String onBoardingView = '/onBoardingView';
  static const String signInView = '/signInView';
  static const String signUpView = '/signUpView';
  static const String homeView = '/auth/callback';
  static const String profileView = '/profileView';
  static const String authCallback = '/auth/callback';

  static final router = GoRouter(
    initialLocation: splashView,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splashView,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SplashView(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: onBoardingView,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const OnBoardingView(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: signInView,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SignInView(),
          key: state.pageKey,
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: signUpView,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignUpView(),
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: homeView,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeLayout(),
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      GoRoute(
        path: profileView,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileView(),
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
      // مسار استقبال التوكن من deep link
      // GoRoute(
      //   path: authCallback,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //     key: state.pageKey,
      //     child: AuthCallbackScreen(
      //       token: state.uri.queryParameters['token'],
      //       provider: state.uri.queryParameters['provider'],
      //     ),
      //     transitionsBuilder: _transitionsBuilder,
      //   ),
      // ),
      GoRoute(
        path: '/otp-verification',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: OtpVerificationView(
            email: state.uri.queryParameters['email'] ?? '',
          ),
          transitionsBuilder: _transitionsBuilder,
        ),
      ),
    ],
  );
}

Widget _transitionsBuilder(context, animation, secondaryAnimation, child) {
  final tween = Tween(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  ).chain(
    CurveTween(curve: Curves.easeInOut),
  );
  final offsetAnimation = animation.drive(tween);
  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
