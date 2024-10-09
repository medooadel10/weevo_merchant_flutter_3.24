

class WasullyUpdatePriceRequestBody {
  final String price;

  WasullyUpdatePriceRequestBody({
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'price': price,
      };
}
