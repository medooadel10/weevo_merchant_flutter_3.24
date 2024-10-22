import 'package:json_annotation/json_annotation.dart';

part 'add_product_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddProductResponseModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final String? image;
  final String length;
  final String width;
  final String height;
  final String weight;
  final int merchantId;
  AddProductResponseModel({
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.image,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.id,
    required this.merchantId,
  });
  factory AddProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddProductResponseModelFromJson(json);
}
