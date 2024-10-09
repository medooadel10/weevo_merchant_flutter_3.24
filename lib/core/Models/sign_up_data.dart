class SignUpData {
  String? firstName;
  String? lastName;
  String? email;
  String? photo;
  String? phone;
  String? userType;
  String? password;
  // String commercialActivity;
  String? userFirebaseId;
  String? userFirebaseToken;
  // String nationalIdFront;
  // String nationalIdBack;
  // String nationalIdNumber;

  SignUpData({
    this.firstName,
    this.lastName,
    this.email,
    this.photo,
    this.phone,
    this.userType,
    this.password,
    // this.commercialActivity,
    this.userFirebaseId,
    this.userFirebaseToken,
    // this.nationalIdFront,
    // this.nationalIdBack,
    // this.nationalIdNumber
  });

  @override
  String toString() {
    return 'SignUpData{firstName: $firstName, lastName: $lastName, email: $email, photo: $photo, phone: $phone, userType: $userType, password: $password, userFirebaseId: $userFirebaseId, userFirebaseToken: $userFirebaseToken}';
  }
}
