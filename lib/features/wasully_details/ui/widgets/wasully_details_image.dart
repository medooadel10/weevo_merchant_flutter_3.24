import 'package:flutter/material.dart';

import '../../../../core_new/widgets/custom_image.dart';

class WasullyDetailsImage extends StatelessWidget {
  final String? image;
  const WasullyDetailsImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return CustomImage(
      imageUrl: image,
      width: double.infinity,
      height: 200,
      radius: 12,
    );
  }
}
