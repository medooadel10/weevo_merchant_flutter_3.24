import 'package:flutter/material.dart';

import '../../../../core_new/widgets/custom_image.dart';
import '../../data/models/products_response_body_model.dart';

class ProductImage extends StatelessWidget {
  final ProductModel product;
  const ProductImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return CustomImage(
      imageUrl: product.image,
      width: double.infinity,
      height: 140.0,
    );
  }
}
