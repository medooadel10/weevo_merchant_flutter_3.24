import 'package:flutter/material.dart';

import 'base_shipment_status.dart';

class WasullyShipmentReturnedStatus extends BaseShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Container();
  }

  @override
  String get status => 'returned';

  @override
  String get statusAr => 'مرتجعة';

  @override
  String get image => 'assets/images/returned_icon.png';
}
