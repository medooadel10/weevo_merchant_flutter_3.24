import 'package:json_annotation/json_annotation.dart';
import 'package:weevo_merchant_upgrade/core_new/data/models/product_category.dart';

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
  final dynamic length;
  final dynamic width;
  final dynamic height;
  final dynamic weight;
  final int merchantId;
  final ProductCategory productCategory;

  ProductModel(
    this.id,
    this.name,
    this.description,
    this.price,
    this.categoryId,
    this.image,
    this.length,
    this.width,
    this.height,
    this.weight,
    this.merchantId,
    this.productCategory,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
