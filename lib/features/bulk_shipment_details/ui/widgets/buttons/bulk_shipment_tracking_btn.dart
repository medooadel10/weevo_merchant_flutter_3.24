import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';

class BulkShipmentTrackingBtn extends StatelessWidget {
  const BulkShipmentTrackingBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return WeevoButton(
      onTap: () {},
      color: weevoPrimaryOrangeColor,
      isStable: true,
      title: 'تتبع الطلبات',
    );
  }
}
