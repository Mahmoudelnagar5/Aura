import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/home/presentation/manager/cubits/recent_uploads_cubit.dart';
import 'package:aura/features/home/presentation/manager/cubits/recent_uploads_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recent_item.dart';

class RecentItemsListView extends StatefulWidget {
  const RecentItemsListView({super.key});

  @override
  State<RecentItemsListView> createState() => _RecentItemsListViewState();
}

class _RecentItemsListViewState extends State<RecentItemsListView> {
  @override
  void initState() {
    super.initState();
    context.read<RecentUploadsCubit>().loadRecentUploads();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentUploadsCubit, RecentUploadsState>(
      builder: (context, state) {
        if (state is RecentUploadsLoaded) {
          final docs = state.docs;
          if (docs.isEmpty) {
            return Center(
              child: FittedBox(
                child: Text(
                  'No recent uploads yet.',
                  style: GoogleFonts.mali(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: RecentItem(doc: docs[index]),
            ),
            itemCount: docs.length,
          );
        } else if (state is RecentUploadsError) {
          return Text('Error: ${state.message}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
