import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../networking/api_constants.dart';
import 'custom_shimmer.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double radius;
  final bool isCircle;
  final bool displayError;
  final BoxFit fit;
  const CustomImage({
    super.key,
    required this.imageUrl,
    this.radius = 12,
    this.width = 100,
    this.height = 100,
    this.isCircle = false,
    this.fit = BoxFit.cover,
    this.displayError = true,
  });

  @override
  Widget build(BuildContext context) {
    return isCircle
        ? CircleAvatar(
            radius: radius,
            backgroundImage: CachedNetworkImageProvider(
              imageUrl == null
                  ? ''
                  : imageUrl!.contains('eg.api.weevoapp')
                      ? imageUrl!
                      : '${ApiConstants.baseUrl}$imageUrl',
            ),
            child: ClipOval(
              child: _buildImageWidget(),
            ),
          )
        : _buildImageWidget();
  }

  Widget _buildImageWidget() => Container(
        width: width.w,
        height: height.h,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(radius),
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl == null
              ? ''
              : imageUrl!.contains('eg.api.weevoapp')
                  ? imageUrl!
                  : '${ApiConstants.baseUrl}$imageUrl',
          fit: fit,
          placeholder: (context, url) => const CustomShimmer(),
          errorWidget: (context, url, error) => displayError
              ? Container(
                  width: width.w,
                  height: height.h,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: const Icon(Icons.error),
                )
              : const CustomShimmer(),
        ),
      );
}
