import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/home/presentation/manager/cubits/recent_uploads_cubit.dart';
import 'package:aura/features/home/presentation/manager/cubits/recent_uploads_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'recent_item.dart';
import 'package:easy_localization/easy_localization.dart';

class RecentItemsListView extends StatefulWidget {
  const RecentItemsListView({super.key});

  @override
  State<RecentItemsListView> createState() => _RecentItemsListViewState();
}

class _RecentItemsListViewState extends State<RecentItemsListView> {
  String? lastRequestedCursor;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    context.read<RecentUploadsCubit>().loadRecentUploads();
  }

  void triggerLoadMore() {
    final state = context.read<RecentUploadsCubit>().state;
    if (state is RecentUploadsLoaded) {
      final canLoadMore = state.nextCursor != null &&
          lastRequestedCursor != state.nextCursor &&
          !isLoadingMore;
      if (canLoadMore) {
        _loadMore(state);
      }
    }
  }

  Future<void> _loadMore(RecentUploadsLoaded state) async {
    setState(() {
      isLoadingMore = true;
    });
    await context.read<RecentUploadsCubit>().loadMoreUploads();
    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentUploadsCubit, RecentUploadsState>(
      builder: (context, state) {
        if (state is RecentUploadsLoaded) {
          final docs = state.docs;
          final cacheDocs = state.cacheDocs;
          if (docs.isEmpty) {
            return Center(
              child: FittedBox(
                child: Text(
                  'no_recent_uploads'.tr(),
                  style: GoogleFonts.mali(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }
          return Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: docs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final cacheDoc =
                      index < cacheDocs.length ? cacheDocs[index] : null;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: RecentItem(
                      doc: docs[index],
                      docCache: cacheDoc,
                    ),
                  );
                },
              ),
              if (isLoadingMore)
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                        child: Container(
                      margin: const EdgeInsets.only(top: 35),
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Center(
                        child: LoadingAnimationWidget.beat(
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24.w,
                        ),
                      ),
                    ))),
            ],
          );
        } else if (state is RecentUploadsError) {
          return Center(
              child: Text(state.message,
                  style: GoogleFonts.mali(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  )));
        }
        return Center(
            child: Container(
          margin: const EdgeInsets.only(top: 35),
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Center(
            child: LoadingAnimationWidget.beat(
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24.w,
            ),
          ),
        ));
      },
    );
  }
}
