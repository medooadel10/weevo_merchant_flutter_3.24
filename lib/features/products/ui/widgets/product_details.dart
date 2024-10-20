import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_image.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;
  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              verticalSpace(8),
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        horizontalSpace(5),
        Column(
          children: [
            CustomImage(
              imageUrl: product.productCategory.image,
              displayError: false,
              isCircle: true,
              radius: 16,
            ),
            Text(
              product.productCategory.name,
              style: TextStyle(
                fontSize: 12.0.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    ).paddingSymmetric(
      horizontal: 10.w,
      vertical: 5.h,
    );
  }
}
