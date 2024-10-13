import 'package:flutter/material.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../features/shipment_details/ui/widgets/buttons/shipment_restore_cancelled_button.dart';
import '../../../../features/shipment_details/ui/widgets/buttons/shipment_update_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_update_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_restore_cancelled_button.dart';
import 'base_shipment_status.dart';

class ShipmentCancelledStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
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
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: ShipmentRestoreCancelledButton(),
        ),
        horizontalSpace(10),
        const Expanded(
          child: ShipmentUpdateShipmentBtn(
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
