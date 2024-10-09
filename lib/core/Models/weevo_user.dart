class WeevoUser {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? emailAddress;
  String? type;
  String? password;
  // String nationalIdNumber;
  // String commercialActivityName;
  // String nationalIdFront;
  // String nationalIdBack;
  String? firebaseNotificationToken;
  String? imageUrl;
  String? userFirebaseId;
  int? weevoPlanId;
  bool? weevoPlusTrail;

  WeevoUser(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.emailAddress,
      required this.type,
      required this.password,
      // required this.nationalIdNumber,
      // required this.commercialActivityName,
      //  this.nationalIdFront,
      // this.nationalIdBack,
      required this.userFirebaseId,
      required this.firebaseNotificationToken,
      this.imageUrl,
      required this.weevoPlanId,
      required this.weevoPlusTrail});

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': emailAddress,
      'password': password,
      'phone': phoneNumber,
      'type_user': type,
      'photo': imageUrl,
      'firebase_notification_token': firebaseNotificationToken,
      'firebase_uid': userFirebaseId,
      // 'national_id_photo_front': nationalIdFront,
      // 'national_id_photo_back': nationalIdBack,
      // 'national_id_number': nationalIdNumber,
      // 'brand_name': commercialActivityName,
      'weevo-plus': weevoPlanId,
      'weevo-plus-trail': weevoPlusTrail,
    };
  }

  factory WeevoUser.fromMap(Map<String, dynamic> map) {
    return WeevoUser(
      firstName: map['first_name'],
      lastName: map['last_name'],
      phoneNumber: map['phone'],
      emailAddress: map['email'],
      type: map['type_user'],
      password: map['password'],
      imageUrl: map['photo'],
      userFirebaseId: map['firebase_uid'],
      weevoPlanId: map['weevo-plus'],
      weevoPlusTrail: map['weevo-plus-trail'],
      firebaseNotificationToken: map['firebase_notification_token'],
      // nationalIdNumber: map['national_id_number'],
      // nationalIdBack: map['national_id_photo_back'],
      // nationalIdFront: map['national_id_photo_front'],
      // commercialActivityName: map['brand_name'],
    );
  }

  @override
  String toString() {
    return 'WeevoUser{firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, emailAddress: $emailAddress, type: $type, password: $password, firebaseNotificationToken: $firebaseNotificationToken, imageUrl: $imageUrl, userFirebaseId: $userFirebaseId, weevoPlanId: $weevoPlanId, weevoPlusTrail: $weevoPlusTrail}';
  }
}
