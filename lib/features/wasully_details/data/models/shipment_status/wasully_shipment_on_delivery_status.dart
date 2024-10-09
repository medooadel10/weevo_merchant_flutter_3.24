import 'package:flutter/material.dart';

import '../../../ui/widgets/buttons/wasully_track_shipment_btn.dart';
import '../../../ui/widgets/wasully_details_courier_header.dart';
import 'base_shipment_status.dart';

class WasullyShipmentOnDeliveryStatus extends BaseShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return const WasullyTrackShipmentBtn();
  }

  @override
  String get status => 'on-delivery';

  @override
  String get statusAr => 'قيد التوصيل';

  @override
  String get image => 'assets/images/on_delivery.png';

  @override
  Widget buildShipmentDetailsCourierHeader(BuildContext context) {
    return const WasullyDetailsCourierHeader();
  }
}
