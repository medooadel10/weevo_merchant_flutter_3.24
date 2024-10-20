import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../../../core_new/helpers/spacing.dart';

class ProductCharge extends StatelessWidget {
  final ProductModel product;
  const ProductCharge({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return WeevoButton(
      onTap: () {},
      color: const Color(0xFFD8F3FF),
      isStable: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/new_icon.png',
            color: weevoPrimaryBlueColor,
            height: 25.h,
            width: 25.w,
          ),
          horizontalSpace(5),
          Text(
            'اشحن',
            style: TextStyle(
              fontSize: 12.0.sp,
              color: weevoPrimaryBlueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
