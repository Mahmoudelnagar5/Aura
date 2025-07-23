import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../../data/models/summary_model.dart';
import '../full_summary_view.dart';
import 'package:easy_localization/easy_localization.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.summary,
  });

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(16)),
      // elevation: 5,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    summary.docName,
                    style: GoogleFonts.mali(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  summary.uploadDate,
                  style: GoogleFonts.mali(
                    fontSize: 14.sp,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              summary.summaryText,
              style: GoogleFonts.mali(
                fontSize: 14.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: FullSummaryView(
                        summary: summary.summaryText,
                      ),
                    ),
                  );
                },
                child: Text(
                  'view_full_summary'.tr(),
                  style: GoogleFonts.mali(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Theme.of(context).colorScheme.onPrimary,
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
