import 'package:flutter/material.dart';

import '../../../../../core_new/helpers/spacing.dart';
import '../../../../features/shipment_details/ui/widgets/buttons/shipment_cancel_btn.dart';
import '../../../../features/shipment_details/ui/widgets/buttons/shipment_track_shipment_btn.dart';
import '../../../../features/shipment_details/ui/widgets/shipment_details_courier_header.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_cancel_btn.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_track_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_courier_header.dart';
import 'base_shipment_status.dart';

class ShipmentOnTheWayStatus extends BaseShipmentStatus {
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
  String get status => 'on-the-way-to-get-shipment-from-merchant';

  @override
  String get statusAr => 'في الطريق';

  @override
  String get image => 'assets/images/in_my_way_icon.png';

  @override
  Widget buildWasullyDetailsCourierHeader(BuildContext context) {
    return const WasullyDetailsCourierHeader();
  }

  @override
  Widget buildShipmentDetailsCourierHeader(BuildContext context) {
    return const ShipmentDetailsCourierHeader();
  }
}
