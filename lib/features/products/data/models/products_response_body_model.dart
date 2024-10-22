import 'package:json_annotation/json_annotation.dart';

import '../../../../core/Models/category_data.dart';

part 'products_response_body_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductsResponseBodyModel {
  final int total;
  final int perPage;
  final int currentPage;
  final List<ProductModel> data;

  ProductsResponseBodyModel(
    this.total,
    this.perPage,
    this.currentPage,
    this.data,
  );

  factory ProductsResponseBodyModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseBodyModelFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductModel {
  final int id;
  final String name;
  final String? description;
  final dynamic price;
  final int categoryId;
  final String? image;
  final String length;
  final String width;
  final String height;
  final String weight;
  final int merchantId;
  @JsonKey(name: "product_category")
  final CategoryData category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.image,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.merchantId,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
