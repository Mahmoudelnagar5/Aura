import 'package:animate_do/animate_do.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:aura/core/utils/assets.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({
    super.key,
  });

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    excuteNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Roulette(
      duration: const Duration(seconds: 5),
      child: Center(
        child: SvgPicture.asset(
          Assets.assetsAuraLogo,
        ),
      ),
    );
  }

  void excuteNavigation() {
    Future.delayed(
      const Duration(seconds: 7),
      () async {
        context.pushReplacement(AppRouter.onBoardingView);
      },
    );
  }
}
