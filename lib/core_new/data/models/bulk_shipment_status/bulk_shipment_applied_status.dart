import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/core_new/data/models/bulk_shipment_status/base_bulk_shipment_status.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/ui/widgets/buttons/bulk_shipment_cancel_btn.dart';

import '../../../../features/bulk_shipment_details/ui/widgets/buttons/bulk_shipment_tracking_btn.dart';
import '../../../helpers/spacing.dart';

class BulkShipmentAppliedStatus extends BaseBulkShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: BulkShipmentTrackingBtn(),
        ),
        horizontalSpace(10),
        const Expanded(
          child: BulkShipmentCancelBtn(),
        ),
      ],
    );
  }
}
