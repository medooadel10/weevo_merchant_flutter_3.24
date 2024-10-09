class RegUser {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? gender;
  String? photo;
  String? company;
  String? workTypeId;
  String? categoryId;
  String? nationalIdNumber;
  String? stateId;
  String? cityId;
  String? brandName;
  String? street;
  String? buildingNumber;
  String? floor;
  String? apartment;
  String? lat;
  String? lng;
  String? dateOfBirth;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? name;

  RegUser(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.gender,
      this.photo,
      this.company,
      this.nationalIdNumber,
      this.workTypeId,
      this.categoryId,
      this.stateId,
      this.cityId,
      this.brandName,
      this.street,
      this.buildingNumber,
      this.floor,
      this.apartment,
      this.lat,
      this.lng,
      this.dateOfBirth,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.name});

  RegUser.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    photo = json['photo'];
    company = json['company'];
    workTypeId = json['work_type_id'];
    categoryId = json['category_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    street = json['street'];
    brandName = json['brand_name'];
    nationalIdNumber = json['national_id_number'];
    buildingNumber = json['building_number'];
    floor = json['floor'];
    apartment = json['apartment'];
    lat = json['lat'];
    lng = json['lng'];
    dateOfBirth = json['date_of_birth'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['photo'] = photo;
    data['company'] = company;
    data['work_type_id'] = workTypeId;
    data['category_id'] = categoryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['street'] = street;
    data['national_id_number'] = nationalIdNumber;
    data['building_number'] = buildingNumber;
    data['floor'] = floor;
    data['brand_name'] = brandName;
    data['apartment'] = apartment;
    data['lat'] = lat;
    data['lng'] = lng;
    data['date_of_birth'] = dateOfBirth;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
