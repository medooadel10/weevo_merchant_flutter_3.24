// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_response_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsResponseBodyModel _$ProductsResponseBodyModelFromJson(
        Map<String, dynamic> json) =>
    ProductsResponseBodyModel(
      (json['total'] as num).toInt(),
      (json['per_page'] as num).toInt(),
      (json['current_page'] as num).toInt(),
      (json['data'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductsResponseBodyModelToJson(
        ProductsResponseBodyModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'data': instance.data,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['description'] as String,
      json['price'],
      (json['category_id'] as num).toInt(),
      json['image'] as String?,
      json['length'],
      json['width'],
      json['height'],
      json['weight'],
      (json['merchant_id'] as num).toInt(),
      ProductCategory.fromJson(
          json['product_category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category_id': instance.categoryId,
      'image': instance.image,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
      'weight': instance.weight,
      'merchant_id': instance.merchantId,
      'product_category': instance.productCategory,
    };
