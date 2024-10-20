import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_text_field.dart';

class AddProductForm extends StatelessWidget {
  const AddProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0.w,
              vertical: 10.0.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey[400]!,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'صورة المنتج',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                horizontalSpace(10),
                Icon(
                  Icons.camera_alt,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        verticalSpace(14),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'إسم المنتج',
          errorMsg: 'الرجاء ادخال اسم المنتج',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        verticalSpace(14),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'مواصفات المنتج',
          errorMsg: 'الرجاء ادخال مواصفات المنتج',
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
        ),
        verticalSpace(14),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'نوع المنتج',
          errorMsg: 'الرجاء ادخال نوع المنتج',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          readOnly: true,
          onTap: () {},
          suffixIcon: Icons.arrow_drop_down,
        ),
        verticalSpace(14),
        CustomTextField(
          controller: TextEditingController(),
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
                controller: TextEditingController(),
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
                controller: TextEditingController(),
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
                controller: TextEditingController(),
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
          controller: TextEditingController(),
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
    );
  }
}
