import 'package:flutter/material.dart';
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Camera',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              onTap: () {
                Navigator.pop(context);
                updateProfileCubit.pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Gallery',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
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
