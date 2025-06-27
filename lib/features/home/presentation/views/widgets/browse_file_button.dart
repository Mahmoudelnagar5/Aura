import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BrowseFileButtton extends StatelessWidget {
  const BrowseFileButtton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (kIsWeb) {
          // Web-specific file picking logic (file_picker supports web, but check docs for limitations)
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'docx'],
            withData: true, // Needed for web to get file bytes
          );
          if (result != null && result.files.isNotEmpty) {
            final fileName = result.files.single.name;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected file: $fileName')),
            );
            // Handle file bytes: result.files.single.bytes
          }
        } else {
          // Mobile/desktop logic
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'docx'],
          );
          if (result != null && result.files.isNotEmpty) {
            final fileName = result.files.single.name;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected file: $fileName')),
            );
            // Handle file path: result.files.single.path
          }
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
