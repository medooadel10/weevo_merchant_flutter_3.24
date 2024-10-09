import 'product_model.dart';

class AddProductArg {
  final bool isUpdated;
  final bool isDuplicate;
  final Product? product;
  final String? from;

  AddProductArg({
    required this.isUpdated,
    required this.isDuplicate,
    this.product,
    this.from,
  });
}
