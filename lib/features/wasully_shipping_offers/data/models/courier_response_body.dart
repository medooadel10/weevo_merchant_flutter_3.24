import 'dart:developer';

import '../../../../core/Models/courier_offer_driver.dart';

class ShippingOfferResponseBody {
  final int id;
  final int shipmentId;
  final int driverId;
  final String offer;
  final String status;
  final String expiresAt;
  final String createdAt;
  final String updatedAt;
  final CourierOfferDriver driver;

  ShippingOfferResponseBody(this.id, this.shipmentId, this.driverId, this.offer,
      this.status, this.expiresAt, this.createdAt, this.updatedAt, this.driver);

  factory ShippingOfferResponseBody.fromJson(Map<String, dynamic> json) {
    log('The Driver Data: ${json['driver']}');
    return ShippingOfferResponseBody(
      json['id'],
      json['shipment_id'],
      json['driver_id'],
      json['offer'],
      json['status'],
      json['expires_at'],
      json['created_at'],
      json['updated_at'],
      CourierOfferDriver.fromJson(json['driver']),
    );
  }
}
