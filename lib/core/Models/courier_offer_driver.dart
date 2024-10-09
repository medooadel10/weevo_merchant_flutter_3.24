class CourierOfferDriver {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? photo;
  String? phone;
  String? gender;
  String? stateId;
  String? cityId;
  String? street;
  String? buildingNumber;
  String? floor;
  String? apartment;
  String? vehicleNumber;
  String? vehicleColor;
  String? vehicleModel;
  String? deliveryMethod;
  String? nationalIdPhotoBack;
  String? nationalIdPhotoFront;
  String? nationalIdNumber;
  String? firebaseNotificationToken;
  int? active;
  String? lastSeen;
  int? online;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? name;
  String? cachedAverageRating;

  CourierOfferDriver(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.emailVerifiedAt,
      this.photo,
      this.phone,
      this.gender,
      this.stateId,
      this.cityId,
      this.street,
      this.buildingNumber,
      this.floor,
      this.apartment,
      this.vehicleNumber,
      this.vehicleColor,
      this.vehicleModel,
      this.deliveryMethod,
      this.nationalIdPhotoBack,
      this.nationalIdPhotoFront,
      this.nationalIdNumber,
      this.firebaseNotificationToken,
      this.active,
      this.lastSeen,
      this.online,
      this.cachedAverageRating,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name});

  CourierOfferDriver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    photo = json['photo'];
    phone = json['phone'];
    gender = json['gender'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    street = json['street'];
    buildingNumber = json['building_number'];
    floor = json['floor'];
    apartment = json['apartment'];
    vehicleNumber = json['vehicle_number'];
    vehicleColor = json['vehicle_color'];
    vehicleModel = json['vehicle_model'];
    deliveryMethod = json['delivery_method'];
    nationalIdPhotoBack = json['national_id_photo_back'];
    nationalIdPhotoFront = json['national_id_photo_front'];
    nationalIdNumber = json['national_id_number'];
    firebaseNotificationToken = json['firebase_notification_token'];
    active = json['active'];
    lastSeen = json['last_seen'];
    online = json['online'];
    cachedAverageRating = json['cached_average_rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['photo'] = photo;
    data['phone'] = phone;
    data['gender'] = gender;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['street'] = street;
    data['building_number'] = buildingNumber;
    data['floor'] = floor;
    data['apartment'] = apartment;
    data['vehicle_number'] = vehicleNumber;
    data['vehicle_color'] = vehicleColor;
    data['vehicle_model'] = vehicleModel;
    data['delivery_method'] = deliveryMethod;
    data['national_id_photo_back'] = nationalIdPhotoBack;
    data['national_id_photo_front'] = nationalIdPhotoFront;
    data['national_id_number'] = nationalIdNumber;
    data['firebase_notification_token'] = firebaseNotificationToken;
    data['active'] = active;
    data['cached_average_rating'] = cachedAverageRating;
    data['last_seen'] = lastSeen;
    data['online'] = online;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['name'] = name;
    return data;
  }
}
