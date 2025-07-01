import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/core/di/service_locator.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/get_user_cubit.dart';

import 'widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _loadUserProfileData();
  }

  Future<void> _loadUserProfileData() async {
    // Check if user profile is already cached
    final userCacheHelper = getIt<UserCacheHelper>();
    if (!userCacheHelper.hasValidUserProfile()) {
      // Get the existing GetUserCubit from the context and fetch user profile
      final getUserCubit = context.read<GetUserCubit>();
      getUserCubit.getUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetUserCubit, GetUserState>(
      listener: (context, state) {
        if (state is GetUserSuccess) {
          // Cache the user profile data
          final userCacheHelper = getIt<UserCacheHelper>();
          userCacheHelper.saveUserProfile(state.userProfile);
        }
      },
      child: const HomeViewBody(),
    );
  }
}
