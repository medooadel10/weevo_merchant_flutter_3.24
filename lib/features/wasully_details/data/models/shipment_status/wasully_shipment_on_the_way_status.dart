import 'package:flutter/material.dart';

import '../../../../../core_new/helpers/spacing.dart';
import '../../../ui/widgets/buttons/wasully_cancel_btn.dart';
import '../../../ui/widgets/buttons/wasully_track_shipment_btn.dart';
import '../../../ui/widgets/wasully_details_courier_header.dart';
import 'base_shipment_status.dart';

class WasullyShipmentOnTheWayStatus extends BaseShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
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
  String get status => 'on-the-way-to-get-shipment-from-merchant';

  @override
  String get statusAr => 'في الطريق';

  @override
  String get image => 'assets/images/in_my_way_icon.png';
  @override
  Widget buildShipmentDetailsCourierHeader(BuildContext context) {
    return const WasullyDetailsCourierHeader();
  }
}
