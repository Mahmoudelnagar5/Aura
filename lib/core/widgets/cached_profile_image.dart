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
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildImage(context),
    );
  }

  Widget _buildImage(BuildContext context) {
    // If no URL provided, show default avatar
    if (imageUrl == null || imageUrl!.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          Assets.assetsAvatar,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          filterQuality: FilterQuality.high,
        ),
      );
    }

    // If URL is an asset path, show asset image
    if (imageUrl!.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          imageUrl!,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          filterQuality: FilterQuality.high,
        ),
      );
    }

    // Show cached network image for URLs
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        placeholder: (context, url) =>
            placeholder ?? _buildShimmerLoader(context),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildErrorWidget(context),
        memCacheWidth: (radius * 32).toInt(),
        memCacheHeight: (radius * 32).toInt(),
        maxWidthDiskCache: (radius * 32).toInt(),
        maxHeightDiskCache: (radius * 32).toInt(),
        filterQuality: FilterQuality.high,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildShimmerLoader(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(
        Icons.person,
        size: radius * 0.8,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
    );
  }
}
