// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProductResponseModel _$AddProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    AddProductResponseModel(
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['category_id'] as num).toInt(),
      image: json['image'] as String?,
      length: json['length'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
      weight: json['weight'] as String,
      id: (json['id'] as num).toInt(),
      merchantId: (json['merchant_id'] as num).toInt(),
    );

Map<String, dynamic> _$AddProductResponseModelToJson(
        AddProductResponseModel instance) =>
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
    };
