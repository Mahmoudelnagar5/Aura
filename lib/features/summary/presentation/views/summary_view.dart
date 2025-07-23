import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/helpers/database/summary_cache_helper.dart';
import '../../../../core/widgets/custom_search_field.dart';
import '../../data/models/summary_model.dart';
import 'widgets/list_view_summries.dart';
import 'package:aura/core/widgets/gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  List<Summary> _summaries = [];
  bool _loading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadSummaries();
  }

  Future<void> _loadSummaries() async {
    final loaded = await SummaryPrefs.getSummaries();
    setState(() {
      _summaries = loaded;
      _loading = false;
    });
  }

  Future<void> _deleteSummary(int index) async {
    await SummaryPrefs.removeSummary(index);
    setState(() {
      _summaries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredSummaries = _summaries
        .where((summary) =>
            summary.docName.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
    return GradientBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  bottom: false,
                  child: Text(
                    'my_summaries'.tr(),
                    style: GoogleFonts.mali(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            CustomSearchField(
              onChanged: (val) {
                setState(() {
                  _searchText = val;
                });
              },
            ),
            Expanded(
              child: _loading
                  ? Center(
                      child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff390050),
                      ),
                      child: Center(
                        child: LoadingAnimationWidget.inkDrop(
                          color: Colors.white,
                          size: 24.w,
                        ),
                      ),
                    ))
                  : filteredSummaries.isEmpty
                      ? Center(
                          child: Lottie.asset(
                              'assets/Animation - 1751218757272.json'))
                      : ListViewSummaries(
                          summaries: filteredSummaries,
                          onDelete: (summary) async {
                            final originalIndex = _summaries.indexOf(summary);
                            await _deleteSummary(originalIndex);
                          },
                        ),
            ),
            SizedBox(height: 55.h),
          ],
        ),
      ),
    );
  }
}
