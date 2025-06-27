import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/home/presentation/manager/cubits/recent_uploads_cubit.dart';
import 'package:aura/features/home/data/models/recent_doc_model.dart';

class BrowseFileButtton extends StatelessWidget {
  const BrowseFileButtton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        FilePickerResult? result;
        if (kIsWeb) {
          result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'docx'],
            withData: true,
          );
        } else {
          result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'docx'],
          );
        }
        if (result != null && result.files.isNotEmpty) {
          final file = result.files.single;
          final fileName = file.name;
          final filePath = kIsWeb ? file.name : file.path ?? file.name;
          final uploadDate = DateTime.now();
          final doc = RecentDocModel(
              name: fileName, path: filePath, uploadDate: uploadDate);
          context.read<RecentUploadsCubit>().addRecentUpload(doc);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to recent uploads: $fileName')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.grey,
        backgroundColor: const Color(0xff390050),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Text(
          'Browse File',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
