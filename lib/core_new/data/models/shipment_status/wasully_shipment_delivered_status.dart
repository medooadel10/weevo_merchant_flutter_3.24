import 'package:flutter/material.dart';

import 'base_shipment_status.dart';

class WasullyShipmentDeliveredStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
    return Container();
  }

  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Container();
  }

  @override
  String get status => 'delivered,bulk-shipment-closed';

  @override
  String get statusAr => 'مكتملة';

  @override
  String get image => 'assets/images/delivered_icon.png';
}
