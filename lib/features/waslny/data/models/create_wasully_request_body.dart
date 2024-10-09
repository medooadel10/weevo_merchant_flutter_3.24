class CreateWasullyRequestBody {
  final String title;
  final String description;
  final String receivingLat;
  final String receivingLng;
  final String deliveringLat;
  final String deliveringLng;
  final double price;
  final double amount;
  final int tip;
  final String phoneUser;
  final String clientPhone;
  final String receivingState;
  final String receivingCity;
  final String receivingStreet;
  final String deliveringState;
  final String deliveringCity;
  final String deliveringStreet;
  final String paymentMethod;
  final String whoPay;
  final String image;

  CreateWasullyRequestBody({
    required this.title,
    required this.description,
    required this.receivingLat,
    required this.receivingLng,
    required this.deliveringLat,
    required this.deliveringLng,
    required this.price,
    required this.amount,
    required this.tip,
    required this.phoneUser,
    required this.clientPhone,
    required this.receivingState,
    required this.receivingCity,
    required this.receivingStreet,
    required this.deliveringState,
    required this.deliveringCity,
    required this.deliveringStreet,
    required this.paymentMethod,
    required this.whoPay,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'receiving_lat': receivingLat,
        'receiving_lng': receivingLng,
        'delivering_lat': deliveringLat,
        'delivering_lng': deliveringLng,
        'price': price,
        'amount': amount,
        'tip': tip,
        'phone_user': phoneUser,
        'client_phone': clientPhone,
        'receiving_state': receivingState,
        'receiving_city': receivingCity,
        'receiving_street': receivingStreet,
        'delivering_state': deliveringState,
        'delivering_city': deliveringCity,
        'delivering_street': deliveringStreet,
        'payment_method': paymentMethod,
        'who_pay': whoPay,
        'image': image,
      };

  Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "receiving_lat": receivingLat,
        "receiving_lng": receivingLng,
        "delivering_lat": deliveringLat,
        "delivering_lng": deliveringLng,
        "price": price,
        "amount": amount,
        "tip": tip,
        "phone_user": phoneUser,
        "client_phone": clientPhone,
        "receiving_state": receivingState,
        "receiving_city": receivingCity,
        "receiving_street": receivingStreet,
        "delivering_state": deliveringState,
        "delivering_city": deliveringCity,
        "delivering_street": deliveringStreet,
        "payment_method": paymentMethod,
        "who_pay": whoPay,
        "image": image,
      };
}
