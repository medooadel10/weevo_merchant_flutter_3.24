import 'package:flutter/material.dart';

import 'wasully_shipment_applied_status.dart';
import 'wasully_shipment_available_status.dart';
import 'wasully_shipment_cancelled_status.dart';
import 'wasully_shipment_delivered_status.dart';
import 'wasully_shipment_merchant_accepted_status.dart';
import 'wasully_shipment_on_delivery_status.dart';
import 'wasully_shipment_on_the_way_status.dart';
import 'wasully_shipment_returned_status.dart';

abstract class BaseShipmentStatus {
  static Map<String, BaseShipmentStatus> shipmentStatusMap = {
    'available': WasullyShipmentAvailableStatus(),
    'merchant-accepted-shipping-offer': WasullyShipmentMerchantAcceptedStatus(),
    'on-the-way-to-get-shipment-from-merchant': WasullyShipmentOnTheWayStatus(),
    'courier-applied-to-shipment': WasullyShipmentAppliedStatus(),
    'on-delivery': WasullyShipmentOnDeliveryStatus(),
    'delivered': WasullyShipmentDeliveredStatus(),
    'returned': WasullyShipmentReturnedStatus(),
    'cancelled': WasullyShipmentCancelledStatus(),
  };

  static List<BaseShipmentStatus> shipmentStatusList = [
    WasullyShipmentAvailableStatus(),
    WasullyShipmentMerchantAcceptedStatus(),
    WasullyShipmentOnTheWayStatus(),
    WasullyShipmentOnDeliveryStatus(),
    WasullyShipmentDeliveredStatus(),
    WasullyShipmentReturnedStatus(),
    WasullyShipmentCancelledStatus(),
  ];

  Widget buildShipmentDetailsButtons(BuildContext context);
  Widget buildShipmentDetailsCourierHeader(BuildContext context) {
    return Container();
  }

  String get status;
  String get statusAr;
  String get image;
}
