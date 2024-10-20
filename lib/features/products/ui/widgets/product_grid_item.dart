import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../../../core_new/helpers/spacing.dart';
import 'product_charge.dart';
import 'product_details.dart';
import 'product_image.dart';
import 'product_more_icon.dart';
import 'product_price_and_weight.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel product;
  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        width: context.width * 0.45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  product: product,
                ),
                PositionedDirectional(
                  top: 5.h,
                  end: 5.w,
                  child: ProductMoreIcon(
                    product: product,
                  ),
                ),
                PositionedDirectional(
                  bottom: 5.h,
                  end: 5.w,
                  start: 5.w,
                  child: ProductPriceAndWeight(
                    product: product,
                  ),
                ),
              ],
            ),
            verticalSpace(5),
            ProductDetails(product: product),
            verticalSpace(5),
            ProductCharge(product: product),
          ],
        ),
      ),
    );
  }
}
