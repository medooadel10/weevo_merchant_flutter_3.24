import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/ui/widgets/shipment_details_courier_header.dart';

import '../../../../../core_new/helpers/spacing.dart';
import '../../../../features/shipment_details/ui/widgets/buttons/shipment_cancel_btn.dart';
import '../../../../features/shipment_details/ui/widgets/buttons/shipment_track_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_cancel_btn.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_track_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_courier_header.dart';
import 'base_shipment_status.dart';

class ShipmentMerchantAcceptedStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: WasullyTrackShipmentBtn(),
        ),
        horizontalSpace(10),
        const Expanded(
          child: WasullyCancelBtn(),
        ),
      ],
    );
  }

  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: ShipmentTrackShipmentBtn(),
        ),
        horizontalSpace(10),
        const Expanded(
          child: ShipmentCancelBtn(),
        ),
      ],
    );
  }

  @override
  Widget buildWasullyDetailsCourierHeader(BuildContext context) {
    return const WasullyDetailsCourierHeader();
  }

  @override
  Widget buildShipmentDetailsCourierHeader(BuildContext context) {
    return const ShipmentDetailsCourierHeader();
  }

  @override
  String get status =>
      'merchant-accepted-shipping-offer,courier-applied-to-shipment';

  @override
  String get statusAr => 'في انتظار التوصيل';

  @override
  String get image => 'assets/images/wait_to_deliver.png';
}
