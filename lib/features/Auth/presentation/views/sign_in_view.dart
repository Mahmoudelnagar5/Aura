import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../manger/auth_cubit/auth_cubit.dart';
import 'widgets/signin_view_body.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const Scaffold(
        body: SignInViewBody(),
      ),
    );
  }
}
