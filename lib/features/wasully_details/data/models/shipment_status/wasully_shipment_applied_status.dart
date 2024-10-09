import 'package:flutter/material.dart';

import '../../../../../core_new/helpers/spacing.dart';
import '../../../ui/widgets/buttons/wasully_cancel_btn.dart';
import '../../../ui/widgets/buttons/wasully_track_shipment_btn.dart';
import '../../../ui/widgets/wasully_details_courier_header.dart';
import 'base_shipment_status.dart';

class WasullyShipmentAppliedStatus extends BaseShipmentStatus {
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
  Widget buildShipmentDetailsCourierHeader(BuildContext context) {
    return const WasullyDetailsCourierHeader();
  }

  @override
  String get status => 'courier-applied-to-shipment';

  @override
  String get statusAr => 'في انتظار التوصيل';

  @override
  String get image => 'assets/images/wait_to_deliver.png';
}
