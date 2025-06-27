import 'package:animate_do/animate_do.dart';
import 'package:aura/features/Auth/presentation/manger/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aura/core/utils/assets.dart';

import 'signin_icon.dart';

class SignInWithItems extends StatelessWidget {
  const SignInWithItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SignInIcon(
            onTap: () {
              context.read<AuthCubit>().loginWithGoogle();
            },
            image: Assets.assetsGoogle,
          ),
          SizedBox(
            width: 5.h,
          ),
          SignInIcon(
            onTap: () {
              context.read<AuthCubit>().loginWithGithub();
            },
            image: Assets.assetsGithub,
          ),
        ],
      ),
    );
  }
}
