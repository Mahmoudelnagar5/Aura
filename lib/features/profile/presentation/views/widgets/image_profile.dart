import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/cached_profile_image.dart';

class ImageProfile extends StatelessWidget {
  const ImageProfile({
    super.key,
    this.imageUrl,
  });
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xff390050),
            Color(0xff6A0DAD),
          ],
        ),
      ),
      child: CachedProfileImage(
        key: ValueKey(imageUrl),
        imageUrl: imageUrl,
        radius: 45.r,
      ),
    );
  }
}
