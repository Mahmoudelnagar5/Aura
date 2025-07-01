import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
  // Spacing
  static double get spacing4 => 4.w;
  static double get spacing8 => 8.w;
  static double get spacing12 => 12.w;
  static double get spacing16 => 16.w;
  static double get spacing20 => 20.w;
  static double get spacing24 => 24.w;
  static double get spacing32 => 32.w;
  static double get spacing40 => 40.w;
  static double get spacing48 => 48.w;
  static double get spacing64 => 64.w;

  // Border radius
  static double get radiusSmall => 4.r;
  static double get radiusMedium => 8.r;
  static double get radiusLarge => 12.r;
  static double get radiusXLarge => 16.r;
  static double get radiusXXLarge => 24.r;

  // Icon sizes
  static double get iconSmall => 16.sp;
  static double get iconMedium => 20.sp;
  static double get iconLarge => 24.sp;
  static double get iconXLarge => 32.sp;

  // Avatar sizes
  static double get avatarSmall => 32.r;
  static double get avatarMedium => 40.r;
  static double get avatarLarge => 60.r;
  static double get avatarXLarge => 80.r;

  // Button heights
  static double get buttonHeightSmall => 32.h;
  static double get buttonHeightMedium => 40.h;
  static double get buttonHeightLarge => 48.h;

  // Input field heights
  static double get inputHeightSmall => 40.h;
  static double get inputHeightMedium => 48.h;
  static double get inputHeightLarge => 56.h;

  // Card padding
  static double get cardPaddingSmall => 12.w;
  static double get cardPaddingMedium => 16.w;
  static double get cardPaddingLarge => 24.w;

  // Screen padding
  static double get screenPaddingHorizontal => 16.w;
  static double get screenPaddingVertical => 16.h;

  // Bottom sheet padding
  static double get bottomSheetPadding => 24.w;
  static double get bottomSheetTopPadding => 24.h;
  static double get bottomSheetBottomPadding => 24.h;

  // Animation durations
  static Duration get animationFast => const Duration(milliseconds: 200);
  static Duration get animationMedium => const Duration(milliseconds: 300);
  static Duration get animationSlow => const Duration(milliseconds: 500);
}
