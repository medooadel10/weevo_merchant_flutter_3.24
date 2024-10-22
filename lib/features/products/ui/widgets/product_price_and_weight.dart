import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../../../core_new/helpers/spacing.dart';

class ProductPriceAndWeight extends StatelessWidget {
  final ProductModel product;
  const ProductPriceAndWeight({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5.0.w,
        vertical: 5.0.h,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey[500]!,
          )),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/money.svg',
                  height: 18.0.h,
                  width: 18.0.w,
                ),
                horizontalSpace(5.0),
                Expanded(
                  child: Text(
                    '${product.price} ج',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/weight.svg',
                  height: 18.0.h,
                  width: 18.0.w,
                ),
                horizontalSpace(5.0),
                Expanded(
                  child: Text(
                    '${product.weight.toString().toStringAsFixed0()} ك',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
