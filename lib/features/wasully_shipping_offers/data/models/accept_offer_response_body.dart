class AcceptOfferResponseBody {
  final String message;

  AcceptOfferResponseBody(this.message);

  factory AcceptOfferResponseBody.fromJson(Map<String, dynamic> json) =>
      AcceptOfferResponseBody(json['message']);
}
