import 'package:flutter/material.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../ui/widgets/buttons/wasully_update_shipment_btn.dart';
import '../../../ui/widgets/wasully_restore_cancelled_button.dart';
import 'base_shipment_status.dart';

class WasullyShipmentCancelledStatus extends BaseShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: WasullyRestoreCancelledButton(),
        ),
        horizontalSpace(10),
        const Expanded(
          child: WasullyUpdateShipmentBtn(
            color: weevoPrimaryBlueColor,
          ),
        ),
      ],
    );
  }

  @override
  String get status => 'cancelled,bulk-shipment-cancelled';

  @override
  String get statusAr => 'ملغية';

  @override
  String get image => 'assets/images/cancelled_icon.png';
}
