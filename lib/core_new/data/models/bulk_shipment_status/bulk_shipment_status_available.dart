import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/core_new/data/models/bulk_shipment_status/base_bulk_shipment_status.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/ui/widgets/buttons/bulk_shipment_cancel_btn.dart';

class BulkShipmentAvailableStatus extends BaseBulkShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return const BulkShipmentCancelBtn();
  }
}
