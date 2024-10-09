class DeliveryPriceResponseBody {
  final String price;
  final String distance;

  DeliveryPriceResponseBody(this.price, this.distance);

  factory DeliveryPriceResponseBody.fromJson(Map<String, dynamic> json) =>
      DeliveryPriceResponseBody(
        json['price'],
        json['distance'],
      );
}
