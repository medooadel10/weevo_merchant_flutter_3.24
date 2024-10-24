import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/toasts.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';
import 'package:weevo_merchant_upgrade/features/add_product/logic/cubit/add_product_cubit.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../../../core/Dialogs/loading_dialog.dart';

class AddProductSubmitBlocConsumer extends StatelessWidget {
  const AddProductSubmitBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProductCubit>();
    return BlocConsumer<AddProductCubit, AddProductState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const LoadingDialog(),
            );
          },
          success: (product) {
            if (cubit.product != null) {
              showToast('تم تعديل المنتج بنجاح');
            } else {
              showToast('تم اضافة المنتج بنجاح');
            }
            ProductModel productModel = ProductModel(
              id: product.id,
              name: product.name,
              image: product.image,
              description: product.description,
              price: product.price,
              height: product.height,
              width: product.width,
              length: product.length,
              weight: product.weight,
              merchantId: product.merchantId,
              categoryId: product.categoryId,
              category: context.read<AddProductCubit>().selectedCategory!,
            );
            context.pop();
            context.pop(data: productModel);
          },
          error: (error) {
            showToast(error, isError: true);
            context.pop();
          },
        );
      },
      builder: (context, state) {
        return WeevoButton(
          title: 'إضافة منتج',
          onTap: () {
            context.read<AddProductCubit>().addProduct();
          },
          color: weevoPrimaryOrangeColor,
          isStable: true,
          isExpand: true,
        );
      },
    );
  }
}
