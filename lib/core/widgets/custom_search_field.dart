import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.onChanged,
  });
  final void Function(String query)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(
          IconlyLight.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        border: outlineInputBorder(context),
        focusedBorder: outlineInputBorder(context),
        label: Text(
          "search".tr(),
          style: GoogleFonts.mali(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  GradientOutlineInputBorder outlineInputBorder(BuildContext context) {
    return GradientOutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.primary.withOpacity(0.7),
          Theme.of(context).colorScheme.primary,
        ],
      ),
      width: 2,
    );
  }
}
