class Address {
  int? id;
  String? name;
  int? merchantId;
  String? city;
  String? state;
  String? buildingNumber;
  String? floor;
  String? apartment;
  String? street;
  String? landmark;
  String? lng;
  String? lat;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Address({
    this.id,
    this.name,
    this.merchantId,
    this.city,
    this.state,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.street,
    this.landmark,
    this.lng,
    this.lat,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    merchantId = json['merchant_id'];
    city = json['city'];
    state = json['state'];
    buildingNumber = json['building_number'];
    floor = json['floor'];
    apartment = json['apartment'];
    street = json['street'];
    landmark = json['landmark'];
    lng = json['lng'];
    lat = json['lat'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['merchant_id'] = merchantId;
    data['city'] = city;
    data['state'] = state;
    data['building_number'] = buildingNumber;
    data['floor'] = floor;
    data['apartment'] = apartment;
    data['street'] = street;
    data['landmark'] = landmark;
    data['lng'] = lng;
    data['lat'] = lat;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }

  @override
  String toString() {
    return 'Address{id: $id, name: $name, merchantId: $merchantId, city: $city, state: $state, buildingNumber: $buildingNumber, floor: $floor, apartment: $apartment, street: $street, landmark: $landmark, lng: $lng, lat: $lat, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
