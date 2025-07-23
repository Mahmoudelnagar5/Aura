import 'package:animate_do/animate_do.dart';
import 'package:aura/features/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'upload_file_container.dart';
import 'recent_items_list_view.dart';
import 'package:aura/core/widgets/gradient_background.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<State<RecentItemsListView>> recentListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final state = recentListKey.currentState;
      if (state != null) {
        (state as dynamic).triggerLoadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          FadeIn(
            duration: const Duration(milliseconds: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(),
                SizedBox(height: 5.h),
                Text(
                  'upload_your_document'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'drag_and_drop'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16.h),
                const UploadFileContainer(),
                SizedBox(height: 16.h),
                Text(
                  'recent_uploads'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
          RecentItemsListView(key: recentListKey),
          SizedBox(height: 55.h),
        ],
      ),
    );
  }
}
