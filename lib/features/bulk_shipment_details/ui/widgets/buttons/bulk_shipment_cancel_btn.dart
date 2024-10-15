import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';

class BulkShipmentCancelBtn extends StatelessWidget {
  const BulkShipmentCancelBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return WeevoButton(
      onTap: () {},
      color: Colors.red,
      isStable: true,
      title: 'إلغاء الطلبات',
    );
  }
}
