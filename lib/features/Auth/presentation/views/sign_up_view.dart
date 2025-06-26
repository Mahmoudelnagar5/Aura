import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/helpers/functions/show_snake_bar.dart';
import '../../../../core/routing/app_router.dart';
import '../manger/auth_cubit/auth_cubit.dart';
import 'widgets/signup_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SignupViewBodyBlocConsumer(),
      ),
    );
  }
}

class SignupViewBodyBlocConsumer extends StatelessWidget {
  const SignupViewBodyBlocConsumer({
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
          context.pushReplacement(AppRouter.signInView);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is AuthLoading,
          child: const SignUpViewBody(),
        );
      },
    );
  }
}
