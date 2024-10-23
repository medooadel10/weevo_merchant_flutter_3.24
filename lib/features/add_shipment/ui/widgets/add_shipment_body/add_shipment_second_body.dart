import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/widgets/custom_text_field.dart';

class AddShipmentSecondBody extends StatelessWidget {
  const AddShipmentSecondBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'المحافظة',
          errorMsg: 'المحافظة مطلوب',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.place,
          onTap: () {},
          readOnly: true,
          suffixIcon: CupertinoIcons.chevron_down_circle,
        ),
        verticalSpace(16),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'المنطقة',
          errorMsg: 'المنطقة مطلوب',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.place,
          onTap: () {},
          readOnly: true,
          suffixIcon: CupertinoIcons.chevron_down_circle,
        ),
        verticalSpace(16),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'موقع التسليم بالتفصيل',
          errorMsg: 'موقع التسليم بالتفصيل مطلوب',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.place,
          onTap: () {},
        ),
        verticalSpace(16),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'موقع التسليم بالخريطة',
          errorMsg: 'موقع التسليم بالخريطة مطلوب',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.place,
          onTap: () {},
          readOnly: true,
          suffixIcon: Icons.touch_app_rounded,
        ),
        verticalSpace(16),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'تاريخ تسليم الشحنة',
          errorMsg: 'تاريخ تسليم الشحنة مطلوب',
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.next,
          suffixIcon: Icons.touch_app_rounded,
          onTap: () {},
          readOnly: true,
          prefixIcon: Icons.access_time_sharp,
        ),
        verticalSpace(16),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'إسم العميل',
          errorMsg: 'إسم العميل مطلوب',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onTap: () {},
          prefixIcon: Icons.person,
        ),
        verticalSpace(16),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'رقم هاتف العميل',
          errorMsg: 'إسم العميل مطلوب',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onTap: () {},
          prefixIcon: Icons.phone,
          maxLength: 11,
        ),
        verticalSpace(16),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'تفاصيل أخرى',
          errorMsg: '',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onTap: () {},
          prefixIcon: Icons.notes,
        ),
      ],
    );
  }
}
