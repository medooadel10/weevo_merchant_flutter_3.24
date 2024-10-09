import 'product_model.dart';

class ChildShipment {
  int? id;
  int? parentId;
  String? receivingState;
  String? receivingCity;
  String? receivingStreet;
  String? receivingLandmark;
  String? receivingBuildingNumber;
  String? receivingFloor;
  String? receivingApartment;
  String? receivingLat;
  String? receivingLng;
  String? dateToReceiveShipment;
  String? deliveringState;
  String? deliveringCity;
  String? deliveringStreet;
  String? deliveringLandmark;
  String? deliveringBuildingNumber;
  String? deliveringFloor;
  String? deliveringApartment;
  String? deliveringLat;
  String? deliveringLng;
  String? dateToDeliverShipment;
  String? clientName;
  String? clientPhone;
  String? notes;
  String? paymentMethod;
  String? amount;
  int? coupon;
  String? shippingCost;
  String? merchantId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Product>? products;

  ChildShipment(
      {this.id,
      this.parentId,
      this.receivingState,
      this.receivingCity,
      this.receivingStreet,
      this.receivingLandmark,
      this.receivingBuildingNumber,
      this.receivingFloor,
      this.receivingApartment,
      this.receivingLat,
      this.receivingLng,
      this.dateToReceiveShipment,
      this.deliveringState,
      this.coupon,
      this.deliveringCity,
      this.deliveringStreet,
      this.deliveringLandmark,
      this.deliveringBuildingNumber,
      this.deliveringFloor,
      this.deliveringApartment,
      this.deliveringLat,
      this.deliveringLng,
      this.dateToDeliverShipment,
      this.clientName,
      this.clientPhone,
      this.notes,
      this.paymentMethod,
      this.amount,
      this.shippingCost,
      this.merchantId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.products});

  ChildShipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    receivingState = json['receiving_state'];
    receivingCity = json['receiving_city'];
    receivingStreet = json['receiving_street'];
    receivingLandmark = json['receiving_landmark'];
    receivingBuildingNumber = json['receiving_building_number'];
    receivingFloor = json['receiving_floor'];
    receivingApartment = json['receiving_apartment'];
    receivingLat = json['receiving_lat'];
    receivingLng = json['receiving_lng'];
    dateToReceiveShipment = json['date_to_receive_shipment'];
    deliveringState = json['delivering_state'];
    deliveringCity = json['delivering_city'];
    deliveringStreet = json['delivering_street'];
    deliveringLandmark = json['delivering_landmark'];
    deliveringBuildingNumber = json['delivering_building_number'];
    deliveringFloor = json['delivering_floor'];
    deliveringApartment = json['delivering_apartment'];
    deliveringLat = json['delivering_lat'];
    deliveringLng = json['delivering_lng'];
    dateToDeliverShipment = json['date_to_deliver_shipment'];
    clientName = json['client_name'];
    clientPhone = json['client_phone'];
    notes = json['notes'];
    paymentMethod = json['payment_method'];
    amount = json['amount'].toString();
    shippingCost = json['expected_shipping_cost'].toString();
    merchantId = json['merchant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    coupon = json['coupon'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['receiving_state'] = receivingState;
    data['receiving_city'] = receivingCity;
    data['receiving_street'] = receivingStreet;
    data['receiving_landmark'] = receivingLandmark;
    data['receiving_building_number'] = receivingBuildingNumber;
    data['receiving_floor'] = receivingFloor;
    data['receiving_apartment'] = receivingApartment;
    data['receiving_lat'] = receivingLat;
    data['receiving_lng'] = receivingLng;
    data['date_to_receive_shipment'] = dateToReceiveShipment;
    data['delivering_state'] = deliveringState;
    data['delivering_city'] = deliveringCity;
    data['delivering_street'] = deliveringStreet;
    data['delivering_landmark'] = deliveringLandmark;
    data['delivering_building_number'] = deliveringBuildingNumber;
    data['delivering_floor'] = deliveringFloor;
    data['delivering_apartment'] = deliveringApartment;
    data['delivering_lat'] = deliveringLat;
    data['delivering_lng'] = deliveringLng;
    data['date_to_deliver_shipment'] = dateToDeliverShipment;
    data['client_name'] = clientName;
    data['client_phone'] = clientPhone;
    data['notes'] = notes;
    data['coupon'] = coupon;
    data['payment_method'] = paymentMethod;
    data['amount'] = double.parse(amount ?? '0');
    data['expected_shipping_cost'] = double.parse(shippingCost ?? '0');
    data['merchant_id'] = merchantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (products != null) {
      data['products'] = products?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'ChildShipment{receivingState: $receivingState, receivingCity: $receivingCity, receivingStreet: $receivingStreet, receivingLandmark: $receivingLandmark, receivingBuildingNumber: $receivingBuildingNumber, receivingFloor: $receivingFloor, receivingApartment: $receivingApartment, receivingLat: $receivingLat, receivingLng: $receivingLng, dateToReceiveShipment: $dateToReceiveShipment, deliveringState: $deliveringState, deliveringCity: $deliveringCity, deliveringStreet: $deliveringStreet, deliveringLandmark: $deliveringLandmark, deliveringBuildingNumber: $deliveringBuildingNumber, deliveringFloor: $deliveringFloor, deliveringApartment: $deliveringApartment, deliveringLat: $deliveringLat, deliveringLng: $deliveringLng, dateToDeliverShipment: $dateToDeliverShipment, clientName: $clientName, clientPhone: $clientPhone, notes: $notes, paymentMethod: $paymentMethod, amount: $amount, shippingCost: $shippingCost, merchantId: $merchantId, updatedAt: $updatedAt, createdAt: $createdAt, id: $id, products: $products}';
  }
}
