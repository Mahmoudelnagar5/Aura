import 'package:aura/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'privacy_policy'.tr(),
          style: GoogleFonts.mali(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero icon
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.privacy_tip_rounded,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'privacy_policy'.tr(),
                  style: GoogleFonts.sora(
                    fontSize: 19.5.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Card(
                  color: theme.cardColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'privacy_policy_content'.tr(),
                      style: GoogleFonts.mali(
                        fontSize: 13.sp,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Divider(
                    thickness: 1, color: theme.dividerColor.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  'privacy_policy_footer'.tr(),
                  style: GoogleFonts.sora(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
