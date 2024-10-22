import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core/Dialogs/action_dialog.dart';
import 'package:weevo_merchant_upgrade/core/Dialogs/loading_dialog.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core/router/router.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_bottom_sheet.dart';
import 'package:weevo_merchant_upgrade/features/add_product/ui/add_product_screen.dart';

import '../../../../core_new/helpers/toasts.dart';
import '../../data/models/products_response_body_model.dart';
import '../../logic/cubit/products_cubit.dart';

class ProductMoreIcon extends StatelessWidget {
  final ProductModel product;
  const ProductMoreIcon({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await Future.delayed(Duration.zero);
        if (context.mounted) {
          CustomBottomSheet.show(
            context,
            [
              BottomSheetItem(
                title: 'تعديل المنتج',
                onTap: () {
                  MagicRouter.navigateTo(AddProductScreen(
                    product: product,
                  )).then((value) {
                    if (value is ProductModel) {
                      cubit.getProducts();
                    }
                  });
                },
                icon: Icons.edit,
              ),
              BottomSheetItem(
                title: 'حذف المنتج',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ActionDialog(
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                      onApproveClick: () async {
                        context.pop();
                        showDialog(
                          context: navigator.currentContext!,
                          barrierDismissible: false,
                          builder: (context) => BlocProvider.value(
                            value: cubit,
                            child: BlocListener<ProductsCubit, ProductsState>(
                              listenWhen: (previous, current) =>
                                  current is DeleteProductSuccess ||
                                  current is DeleteProductFailure,
                              listener: (context, state) {
                                if (state is DeleteProductSuccess) {
                                  MagicRouter.pop();
                                  showToast('تم الحذف بنجاح');
                                }
                                if (state is DeleteProductFailure) {
                                  MagicRouter.pop();
                                  showToast(state.message, isError: true);
                                }
                              },
                              child: const LoadingDialog(),
                            ),
                          ),
                        );
                        cubit.deleteProduct(product.id);
                      },
                      onCancelClick: () {
                        context.pop();
                      },
                      title: 'حذف المنتج',
                      content: 'هل تريد حذف هذا المنتج؟',
                    ),
                  );
                },
                icon: Icons.delete,
              ),
              BottomSheetItem(
                title: 'نسخ المنتج',
                onTap: () {
                  MagicRouter.navigateTo(AddProductScreen(
                    product: product,
                    isDuplicate: true,
                  )).then((value) {
                    if (value is ProductModel) {
                      cubit.getProducts();
                    }
                  });
                },
                icon: Icons.content_copy,
              ),
            ],
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFD8F3FF),
        ),
        child: const Icon(
          Icons.more_horiz,
          color: weevoPrimaryBlueColor,
        ),
      ),
    );
  }
}
