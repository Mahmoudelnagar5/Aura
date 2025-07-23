import 'package:aura/features/profile/presentation/manager/user_profile_cubit/delete_account_cubit.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/get_user_cubit.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';

import 'package:aura/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../profile/presentation/manager/user_profile_cubit/logout_cubit.dart';
import '../../../../summary/presentation/views/summary_view.dart';
import '../../manager/cubits/recent_uploads_cubit.dart';
import '../../views/home_view.dart';
import 'custom_nav_bar.dart';
import 'package:aura/features/summary/presentation/manger/summary_cubit/summary_cubit.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;
  late final PageController _pageController;

  final List<Widget> _pages = [
    const HomeView(),
    const SummaryView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<RecentUploadsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<GetUserCubit>()..getUserProfile(),
        ),
        BlocProvider(
          create: (context) => getIt<UpdateProfileCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<LogoutCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<DeleteAccountCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<SummaryCubit>(),
        ),
      ],
      child: Scaffold(
        extendBody: true,
        // backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const BouncingScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavBarTap,
        ),
      ),
    );
  }
}
