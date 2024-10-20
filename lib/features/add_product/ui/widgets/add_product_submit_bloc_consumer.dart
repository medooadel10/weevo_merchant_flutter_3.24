import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';

class AddProductSubmitBlocConsumer extends StatelessWidget {
  const AddProductSubmitBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return WeevoButton(
      title: 'إضافة منتج',
      onTap: () {},
      color: weevoPrimaryOrangeColor,
      isStable: true,
      isExpand: true,
    );
  }
}
