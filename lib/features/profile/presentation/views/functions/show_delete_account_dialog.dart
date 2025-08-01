import 'package:aura/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/profile/presentation/manager/user_profile_cubit/delete_account_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/helpers/functions/show_snake_bar.dart';

void showDeleteAccountDialog(
    BuildContext context, DeleteAccountCubit deleteAccountCubit) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    animType: AnimType.bottomSlide,
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 20),
          FittedBox(
            child: Text(
              'delete_account'.tr(),
              style: GoogleFonts.sura(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'delete_account_confirm'.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.mali(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      'cancel'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    // Show loading dialog
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.noHeader,
                      animType: AnimType.bottomSlide,
                      body: BlocProvider<DeleteAccountCubit>.value(
                        value: deleteAccountCubit,
                        child: BlocConsumer<DeleteAccountCubit,
                            DeleteAccountState>(
                          listener: (context, state) {
                            if (state is DeleteAccountSuccess) {
                              // Navigate to onboarding screen
                              context.pushReplacement(AppRouter.onBoardingView);
                              showSnackBar(
                                  context,
                                  'Account deleted successfully!',
                                  Colors.green);
                            } else if (state is DeleteAccountError) {
                              Navigator.of(context)
                                  .pop(); // Close loading dialog
                              showSnackBar(
                                  context, state.errMessage, Colors.red);
                            }
                          },
                          builder: (context, state) {
                            if (state is DeleteAccountLoading) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.red),
                                    ),
                                    const SizedBox(height: 20),
                                    FittedBox(
                                      child: Text(
                                        'Deleting account...',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ).show();

                    // Start the delete account process
                    deleteAccountCubit.deleteAccount();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      'delete_account'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    headerAnimationLoop: false,
  ).show();
}
