import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_container.dart';
import '../../../../core_new/widgets/custom_image.dart';
import '../../logic/cubit/product_details_cubit.dart';

class ProductDetailsInfo extends StatelessWidget {
  const ProductDetailsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailsCubit>();

    return Column(
      children: [
        CustomContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cubit.product!.name,
                      style: TextStyle(
                        fontSize: 18.0.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      cubit.product!.description ?? '',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpace(10),
              Column(
                children: [
                  CustomImage(
                    imageUrl: cubit.product!.category.image,
                    height: 30.h,
                    width: 30.w,
                    radius: 22,
                    isCircle: true,
                  ),
                  verticalSpace(4),
                  Text(
                    cubit.product!.category.name ?? '',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomContainer(
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/dimensions.svg',
                    width: 25.w,
                    height: 25.h,
                  ),
                  horizontalSpace(4),
                  Text(
                    '${cubit.product!.length.toStringAsFixed0()} * ${cubit.product!.width.toStringAsFixed0()} * ${cubit.product!.height.toStringAsFixed0()}',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ).paddingSymmetric(
                vertical: 10.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/weight.svg',
                    width: 25.w,
                    height: 25.h,
                  ),
                  horizontalSpace(4),
                  Text(
                    '${cubit.product!.weight.toStringAsFixed0()} كيلو',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[300],
              ).paddingSymmetric(
                vertical: 10.h,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/money.svg',
                    width: 25.w,
                    height: 25.h,
                  ),
                  horizontalSpace(4),
                  Text(
                    '${cubit.product!.price} ج',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
