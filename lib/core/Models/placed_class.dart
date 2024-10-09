class GetPlaceId {
  String? formattedAddress, name;
  double? lat, lang;

  GetPlaceId({
    required this.formattedAddress,
    required this.name,
    required this.lat,
    required this.lang,
  });

  factory GetPlaceId.fromJson(Map<String, dynamic> json) {
    return GetPlaceId(
      formattedAddress: json['formatted_address'],
      name: json['name'],
      lat: json['geometry']['location']['lat'],
      lang: json['geometry']['location']['lng'],
    );
  }
}
