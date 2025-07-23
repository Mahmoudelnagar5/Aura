import 'package:aura/features/home/data/models/recent_doc_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aura/features/home/presentation/manager/cubits/recent_uploads_cubit.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/helpers/functions/show_snake_bar.dart';

class BrowseFileButtton extends StatelessWidget {
  const BrowseFileButtton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Pick a file (pdf, pptx, docx)
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        // Check if a file was picked and the path is valid
        if (result != null &&
            result.files.isNotEmpty &&
            result.files.single.path != null) {
          final file = File(result.files.single.path!);

          // Optionally, check if the file actually exists on disk
          if (await file.exists()) {
            context.read<RecentUploadsCubit>().uploadDoc(file);

            context.read<RecentUploadsCubit>().addRecentUpload(RecentDocModel(
                name: result.files.single.name,
                path: result.files.single.path!,
                uploadDate: DateTime.now()));

            showSnackBar(context, 'uploaded_successfully'.tr(), Colors.green);
          } else {
            showSnackBar(context, 'file_does_not_exist'.tr(), Colors.red);
          }
        } else {
          showSnackBar(context, 'file_not_found'.tr(), Colors.red);
        }
      },
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: FittedBox(
          child: Text(
            'browse_file'.tr(),
            style: GoogleFonts.mali(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
