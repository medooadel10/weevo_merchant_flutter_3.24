import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_shimmer.dart';

import '../../../../core_new/helpers/spacing.dart';

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10.0.h,
      ),
      child: Wrap(
        spacing: 10.0.w,
        runSpacing: 10.0.h,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        children: List.generate(
          20,
          (index) => Container(
            width: context.width * 0.45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
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
            ),
          ),
        ),
      ),
    );
  }
}
