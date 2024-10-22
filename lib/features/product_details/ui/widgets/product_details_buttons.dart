import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core/Models/pivot.dart';
import 'package:weevo_merchant_upgrade/core/Models/product_model.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core/router/router.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/toasts.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';
import 'package:weevo_merchant_upgrade/features/add_product/ui/add_product_screen.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../../../core/Providers/add_shipment_provider.dart';
import '../../../../core/Utilits/constants.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../Screens/add_shipment.dart';
import '../../logic/cubit/product_details_cubit.dart';

class ProductDetailsButtons extends StatelessWidget {
  const ProductDetailsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailsCubit>();
    final addShipmentProvider = context.read<AddShipmentProvider>();
    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {
        state.whenOrNull(
          cancelSuccess: () {
            showToast('تم حذف المنتج بنجاح');
            MagicRouter.pop(data: cubit.product);
          },
          cancelFailure: (error) {
            showToast(error, isError: true);
          },
        );
      },
      builder: (context, state) {
        if (state is CancelLoading) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }
        return Column(
          children: [
            WeevoButton(
              onTap: () {
                addShipmentProvider.addShipmentProduct(
                  Product(
                    id: cubit.product!.id,
                    name: cubit.product!.name,
                    image: cubit.product!.image,
                    description: cubit.product!.description,
                    price: cubit.product!.price,
                    height: cubit.product!.height,
                    width: cubit.product!.width,
                    length: cubit.product!.length,
                    weight: cubit.product!.weight,
                    merchantId: cubit.product!.merchantId,
                    categoryId: cubit.product!.categoryId,
                    productCategory: ProductCategory(
                      id: cubit.product!.category.id,
                      name: cubit.product!.category.name,
                      image: cubit.product!.category.image,
                    ),
                    quantity: 1,
                    pivot: Pivot(
                      productId: cubit.product!.id,
                    ),
                  ),
                );
                addShipmentProvider.setShipmentFromWhere(oneShipment);
                Navigator.pushNamed(context, AddShipment.id);
              },
              color: weevoPrimaryOrangeColor,
              isStable: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/new_icon.png',
                    color: Colors.white,
                    height: 25.h,
                    width: 25.w,
                  ),
                  horizontalSpace(10),
                  Text(
                    'اشحن المنتج',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(10),
            Row(
              children: [
                Expanded(
                  child: WeevoButton(
                    color: weevoPrimaryBlueColor,
                    onTap: () {
                      MagicRouter.navigateTo(
                        AddProductScreen(
                          product: cubit.product,
                        ),
                      ).then((value) {
                        if (value is ProductModel) {
                          cubit.getProductDetails(cubit.product!.id);
                        }
                      });
                    },
                    isStable: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: context.colorScheme.onPrimary,
                        ),
                        horizontalSpace(10),
                        Text(
                          'تعديل المنتج',
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: WeevoButton(
                    color: Colors.red,
                    onTap: () {
                      cubit.deleteProduct(cubit.product!.id);
                    },
                    isStable: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: context.colorScheme.onPrimary,
                        ),
                        horizontalSpace(10),
                        Text(
                          'حذف المنتج',
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).paddingSymmetric(
      horizontal: 16.w,
      vertical: 10.h,
    );
  }
}
