import 'package:flutter/material.dart';

import '../../../../features/shipment_details/ui/widgets/buttons/shipment_track_shipment_btn.dart';
import '../../../../features/shipment_details/ui/widgets/shipment_details_courier_header.dart';
import '../../../../features/wasully_details/ui/widgets/buttons/wasully_track_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_courier_header.dart';
import 'base_shipment_status.dart';

class WasullyShipmentOnDeliveryStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
    return const WasullyTrackShipmentBtn();
  }

  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return const ShipmentTrackShipmentBtn();
  }

  @override
  String get status => 'on-delivery';

  @override
  String get statusAr => 'قيد التوصيل';

  @override
  String get image => 'assets/images/on_delivery.png';

  @override
  Widget buildWasullyDetailsCourierHeader(BuildContext context) {
    return const WasullyDetailsCourierHeader();
  }

  @override
  Widget buildShipmentDetailsCourierHeader(BuildContext context) {
    return const ShipmentDetailsCourierHeader();
  }
}
