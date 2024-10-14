// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_shipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkShipmentModel _$BulkShipmentModelFromJson(Map<String, dynamic> json) =>
    BulkShipmentModel(
      id: (json['id'] as num).toInt(),
      parentId: (json['parent_id'] as num).toInt(),
      receivingState: json['receiving_state'] as String?,
      receivingCity: json['receiving_city'] as String?,
      receivingStreet: json['receiving_street'] as String?,
      receivingLandmark: json['receiving_landmark'] as String?,
      receivingBuildingNumber: json['receiving_building_number'] as String?,
      receivingFloor: json['receiving_floor'] as String?,
      receivingApartment: json['receiving_apartment'] as String?,
      receivingLat: json['receiving_lat'] as String?,
      receivingLng: json['receiving_lng'] as String?,
      dateToReceiveShipment: json['date_to_receive_shipment'] as String?,
      deliveringState: json['delivering_state'] as String?,
      deliveringCity: json['delivering_city'] as String?,
      deliveringStreet: json['delivering_street'] as String?,
      deliveringLandmark: json['delivering_landmark'] as String?,
      deliveringBuildingNumber: json['delivering_building_number'] as String?,
      deliveringFloor: json['delivering_floor'] as String?,
      deliveringApartment: json['delivering_apartment'] as String?,
      deliveringLat: json['delivering_lat'] as String?,
      deliveringLng: json['delivering_lng'] as String?,
      dateToDeliverShipment: json['date_to_deliver_shipment'] as String?,
      clientName: json['client_name'] as String?,
      clientPhone: json['client_phone'] as String?,
      notes: json['notes'] as String?,
      paymentMethod: json['payment_method'] as String?,
      amount: json['amount'] as String?,
      expectedShippingCost: json['expected_shipping_cost'] as String?,
      agreedShippingCost: json['agreed_shipping_cost'] as String?,
      merchantId: (json['merchant_id'] as num?)?.toInt(),
      courierId: (json['courier_id'] as num?)?.toInt(),
      status: json['status'] as String?,
      handoverCodeCourierToMerchant:
          json['handover_code_courier_to_merchant'] as String?,
      handoverQrcodeCourierToMerchant:
          json['handover_qrcode_courier_to_merchant'] as String?,
      handoverCodeMerchantToCourier:
          json['handover_code_merchant_to_courier'] as String?,
      handoverQrcodeMerchantToCourier:
          json['handover_qrcode_merchant_to_courier'] as String?,
      handoverCodeCourierToCustomer:
          json['handover_code_courier_to_customer'] as String?,
      handoverQrcodeCourierToCustomer:
          json['handover_qrcode_courier_to_customer'] as String?,
      isOfferBased: (json['is_offer_based'] as num?)?.toInt(),
      closed: (json['closed'] as num?)?.toInt(),
      closedAt: json['closed_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      expiredAt: json['expired_at'] as String?,
      agreedShippingCostAfterDiscount:
          json['agreed_shipping_cost_after_discount'] as String?,
      coupon: json['coupon'] as String?,
      flags: json['flags'] as String?,
      receivingStateModel: json['receiving_state_model'] == null
          ? null
          : StateModel.fromJson(
              json['receiving_state_model'] as Map<String, dynamic>?),
      deliveringStateModel: json['delivering_state_model'] == null
          ? null
          : StateModel.fromJson(
              json['delivering_state_model'] as Map<String, dynamic>?),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => ShipmentDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      courier: json['courier'] == null
          ? null
          : CourierModel.fromJson(json['courier'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BulkShipmentModelToJson(BulkShipmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'receiving_state': instance.receivingState,
      'receiving_city': instance.receivingCity,
      'receiving_street': instance.receivingStreet,
      'receiving_landmark': instance.receivingLandmark,
      'receiving_building_number': instance.receivingBuildingNumber,
      'receiving_floor': instance.receivingFloor,
      'receiving_apartment': instance.receivingApartment,
      'receiving_lat': instance.receivingLat,
      'receiving_lng': instance.receivingLng,
      'date_to_receive_shipment': instance.dateToReceiveShipment,
      'delivering_state': instance.deliveringState,
      'delivering_city': instance.deliveringCity,
      'delivering_street': instance.deliveringStreet,
      'delivering_landmark': instance.deliveringLandmark,
      'delivering_building_number': instance.deliveringBuildingNumber,
      'delivering_floor': instance.deliveringFloor,
      'delivering_apartment': instance.deliveringApartment,
      'delivering_lat': instance.deliveringLat,
      'delivering_lng': instance.deliveringLng,
      'date_to_deliver_shipment': instance.dateToDeliverShipment,
      'client_name': instance.clientName,
      'client_phone': instance.clientPhone,
      'notes': instance.notes,
      'payment_method': instance.paymentMethod,
      'amount': instance.amount,
      'expected_shipping_cost': instance.expectedShippingCost,
      'agreed_shipping_cost': instance.agreedShippingCost,
      'merchant_id': instance.merchantId,
      'courier_id': instance.courierId,
      'status': instance.status,
      'handover_code_courier_to_merchant':
          instance.handoverCodeCourierToMerchant,
      'handover_qrcode_courier_to_merchant':
          instance.handoverQrcodeCourierToMerchant,
      'handover_code_merchant_to_courier':
          instance.handoverCodeMerchantToCourier,
      'handover_qrcode_merchant_to_courier':
          instance.handoverQrcodeMerchantToCourier,
      'handover_code_courier_to_customer':
          instance.handoverCodeCourierToCustomer,
      'handover_qrcode_courier_to_customer':
          instance.handoverQrcodeCourierToCustomer,
      'is_offer_based': instance.isOfferBased,
      'closed': instance.closed,
      'closed_at': instance.closedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'expired_at': instance.expiredAt,
      'agreed_shipping_cost_after_discount':
          instance.agreedShippingCostAfterDiscount,
      'coupon': instance.coupon,
      'flags': instance.flags,
      'receiving_state_model': instance.receivingStateModel,
      'delivering_state_model': instance.deliveringStateModel,
      'children': instance.children,
      'products': instance.products,
      'courier': instance.courier,
    };
