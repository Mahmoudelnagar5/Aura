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
    return CachedProfileImage(
      key: ValueKey(imageUrl),
      imageUrl: imageUrl,
      radius: 45.r,
    );
  }
}
