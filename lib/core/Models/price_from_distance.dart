class PriceFromDistanceModel {
  String? distance;
  String? price;

  PriceFromDistanceModel({this.distance, this.price});

  PriceFromDistanceModel.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['price'] = price;
    return data;
  }
}
