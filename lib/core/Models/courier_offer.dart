import 'courier_offer_driver.dart';

class CourierOffer {
  int? id;
  int? shipmentId;
  int? driverId;
  String? offer;
  String? status;
  String? expiresAt;
  String? createdAt;
  String? updatedAt;
  CourierOfferDriver? driver;

  CourierOffer(
      {this.id,
      this.shipmentId,
      this.driverId,
      this.offer,
      this.status,
      this.expiresAt,
      this.createdAt,
      this.updatedAt,
      this.driver});

  CourierOffer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shipmentId = json['shipment_id'];
    driverId = json['driver_id'];
    offer = json['offer'];
    status = json['status'];
    expiresAt = json['expires_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    driver = json['driver'] != null
        ? CourierOfferDriver.fromJson(json['driver'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipment_id'] = shipmentId;
    data['driver_id'] = driverId;
    data['offer'] = offer;
    data['status'] = status;
    data['expires_at'] = expiresAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (driver != null) {
      data['driver'] = driver?.toJson();
    }
    return data;
  }
}
