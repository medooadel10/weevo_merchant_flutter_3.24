import '../../features/wasully_details/data/models/wasully_model.dart';

class ShipmentTrackingModel {
  int? shipmentId;
  String? deliveringState;
  String? deliveringCity;
  String? receivingState;
  String? receivingCity;
  String? receivingStreet;
  String? receivingLandmark;
  String? receivingBuildingNumber;
  String? receivingFloor;
  String? receivingApartment;
  String? receivingLat;
  String? receivingLng;
  String? deliveringLat;
  String? deliveringLng;
  double? fromLat;
  double? fromLng;
  int? hasChildren;
  int? merchantId;
  int? courierId;
  String? courierNationalId;
  String? merchantNationalId;
  String? paymentMethod;
  String? merchantImage;
  String? courierImage;
  String? merchantName;
  String? courierName;
  String? merchantPhone;
  String? clientPhone;
  String? status;
  String? courierPhone;
  String? locationIdStatus;
  String? wasullyId;
  WasullyModel? wasullyModel;
  String? deliveringStreet;
  String? merchantRating;

  ShipmentTrackingModel({
    this.shipmentId,
    this.deliveringState,
    this.deliveringCity,
    this.receivingState,
    this.receivingCity,
    this.receivingStreet,
    this.receivingLandmark,
    this.receivingBuildingNumber,
    this.receivingFloor,
    this.receivingApartment,
    this.receivingLat,
    this.receivingLng,
    this.deliveringLat,
    this.merchantNationalId,
    this.courierNationalId,
    this.deliveringLng,
    this.fromLat,
    this.paymentMethod,
    this.fromLng,
    this.merchantId,
    this.clientPhone,
    this.status,
    this.courierId,
    this.hasChildren,
    this.merchantImage,
    this.merchantName,
    this.merchantPhone,
    this.courierImage,
    this.courierName,
    this.locationIdStatus,
    this.courierPhone,
    this.wasullyId,
    this.wasullyModel,
    this.deliveringStreet,
    this.merchantRating,
  });

  factory ShipmentTrackingModel.fromJson(Map<String, dynamic> map) {
    return ShipmentTrackingModel(
      shipmentId: int.tryParse(map['shipment_id']),
      deliveringState: map['delivery_state'],
      deliveringCity: map['delivery_city'],
      receivingState: map['receiving_state'],
      receivingCity: map['receiving_city'],
      deliveringLat: map['delivery_lat'],
      deliveringLng: map['delivering_lng'],
      receivingLat: map['receiving_lat'],
      receivingLng: map['receiving_lng'],
      fromLat: double.tryParse(map['from_lat'] ?? '0.0'),
      fromLng: double.tryParse(map['from_lng'] ?? '0.0'),
      status: map['status'],
      paymentMethod: map['payment_method'],
      merchantNationalId: map['merchant_national_id'],
      courierNationalId: map['courier_national_id'],
      hasChildren: int.tryParse(map['has_children']),
      clientPhone: map['client_phone'],
      merchantId: int.tryParse(map['merchant_id']),
      courierId: int.tryParse(map['courier_id']),
      merchantImage: map['merchant_image'],
      merchantName: map['merchant_name'],
      merchantPhone: map['merchant_phone'],
      courierPhone: map['courier_phone'],
      courierName: map['courier_name'],
      locationIdStatus: map['location_id_status'],
      courierImage: map['courier_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipment_id': shipmentId?.toString(),
      'delivery_state': deliveringState,
      'delivery_city': deliveringCity,
      'receiving_state': receivingState,
      'receiving_city': receivingCity,
      'receiving_street': receivingStreet,
      'receiving_landmark': receivingLandmark,
      'receiving_building_number': receivingBuildingNumber,
      'receiving_floor': receivingFloor,
      'receiving_apartment': receivingApartment,
      'receiving_lat': receivingLat,
      'receiving_lng': receivingLng,
      'delivery_lat': deliveringLat,
      'delivering_lng': deliveringLng,
      'from_lat': fromLat?.toString(),
      'client_phone': clientPhone,
      'merchant_national_id': merchantNationalId,
      'courier_national_id': courierNationalId,
      'from_lng': fromLng?.toString(),
      'merchant_id': merchantId?.toString(),
      'courier_id': courierId?.toString(),
      'status': status,
      'payment_method': paymentMethod,
      'has_children': hasChildren?.toString(),
      'merchant_image': merchantImage,
      'merchant_name': merchantName,
      'merchant_phone': merchantPhone,
      'courier_phone': courierPhone,
      'courier_name': courierName,
      'location_id_Status': locationIdStatus,
      'courier_image': courierImage,
    };
  }
}
