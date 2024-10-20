import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_shimmer.dart';
import 'package:weevo_merchant_upgrade/features/products/logic/cubit/products_cubit.dart';

import 'product_action.dart';

class ProductsHeader extends StatelessWidget {
  const ProductsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Failure,
      builder: (context, state) {
        final cubit = context.read<ProductsCubit>();
        return state.maybeWhen(
          loading: () => _buildLoading(),
          failure: (message) => _buildLoading(),
          success: (products) => Row(
            children: [
              ProductAction(
                onTap: () {},
                icon: 'assets/images/sort.svg',
              ),
              const Spacer(),
              Text(
                '${cubit.data?.total} منتجات',
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          orElse: () => Container(),
        );
      },
    ).paddingSymmetric(
      horizontal: 16.0.w,
      vertical: 10.0.h,
    );
  }

  Widget _buildLoading() {
    return Row(
      children: [
        CustomShimmer(
          height: 20.0.h,
          width: 20.0.w,
        ),
        const Spacer(),
        CustomShimmer(
          height: 10.0.h,
          width: 80.0.w,
        ),
      ],
    );
  }
}
