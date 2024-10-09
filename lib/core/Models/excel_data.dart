class ExcelData {
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
  String? expectedShippingCost;
  String? productIds;
  String? productQty;

  ExcelData({
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
    this.expectedShippingCost,
    this.productIds,
    this.productQty,
  });

  ExcelData.fromJson(Map<String, dynamic> json) {
    receivingState = json['receiving_state'].toString();
    receivingCity = json['receiving_city'].toString();
    receivingStreet = json['receiving_street'].toString();
    receivingLandmark = json['receiving_landmark'].toString();
    receivingBuildingNumber = json['receiving_building_number'].toString();
    receivingFloor = json['receiving_floor'].toString();
    receivingApartment = json['receiving_apartment'].toString();
    receivingLat = json['receiving_lat'].toString();
    receivingLng = json['receiving_lng'].toString();
    dateToReceiveShipment = json['date_to_receive_shipment'].toString();
    deliveringState = json['delivering_state'].toString();
    deliveringCity = json['delivering_city'].toString();
    deliveringStreet = json['delivering_street'].toString();
    deliveringLandmark = json['delivering_landmark'].toString();
    deliveringBuildingNumber = json['delivering_building_number'].toString();
    deliveringFloor = json['delivering_floor'].toString();
    deliveringApartment = json['delivering_apartment'].toString();
    deliveringLat = json['delivering_lat'].toString();
    deliveringLng = json['delivering_lng'].toString();
    dateToDeliverShipment = json['date_to_deliver_shipment'].toString();
    clientName = json['client_name'].toString();
    clientPhone = json['client_phone'].toString();
    notes = json['notes'].toString();
    paymentMethod = json['payment_method'].toString();
    amount = json['amount'].toString();
    expectedShippingCost = json['expected_shipping_cost'].toString();
    productIds = json['product_id'].toString();
    productQty = json['product_qty'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['expected_shipping_cost'] = expectedShippingCost;
    data['product_id'] = productIds;
    data['product_qty'] = productQty;
    return data;
  }
}
