import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import 'product_grid_item.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;
  const ProductsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10.0.h,
        horizontal: 10.0.w,
      ),
      child: Wrap(
        spacing: 10.0.w,
        runSpacing: 10.0.h,
        children: List.generate(
          products.length,
          (index) => ProductGridItem(
            product: products[index],
          ),
        ),
      ),
    );
  }
}
