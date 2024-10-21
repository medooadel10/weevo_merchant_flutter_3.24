import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core/Dialogs/action_dialog.dart';
import 'package:weevo_merchant_upgrade/core/Dialogs/loading_dialog.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core/router/router.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';

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
        showModalBottomSheet(
          context: navigator.currentContext!,
          showDragHandle: true,
          enableDrag: true,
          sheetAnimationStyle: AnimationStyle(
            curve: Curves.easeInOut,
            reverseCurve: Curves.easeOutBack,
            duration: const Duration(milliseconds: 500),
          ),
          builder: (context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'تعديل المنتج',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        horizontalSpace(10),
                        const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ).paddingSymmetric(
                    horizontal: 10.0.w,
                    vertical: 10.0.h,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      context.pop();
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
                                child:
                                    BlocListener<ProductsCubit, ProductsState>(
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'حذف المنتج',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        horizontalSpace(10),
                        const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ).paddingSymmetric(
                    horizontal: 10.0.w,
                    vertical: 10.0.h,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'نسخ المنتج',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        horizontalSpace(10),
                        const Icon(
                          Icons.content_copy,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingSymmetric(
                horizontal: 10.0.w,
                vertical: 10.0.h,
              ),
            );
          },
        );
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
