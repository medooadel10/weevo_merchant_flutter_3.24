import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_bottom_sheet.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_text_field.dart';
import 'package:weevo_merchant_upgrade/features/add_product/ui/widgets/add_product_photo_bloc_builder.dart';

import '../../../../core/Providers/product_provider.dart';
import '../../logic/cubit/add_product_cubit.dart';

class AddProductForm extends StatelessWidget {
  const AddProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProductCubit>();
    final productProvider = context.read<ProductProvider>();
    return Form(
      key: cubit.formKey,
      child: Column(
        children: [
          const AddProductPhotoBlocBuilder(),
          CustomTextField(
            controller: cubit.productTitleController,
            hintText: 'إسم المنتج',
            errorMsg: 'الرجاء ادخال اسم المنتج',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          verticalSpace(14),
          CustomTextField(
            controller: cubit.productDescriptionController,
            hintText: 'مواصفات المنتج',
            errorMsg: 'الرجاء ادخال مواصفات المنتج',
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: null,
          ),
          verticalSpace(14),
          CustomTextField(
            controller: cubit.productTypeController,
            hintText: 'نوع المنتج',
            errorMsg: 'الرجاء ادخال نوع المنتج',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            readOnly: true,
            onTap: () {
              CustomBottomSheet.show(
                context,
                productProvider.categories
                    .map(
                      (e) => BottomSheetItem(
                        title: e.name ?? '',
                        onTap: () {
                          cubit.productTypeController.text = e.name ?? '';
                          cubit.selectCategory(e);
                          FocusScope.of(context).nextFocus();
                        },
                        imageUrl: e.image,
                      ),
                    )
                    .toList(),
              );
            },
            suffixIcon: Icons.arrow_drop_down,
          ),
          verticalSpace(14),
          CustomTextField(
            controller: cubit.productPriceController,
            hintText: 'سعر المنتج',
            errorMsg: 'الرجاء ادخال سعر المنتج',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            suffixWidget: Padding(
              padding: EdgeInsets.only(
                top: 8.0.h,
                left: 5.0.w,
                right: 5.0.w,
              ),
              child: Text(
                'جنيه',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          verticalSpace(14),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'حجم المنتج',
              style: TextStyle(
                fontSize: 16.0.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          verticalSpace(6),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: cubit.productLengthController,
                  hintText: 'الطول',
                  errorMsg: 'الطول',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: CustomTextField(
                  controller: cubit.productWidthController,
                  hintText: 'العرض',
                  errorMsg: 'العرض',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: CustomTextField(
                  controller: cubit.productHeightController,
                  hintText: 'الارتفاع',
                  errorMsg: 'الارتفاع',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(14),
          CustomTextField(
            controller: cubit.productWeightController,
            hintText: 'وزن المنتج',
            errorMsg: 'الرجاء ادخال وزن المنتج',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            suffixWidget: Padding(
              padding: EdgeInsets.only(
                top: 8.0.h,
                left: 5.0.w,
                right: 5.0.w,
              ),
              child: Text(
                'كيلو غرام',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
