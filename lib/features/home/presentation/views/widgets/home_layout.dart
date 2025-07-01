import 'package:aura/features/profile/presentation/manager/user_profile_cubit/delete_account_cubit.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/get_user_cubit.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';

import 'package:aura/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../profile/presentation/manager/user_profile_cubit/logout_cubit.dart';
import '../../../../summary/presentation/views/summary_view.dart';
import '../../manager/cubits/recent_uploads_cubit.dart';
import '../../views/home_view.dart';
import 'custom_app_bar.dart';
import 'custom_nav_bar.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeView(),
    const SummaryView(),
    const ProfileView(),
  ];

  final List<PreferredSizeWidget> _appBars = [
    const CustomAppBar(),
    AppBar(
      title: Text(
        'Summary',
        style: GoogleFonts.mali(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xff0D141C),
        ),
      ),
      // backgroundColor: Color(0xff390050),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    AppBar(
      title: Text(
        'Profile',
        style: GoogleFonts.mali(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xff0D141C),
        ),
      ),
      // backgroundColor: Color(0xff390050),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
  ];

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
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBars[_currentIndex],
        body: _pages[_currentIndex],
        bottomNavigationBar: CustomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
