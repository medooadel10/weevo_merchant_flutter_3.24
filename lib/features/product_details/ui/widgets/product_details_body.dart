import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_loading_indicator.dart';
import 'package:weevo_merchant_upgrade/features/product_details/logic/cubit/product_details_cubit.dart';

import '../../../../core_new/helpers/spacing.dart';
import 'product_details_buttons.dart';
import 'product_details_image.dart';
import 'product_details_info.dart';

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ProductDetailsCubit>();
        if (cubit.product == null) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }
        return Container(
          color: Colors.grey[200],
          padding: EdgeInsets.only(
            bottom: 20.h,
          ),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await cubit.getProductDetails(cubit.product!.id);
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background:
                              const ProductDetailsImage().paddingSymmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        expandedHeight: 150.h,
                      ),
                      const SliverToBoxAdapter(
                        child: ProductDetailsInfo(),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(16),
              const ProductDetailsButtons(),
            ],
          ),
        );
      },
    );
  }
}
