import 'package:aura/core/helpers/functions/show_snake_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aura/core/widgets/gradient_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'dart:async';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routing/app_router.dart';
import '../manger/auth_cubit/auth_cubit.dart';

class OtpVerificationView extends StatelessWidget {
  final String email;
  const OtpVerificationView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(body: OtpVerficationBody(email: email)),
    );
  }
}

class OtpVerficationBody extends StatefulWidget {
  const OtpVerficationBody({super.key, required this.email});
  final String email;

  @override
  State<OtpVerficationBody> createState() => _OtpVerficationBodyState();
}

class _OtpVerficationBodyState extends State<OtpVerficationBody> {
  String otpCode = '';

  DateTime? codeSentTime;

  bool isResendEnabled = false;

  Timer? codeExpireTimer;

  Timer? resendEnableTimer;

  Timer? uiTimer;

  bool isCodeExpired = false;

  @override
  void initState() {
    super.initState();
    codeSentTime = DateTime.now();
    startTimers();

    uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void startTimers() {
    // Timer for code expiration (10 minutes)
    codeExpireTimer = Timer(const Duration(minutes: 10), () {
      setState(() {
        isCodeExpired = true;
      });
    });

    // Timer for enabling resend (30 minutes)
    resendEnableTimer = Timer(const Duration(seconds: 30), () {
      setState(() {
        isResendEnabled = true;
      });
    });
  }

  @override
  void dispose() {
    codeExpireTimer?.cancel();
    resendEnableTimer?.cancel();
    uiTimer?.cancel();
    super.dispose();
  }

  void resendCode() {
    // Call your resend code logic here (e.g., context.read<AuthCubit>().resendOtp(widget.email);)
    setState(() {
      codeSentTime = DateTime.now();
      isCodeExpired = false;
      isResendEnabled = false;
    });
    codeExpireTimer?.cancel();
    resendEnableTimer?.cancel();
    startTimers();
  }

  String getCodeExpireText() {
    if (isCodeExpired) return 'code_expired'.tr();
    final expireAt = codeSentTime!.add(const Duration(minutes: 10));
    final remaining = expireAt.difference(DateTime.now());
    final min = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = (remaining.inSeconds.remainder(60)).toString().padLeft(2, '0');
    return '${'code_valid_for'.tr()} $min:$sec';
  }

  String getResendText() {
    if (isResendEnabled) return 'resend_code'.tr();
    final resendAt = codeSentTime!.add(const Duration(seconds: 30));
    final remaining = resendAt.difference(DateTime.now());
    final min = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = (remaining.inSeconds.remainder(60)).toString().padLeft(2, '0');
    return '${'resend_code_in'.tr()} $min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showSnackBar(context, state.userModel.message, Colors.green);
          GoRouter.of(context).pushReplacement(AppRouter.homeView);
        } else if (state is AuthError) {
          showSnackBar(context, state.errMessage, Colors.red);
        }
      },
      builder: (context, state) {
        bool isVerifying = state is AuthLoading;
        return GradientBackground(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined,
                        size: 64.w, color: theme.colorScheme.primary),
                    SizedBox(height: 16.h),
                    Text(
                      'verify_email'.tr(),
                      style: GoogleFonts.mali(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'code_sent_to_email'.tr(),
                      style: GoogleFonts.sora(
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.email,
                      style: GoogleFonts.sora(
                        fontSize: 16.sp,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: OtpTextField(
                        numberOfFields: 6,
                        showFieldAsBox: true,
                        borderRadius: BorderRadius.circular(12.r),
                        fieldWidth: 45.w,
                        fieldHeight: 55.h,
                        cursorColor: theme.colorScheme.primary,
                        borderColor: theme.colorScheme.primary,
                        focusedBorderColor: theme.colorScheme.onSurface,
                        enabledBorderColor: theme.colorScheme.primary,
                        textStyle: GoogleFonts.cairo(
                          fontSize: 20.sp,
                          color: theme.colorScheme.onSurface,
                        ),
                        mainAxisAlignment: MainAxisAlignment.center,
                        onCodeChanged: (String code) {
                          setState(() {
                            otpCode = code;
                          });
                        },
                        onSubmit: (String code) {
                          setState(() {
                            otpCode = code;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 23.w,
                            color: isCodeExpired
                                ? Colors.red
                                : theme.colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          getCodeExpireText(),
                          style: GoogleFonts.sora(
                            fontSize: 14.sp,
                            color: isCodeExpired
                                ? Colors.red
                                : theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: isResendEnabled
                          ? () {
                              resendCode();
                              // Call your resend logic here
                            }
                          : null,
                      child: Text(
                        getResendText(),
                        style: GoogleFonts.sora(
                          color: isResendEnabled
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14.sp,
                          decorationColor: theme.colorScheme.primary,
                          decoration:
                              isResendEnabled ? TextDecoration.underline : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed:
                            isVerifying || otpCode.length != 6 || isCodeExpired
                                ? null
                                : () {
                                    context
                                        .read<AuthCubit>()
                                        .emailVerify(widget.email, otpCode);
                                  },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isVerifying
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: CircularProgressIndicator(
                                  color: theme.colorScheme.onPrimary,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'verify'.tr(),
                                style: GoogleFonts.mali(
                                  fontSize: 18.sp,
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
