// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProductRequestModel _$AddProductRequestModelFromJson(
        Map<String, dynamic> json) =>
    AddProductRequestModel(
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: (json['category_id'] as num).toInt(),
      image: json['image'] as String,
      length: json['length'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
      weight: json['weight'] as String,
    );

Map<String, dynamic> _$AddProductRequestModelToJson(
        AddProductRequestModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category_id': instance.categoryId,
      'image': instance.image,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
      'weight': instance.weight,
    };
