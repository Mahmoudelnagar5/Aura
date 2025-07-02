import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/assets.dart';

class CachedProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final BoxShape shape;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedProfileImage({
    super.key,
    this.imageUrl,
    this.radius = 40,
    this.backgroundColor,
    this.shape = BoxShape.circle,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor ?? Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    // If no URL provided, show default avatar
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Image.asset(
        Assets.assetsAvatar,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );
    }

    // If URL is an asset path, show asset image
    if (imageUrl!.startsWith('assets/')) {
      return Image.asset(
        imageUrl!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );
    }

    // Show cached network image for URLs
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      width: radius * 2,
      height: radius * 2,
      placeholder: (context, url) => placeholder ?? _buildShimmerLoader(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
      memCacheWidth: (radius * 2).toInt(),
      memCacheHeight: (radius * 2).toInt(),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: radius * 0.8,
        color: Colors.grey.shade400,
      ),
    );
  }
}
