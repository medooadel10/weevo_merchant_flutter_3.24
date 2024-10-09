class DeliveryPriceRequestBody {
  final String recievingLat;
  final String recievingLng;
  final String sendingLat;
  final String sendingLng;

  DeliveryPriceRequestBody({
    required this.recievingLat,
    required this.recievingLng,
    required this.sendingLat,
    required this.sendingLng,
  });

  Map<String, dynamic> toJson() => {
        'receiving_lat': recievingLat,
        'receiving_lng': recievingLng,
        'delivering_lat': sendingLat,
        'delivering_lng': sendingLng,
        'wasully': true,
      };
}
