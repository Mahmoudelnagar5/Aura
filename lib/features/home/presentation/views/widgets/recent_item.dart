import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aura/features/home/data/models/recent_doc_model.dart';
import 'package:open_file/open_file.dart';

import '../../../../../core/helpers/functions/show_snake_bar.dart';

class RecentItem extends StatelessWidget {
  final RecentDocModel doc;
  const RecentItem({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final path = doc.path;
        if (path.endsWith('.pdf') || path.endsWith('.docx')) {
          final result = await OpenFile.open(path);
          if (result.type != ResultType.done) {
            showSnackBar(
              context,
              'Failed to open file',
              Colors.red,
            );
          }
        } else {
          showSnackBar(
            context,
            'Unsupported file type',
            Colors.red,
          );
        }
      },
      child: FadeInLeft(
        duration: const Duration(milliseconds: 500),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 40.w,
            height: 60.h,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color(0xffE8EDF5),
            ),
            child: Icon(
              IconlyLight.document,
              color: Colors.grey,
              size: 25.sp,
            ),
          ),
          title: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              doc.name,
              style: GoogleFonts.sora(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          subtitle: Text(
            'Uploaded ${doc.uploadDate.day}/${doc.uploadDate.month}/${doc.uploadDate.year}',
            style: GoogleFonts.mali(
              fontSize: 12.sp,
              color: const Color(0xff4A709C),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
