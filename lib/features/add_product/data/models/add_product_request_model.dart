import 'package:json_annotation/json_annotation.dart';

part 'add_product_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddProductRequestModel {
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final String image;
  final String length;
  final String width;
  final String height;
  final String weight;
  AddProductRequestModel({
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.image,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toJson() => _$AddProductRequestModelToJson(this);

  factory AddProductRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddProductRequestModelFromJson(json);
}
