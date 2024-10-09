import 'user_subscription.dart';

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? brandName;
  String? email;
  String? emailVerifiedAt;
  String? nationalIdNumber;
  String? nationalIdPhotoBack;
  String? nationalIdPhotoFront;
  String? dateOfBirth;
  String? photo;
  String? phone;
  String? gender;
  String? company;
  String? workTypeId;
  String? categoryId;
  String? stateId;
  String? cityId;
  String? street;
  String? buildingNumber;
  String? floor;
  String? apartment;
  String? lat;
  String? lng;
  String? bankAccountNumberIban;
  String? bankAccountClientName;
  String? bankBranchName;
  String? bankName;
  String? walletNumber;
  String? firebaseNotificationToken;
  int? addressBookDefaultId;
  int? active;
  String? lastSeen;
  int? online;
  int? receiveNotifications;
  String? appVersion;
  String? cachedAverageRating;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? name;
  List<UserSubscription>? activeSubscriptions;
  List<UserSubscription>? subscriptions;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.brandName,
      this.email,
      this.emailVerifiedAt,
      this.nationalIdNumber,
      this.nationalIdPhotoBack,
      this.nationalIdPhotoFront,
      this.dateOfBirth,
      this.photo,
      this.phone,
      this.gender,
      this.company,
      this.workTypeId,
      this.categoryId,
      this.stateId,
      this.cityId,
      this.street,
      this.buildingNumber,
      this.floor,
      this.apartment,
      this.lat,
      this.lng,
      this.bankAccountNumberIban,
      this.bankAccountClientName,
      this.bankBranchName,
      this.bankName,
      this.walletNumber,
      this.firebaseNotificationToken,
      this.addressBookDefaultId,
      this.active,
      this.lastSeen,
      this.online,
      this.receiveNotifications,
      this.appVersion,
      this.cachedAverageRating,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.activeSubscriptions,
      this.subscriptions});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    brandName = json['brand_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    nationalIdNumber = json['national_id_number'];
    nationalIdPhotoBack = json['national_id_photo_back'];
    nationalIdPhotoFront = json['national_id_photo_front'];
    dateOfBirth = json['date_of_birth'];
    photo = json['photo'];
    phone = json['phone'];
    gender = json['gender'];
    company = json['company'];
    workTypeId = json['work_type_id'];
    categoryId = json['category_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    street = json['street'];
    buildingNumber = json['building_number'];
    floor = json['floor'];
    apartment = json['apartment'];
    lat = json['lat'];
    lng = json['lng'];
    bankAccountNumberIban = json['bank_account_number_iban'];
    bankAccountClientName = json['bank_account_client_name'];
    bankBranchName = json['bank_branch_name'];
    bankName = json['bank_name'];
    walletNumber = json['wallet_number'];
    firebaseNotificationToken = json['firebase_notification_token'];
    addressBookDefaultId = json['address_book_default_id'];
    active = json['active'];
    lastSeen = json['last_seen'];
    online = json['online'];
    receiveNotifications = json['receive_notifications'];
    appVersion = json['app_version'];
    cachedAverageRating = json['cached_average_rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    name = json['name'];
    if (json['active_subscriptions'] != null) {
      activeSubscriptions = [];
      json['active_subscriptions'].forEach((v) {
        activeSubscriptions?.add(UserSubscription.fromJson(v));
      });
    }
    if (json['subscriptions'] != null) {
      subscriptions = [];
      json['subscriptions'].forEach((v) {
        subscriptions?.add(UserSubscription.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['brand_name'] = brandName;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['national_id_number'] = nationalIdNumber;
    data['national_id_photo_back'] = nationalIdPhotoBack;
    data['national_id_photo_front'] = nationalIdPhotoFront;
    data['date_of_birth'] = dateOfBirth;
    data['photo'] = photo;
    data['phone'] = phone;
    data['gender'] = gender;
    data['company'] = company;
    data['work_type_id'] = workTypeId;
    data['category_id'] = categoryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['street'] = street;
    data['building_number'] = buildingNumber;
    data['floor'] = floor;
    data['apartment'] = apartment;
    data['lat'] = lat;
    data['lng'] = lng;
    data['bank_account_number_iban'] = bankAccountNumberIban;
    data['bank_account_client_name'] = bankAccountClientName;
    data['bank_branch_name'] = bankBranchName;
    data['bank_name'] = bankName;
    data['wallet_number'] = walletNumber;
    data['firebase_notification_token'] = firebaseNotificationToken;
    data['address_book_default_id'] = addressBookDefaultId;
    data['active'] = active;
    data['last_seen'] = lastSeen;
    data['online'] = online;
    data['receive_notifications'] = receiveNotifications;
    data['app_version'] = appVersion;
    data['cached_average_rating'] = cachedAverageRating;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['name'] = name;
    if (activeSubscriptions != null) {
      data['active_subscriptions'] =
          activeSubscriptions?.map((v) => v.toJson()).toList();
    }
    if (subscriptions != null) {
      data['subscriptions'] = subscriptions?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
