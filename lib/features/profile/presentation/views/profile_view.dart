import 'package:animate_do/animate_do.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/core/widgets/cached_profile_image.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/logout_cubit.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/delete_account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/helpers/functions/show_logout_dialog.dart';
import 'functions/show_edit_profile_sheet.dart';
import 'functions/show_change_password_sheet.dart';
import 'functions/show_delete_account_dialog.dart';
import 'widgets/profile_menu_item.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
/*************  ✨ Windsurf Command ⭐  *************/
  /// Builds the profile view.
  ///
  /// The profile view is a scrollable view that shows the user's profile information,
  /// as well as a list of menu items for various settings and actions.
  ///
  /// The view is divided into three sections: Settings, Account, and About.
  /// The Settings section contains menu items for changing the app's theme,
  /// The Account section contains menu items for changing the user's password,
  /// logging out, and deleting the account.
  /// The About section contains menu items for viewing the app's about page
  /// and privacy policy.
  ///
  /// The view also shows a loading indicator when the user is logging out or
  /// deleting their account.
  /// *****  11290219-a5ea-4b1e-b4cd-ec3d28b51043  ******
  Widget build(BuildContext context) {
    // Cubits are now provided by MultiBlocProvider in home_layout.dart
    final updateProfileCubit = context.read<UpdateProfileCubit>();
    final logoutCubit = context.read<LogoutCubit>();
    final deleteAccountCubit = context.read<DeleteAccountCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              // The cache has been updated by the cubit.
              // We just need to trigger a rebuild of this widget
              // to read the new data from the cache.
              setState(() {});
            } else if (state is UpdateProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, logoutState) {
            if (logoutState is LogoutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (logoutState is LogoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(logoutState.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<DeleteAccountCubit, DeleteAccountState>(
          listener: (context, deleteAccountState) {
            if (deleteAccountState is DeleteAccountSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deleted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (deleteAccountState is DeleteAccountError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(deleteAccountState.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageProfile(
                        imageUrl: getIt<UserCacheHelper>()
                            .getUserProfile()
                            ?.userProfileImageUrl,
                      ),
                      SizedBox(width: 17.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                '${getIt<UserCacheHelper>().getUserName()}',
                                style: GoogleFonts.sura(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff0D141C),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              child: Text(
                                getIt<UserCacheHelper>().getUserEmail() ??
                                    'No email available',
                                style: GoogleFonts.mali(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff0D141C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xff390050)),
                        onPressed: () {
                          final userProfile =
                              getIt<UserCacheHelper>().getUserProfile();
                          if (userProfile != null) {
                            showEditProfileSheet(
                                context, userProfile, updateProfileCubit);
                          }
                        },
                        tooltip: 'Edit Profile',
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  // Settings Section
                  Text(
                    'Settings',
                    style: GoogleFonts.sura(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff0D141C),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    title: 'Dark Mode',
                    onTap: () {},
                    icon: Icons.dark_mode_outlined,
                  ),
                  // Account Section
                  Text(
                    'Account',
                    style: GoogleFonts.sura(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff0D141C),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    title: 'Change Password',
                    icon: Icons.lock_outline,
                    onTap: () {
                      showChangePasswordSheet(context);
                    },
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<LogoutCubit, LogoutState>(
                    builder: (context, logoutState) {
                      return ProfileMenuItem(
                        title: 'Log Out',
                        color: Colors.orange,
                        icon: Icons.logout,
                        onTap: logoutState is LogoutLoading
                            ? () {}
                            : () {
                                showLogoutDialog(context, logoutCubit);
                              },
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                    builder: (context, deleteAccountState) {
                      return ProfileMenuItem(
                        title: 'Delete Account',
                        icon: IconlyBold.delete,
                        color: const Color(0xffFF0000),
                        onTap: deleteAccountState is DeleteAccountLoading
                            ? () {}
                            : () {
                                showDeleteAccountDialog(
                                    context, deleteAccountCubit);
                              },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  // About Section
                  Text(
                    'About',
                    style: GoogleFonts.sura(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff0D141C),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    title: 'About Study Buddy',
                    icon: Icons.info_outline,
                    onTap: () {},
                  ),
                  SizedBox(height: 12.h),
                  ProfileMenuItem(
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class ImageProfile extends StatelessWidget {
  const ImageProfile({
    super.key,
    this.imageUrl,
  });
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xff390050),
            Color(0xff6A0DAD),
          ],
        ),
      ),
      child: CachedProfileImage(
        key: ValueKey(imageUrl),
        imageUrl: imageUrl,
        radius: 45.r,
      ),
    );
  }
}
