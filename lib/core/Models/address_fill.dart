class AddressFill {
  String subAdministrativeArea;
  String administrativeArea;
  String street;
  double lat;
  double long;
  String? code;
  String? cityCode;
  String? stateCode;
  AddressFill({
    required this.subAdministrativeArea,
    required this.administrativeArea,
    required this.street,
    required this.lat,
    required this.long,
    this.code,
    this.cityCode,
    this.stateCode,
  });

  @override
  String toString() =>
      'AddressFill{subAdministrativeArea: $subAdministrativeArea, administrativeArea: $administrativeArea, street: $street, lat: $lat, long: $long}';
}
