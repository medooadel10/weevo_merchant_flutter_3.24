import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/core_new/data/models/bulk_shipment_status/bulk_shipment_status_available.dart';

import 'bulk_shipment_applied_status.dart';

class BaseBulkShipmentStatus {
  static Map<String, BaseBulkShipmentStatus> statuses = {
    'available': BulkShipmentAvailableStatus(),
    'courier-applied-to-shipment': BulkShipmentAppliedStatus(),
    'on-the-way-to-get-shipment-from-merchant': BulkShipmentAppliedStatus(),
  };
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Container();
  }
}
