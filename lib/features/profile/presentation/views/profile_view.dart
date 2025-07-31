import 'package:animate_do/animate_do.dart';
import 'package:aura/core/helpers/database/user_cache_helper.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/update_profile_cubit.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/logout_cubit.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/delete_account_cubit.dart';
import 'package:aura/features/profile/presentation/views/widgets/image_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/helpers/functions/show_snake_bar.dart';
import '../../../../core/themes/theme_state.dart';
import 'about_study_buddy_view.dart';
import 'functions/show_logout_dialog.dart';
import 'functions/show_edit_profile_sheet.dart';
import 'functions/show_change_password_sheet.dart';
import 'functions/show_delete_account_dialog.dart';
import 'privacy_policy_view.dart';
import 'widgets/profile_menu_item.dart';
import '../../../../core/themes/theme_cubit.dart';
import '../../../../core/widgets/gradient_background.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    // Cubits are now provided by MultiBlocProvider in home_layout.dart
    final updateProfileCubit = context.read<UpdateProfileCubit>();
    final logoutCubit = context.read<LogoutCubit>();
    final deleteAccountCubit = context.read<DeleteAccountCubit>();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              // The cache has been updated by the cubit.
              // We just need to trigger a rebuild of this widget
              // to read the new data from the cache.
              setState(() {});
            }
          },
        ),
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, logoutState) {
            if (logoutState is LogoutSuccess) {
              showSnackBar(context, 'Logged out successfully!', Colors.green);
            } else if (logoutState is LogoutError) {
              showSnackBar(context, logoutState.errMessage, Colors.red);
            }
          },
        ),
      ],
      child: GradientBackground(
        child: Column(
          children: [
            // Custom App Bar for Profile
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SafeArea(
                bottom: false,
                child: Text(
                  'profile'.tr(),
                  style: GoogleFonts.mali(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
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
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.color,
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
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: isDark
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color(0xff390050)),
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
                        SizedBox(height: 20.h),
                        // Settings Section
                        Text(
                          'settings'.tr(),
                          style: GoogleFonts.sura(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, themeState) {
                            return ProfileMenuItem(
                              title: 'theme_mode'.tr(),
                              icon: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Icons.nightlight_round
                                  : Icons.wb_sunny,
                              trailing: DropdownButton<ThemeMode>(
                                value: ThemeCubit.get(context).getTheme(),
                                underline: const SizedBox(),
                                items: [
                                  DropdownMenuItem(
                                    value: ThemeMode.system,
                                    child: Text(
                                      'system_mode'.tr(),
                                      style: GoogleFonts.mali(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: ThemeMode.light,
                                    child: Text(
                                      'light_mode'.tr(),
                                      style: GoogleFonts.mali(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: ThemeMode.dark,
                                    child: Text(
                                      'dark_mode'.tr(),
                                      style: GoogleFonts.mali(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (mode) {
                                  if (mode != null) {
                                    ThemeCubit.get(context).selectTheme(
                                      ThemeModeState.values.firstWhere(
                                        (element) => element.name == mode.name,
                                        orElse: () => ThemeModeState.system,
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 12.h),
                        // Language Switcher
                        ProfileMenuItem(
                          title: 'language'.tr(),
                          icon: Icons.language,
                          trailing: DropdownButton<Locale>(
                            value: context.locale,
                            underline: const SizedBox(),
                            items: [
                              DropdownMenuItem(
                                value: const Locale('en'),
                                child: Text(
                                  'english'.tr(),
                                  style: GoogleFonts.mali(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: const Locale('ar'),
                                child: Text(
                                  'arabic'.tr(),
                                  style: GoogleFonts.mali(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (locale) {
                              if (locale != null) {
                                context.setLocale(locale);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Account Section
                        Text(
                          'account'.tr(),
                          style: GoogleFonts.sura(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ProfileMenuItem(
                          title: 'change_password'.tr(),
                          icon: Icons.lock_outline,
                          onTap: () {
                            showChangePasswordSheet(context);
                          },
                        ),
                        SizedBox(height: 12.h),
                        BlocBuilder<LogoutCubit, LogoutState>(
                          builder: (context, logoutState) {
                            return ProfileMenuItem(
                              title: 'logout'.tr(),
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
                              title: 'delete_account'.tr(),
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
                          'about'.tr(),
                          style: GoogleFonts.sura(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ProfileMenuItem(
                          title: 'about_study_buddy'.tr(),
                          icon: Icons.info_outline,
                          onTap: () {
                            Navigator.of(context).push(
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const AboutStudyBuddyView(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 12.h),
                        ProfileMenuItem(
                          title: 'privacy_policy'.tr(),
                          icon: Icons.privacy_tip_outlined,
                          onTap: () {
                            Navigator.of(context).push(
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const PrivacyPolicyView(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 55.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
