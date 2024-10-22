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
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'],
      categoryId: (json['category_id'] as num).toInt(),
      image: json['image'] as String?,
      length: json['length'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
      weight: json['weight'] as String,
      merchantId: (json['merchant_id'] as num).toInt(),
      category: CategoryData.fromJson(
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
      'product_category': instance.category,
    };
