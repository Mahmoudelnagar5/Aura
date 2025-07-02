import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../manager/user_profile_cubit/update_profile_cubit.dart';

void showImagePickerDialog(
    BuildContext context, UpdateProfileCubit updateProfileCubit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Choose Image Source',
          style: GoogleFonts.sura(
            fontWeight: FontWeight.bold,
            color: const Color(0xff0D141C),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xff390050)),
              title: Text(
                'Camera',
                style: GoogleFonts.mali(color: const Color(0xff0D141C)),
              ),
              onTap: () {
                Navigator.pop(context);
                updateProfileCubit.pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Color(0xff390050)),
              title: Text(
                'Gallery',
                style: GoogleFonts.mali(color: const Color(0xff0D141C)),
              ),
              onTap: () {
                Navigator.pop(context);
                updateProfileCubit.pickImage(source: ImageSource.gallery);
              },
            ),
          ],
        ),
      );
    },
  );
}
