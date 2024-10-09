class PlaceResult {
  final String formattedAddress;
  final List<PlaceAddressComponent> addressComponents;
  final String placeId;

  PlaceResult(
      {required this.formattedAddress,
      required this.addressComponents,
      required this.placeId});

  factory PlaceResult.fromJson(Map<String, dynamic> json) => PlaceResult(
        formattedAddress: json["formatted_address"] as String,
        addressComponents: (json["address_components"] as List)
            .map((x) =>
                PlaceAddressComponent.fromJson(x as Map<String, dynamic>))
            .toList(),
        placeId: json["place_id"] as String,
      );
}

class PlaceAddressComponent {
  final List<dynamic> types;
  final String longName;
  final String shortName;

  PlaceAddressComponent(
      {required this.types, required this.longName, required this.shortName});

  factory PlaceAddressComponent.fromJson(Map<String, dynamic> json) =>
      PlaceAddressComponent(
        longName: json["long_name"] as String,
        types:
            (json["types"] as List<dynamic>).map((x) => x as dynamic).toList(),
        shortName: json["short_name"] as String,
      );
}
