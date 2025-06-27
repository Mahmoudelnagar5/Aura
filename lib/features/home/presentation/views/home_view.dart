import 'package:aura/core/di/service_locator.dart';
import 'package:aura/features/home/presentation/manager/cubits/recent_uploads_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecentUploadsCubit>(),
      child: HomeViewBody(),
    );
  }
}
