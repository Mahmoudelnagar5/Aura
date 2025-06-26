import 'package:aura/core/helpers/database/cache_helper.dart';
import 'package:aura/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/helpers/functions/show_snake_bar.dart';
import '../../../../core/utils/constanst.dart';
import '../manger/auth_cubit/auth_cubit.dart';
import 'widgets/signin_view_body.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SignInViewBodyBlocConsumer(),
      ),
    );
  }
}

class SignInViewBodyBlocConsumer extends StatelessWidget {
  const SignInViewBodyBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showSnackBar(context, state.errMessage, Colors.red);
        }
        if (state is AuthSuccess) {
          showSnackBar(context, state.userModel.message, Colors.green);

          // Save is logged in to cache
          getIt<CacheHelper>().saveData(
            key: CacheKeys.isLoggedIn,
            value: true,
          );
          context.pushReplacement(AppRouter.homeView);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is AuthLoading,
          child: const SignInViewBody(),
        );
      },
    );
  }
}
