import 'package:flutter/material.dart';

import 'shipment_applied_status.dart';
import 'shipment_available_status.dart';
import 'shipment_cancelled_status.dart';
import 'shipment_delivered_status.dart';
import 'shipment_merchant_accepted_status.dart';
import 'shipment_on_delivery_status.dart';
import 'shipment_on_the_way_status.dart';
import 'shipment_returned_status.dart';

abstract class BaseShipmentStatus {
  static Map<String, BaseShipmentStatus> shipmentStatusMap = {
    'available': ShipmentAvailableStatus(),
    'merchant-accepted-shipping-offer': ShipmentMerchantAcceptedStatus(),
    'on-the-way-to-get-shipment-from-merchant': ShipmentOnTheWayStatus(),
    'courier-applied-to-shipment': WasullyShipmentAppliedStatus(),
    'on-delivery': ShipmentOnDeliveryStatus(),
    'delivered': ShipmentDeliveredStatus(),
    'returned': ShipmentReturnedStatus(),
    'cancelled': ShipmentCancelledStatus(),
  };

  static List<BaseShipmentStatus> shipmentStatusList = [
    ShipmentAvailableStatus(),
    ShipmentMerchantAcceptedStatus(),
    ShipmentOnTheWayStatus(),
    ShipmentOnDeliveryStatus(),
    ShipmentDeliveredStatus(),
    ShipmentReturnedStatus(),
    ShipmentCancelledStatus(),
  ];

  Widget buildWasullyDetailsButtons(BuildContext context);
  Widget buildWasullyDetailsCourierHeader(BuildContext context) {
    return Container();
  }

  Widget buildShipmentDetailsButtons(BuildContext context);

  Widget buildShipmentDetailsCourierHeader(BuildContext context) {
    return Container();
  }

  String get status;
  String get statusAr;
  String get image;
}
