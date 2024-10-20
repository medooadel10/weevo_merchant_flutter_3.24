import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_shimmer.dart';

class ProductItemLoading extends StatelessWidget {
  const ProductItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CustomShimmer(
              height: 140.h,
            ),
          ],
        ),
        verticalSpace(5),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  CustomShimmer(
                    height: 10.h,
                  ),
                  verticalSpace(12),
                  CustomShimmer(
                    height: 10.h,
                  ),
                ],
              ),
            ),
            horizontalSpace(10),
            Column(
              children: [
                CustomShimmer(
                  height: 20.h,
                  width: 20.w,
                  shapeBorder: const CircleBorder(),
                ),
                verticalSpace(4),
                CustomShimmer(
                  height: 10.h,
                  width: 20.w,
                ),
              ],
            ),
            horizontalSpace(10),
          ],
        ),
        verticalSpace(5),
        const CustomShimmer(
          height: 40,
        ),
      ],
    );
  }
}
