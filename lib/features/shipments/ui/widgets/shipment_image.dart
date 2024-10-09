import 'package:flutter/material.dart';

import '../../../../core_new/widgets/custom_image.dart';

class ShipmentImage extends StatelessWidget {
  final String? image;
  const ShipmentImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return CustomImage(
      imageUrl: image,
    );
  }
}
