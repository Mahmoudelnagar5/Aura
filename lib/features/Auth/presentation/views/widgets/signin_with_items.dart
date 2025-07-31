import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aura/core/utils/assets.dart';
import 'package:aura/core/networking/endpoints.dart';
import 'package:url_launcher/url_launcher.dart';

import 'signin_icon.dart';

class SignInWithItems extends StatelessWidget {
  const SignInWithItems({
    super.key,
  });

  Future<void> _launchOAuthUrl(String provider) async {
    final url = Endpoints.authAccount(provideName: provider);
    if (await canLaunchUrl(Uri.parse(url))) {
      debugPrint('launch $url');

      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
      // يمكنك هنا عرض رسالة خطأ للمستخدم
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SignInIcon(
            onTap: () => _launchOAuthUrl('google'),
            image: Assets.assetsGoogle,
          ),
          SizedBox(
            width: 5.h,
          ),
          SignInIcon(
            onTap: () => _launchOAuthUrl('github'),
            image: Assets.assetsGithub,
          ),
          SizedBox(
            width: 5.h,
          ),
          SignInIcon(
            onTap: () => _launchOAuthUrl('discord'),
            image: Assets.assetsDiscord,
          ),
        ],
      ),
    );
  }
}
