import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/ui/widgets/buttons/shipment_cancel_btn.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/ui/widgets/buttons/shipment_increase_price_btn.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/ui/widgets/buttons/shipment_update_shipment_btn.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_cancel_btn.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_increase_price_btn.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_update_shipment_btn.dart';
import 'base_shipment_status.dart';

class WasullyShipmentAvailableStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: WasullyIncreasePriceBtn(
                color: weevoPrimaryOrangeColor,
              ),
            ),
            horizontalSpace(10),
            const Expanded(
              child: WasullyCancelBtn(
                color: weevoGreyWhite,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        const WasullyUpdateShipmentBtn(
          color: weevoPrimaryBlueColor,
        ),
      ],
    );
  }

  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: ShipmentIncreasePriceBtn(
                color: weevoPrimaryOrangeColor,
              ),
            ),
            horizontalSpace(10),
            const Expanded(
              child: ShipmentCancelBtn(
                color: weevoGreyWhite,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        const ShipmentUpdateShipmentBtn(
          color: weevoPrimaryBlueColor,
        ),
      ],
    );
  }

  @override
  String get status => 'available';

  @override
  String get statusAr => 'جديدة';

  @override
  String get image => 'assets/images/new_icon.png';
}
