// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourierModel _$CourierModelFromJson(Map<String, dynamic> json) => CourierModel(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['photo'] as String?,
      json['first_name'] as String,
      json['last_name'] as String,
      json['email'] as String,
      json['phone'] as String,
      json['gender'] as String?,
      (json['online'] as num).toInt(),
      json['delivery_method'] as String,
      json['cached_average_rating'] as String?,
    );

Map<String, dynamic> _$CourierModelToJson(CourierModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo': instance.photo,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'gender': instance.gender,
      'online': instance.online,
      'delivery_method': instance.deliveryMethod,
      'cached_average_rating': instance.cachedAverageRating,
    };
