import 'package:aura/core/helpers/functions/show_snake_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:aura/core/widgets/gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';

class FullSummaryView extends StatelessWidget {
  const FullSummaryView({super.key, required this.summary});
  final String summary;
  @override
  Widget build(BuildContext context) {
    final List<String> summaryPoints = summary.contains('•')
        ? summary.split('•').where((e) => e.trim().isNotEmpty).toList()
        : [summary];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'summary'.tr(),
          style: GoogleFonts.mali(
            fontSize: 20.sp,
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
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Theme.of(context).cardColor,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            Icons.summarize,
                            size: 40,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'document_summary'.tr(),
                          style: GoogleFonts.sora(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...summaryPoints.map(
                          (point) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (summaryPoints.length > 1)
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8, right: 12),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    point.trim(),
                                    style: GoogleFonts.sora(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: summary));
                                  showSnackBar(
                                      context,
                                      'copied'.tr(),
                                      Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6));
                                },
                                icon: Icon(
                                  Icons.copy,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                label: Text(
                                  'copy'.tr(),
                                  style: GoogleFonts.sora(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Share.share(summary,
                                      subject: 'Document Summary');
                                },
                                icon: Icon(
                                  Icons.share,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                label: Text(
                                  'share'.tr(),
                                  style: GoogleFonts.sora(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
