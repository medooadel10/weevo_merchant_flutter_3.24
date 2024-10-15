import 'package:json_annotation/json_annotation.dart';
import 'package:weevo_merchant_upgrade/core_new/data/models/state_model.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/shipment_details_model.dart';

import '../../../../core_new/data/models/city_model.dart';
import '../../../../core_new/data/models/courier_model.dart';
import '../../../shipment_details/data/models/product_model.dart';

part 'bulk_shipment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BulkShipmentModel {
  final int id;
  final int parentId;
  final String? receivingState;
  final String? receivingCity;
  final String? receivingStreet;
  final String? receivingLandmark;
  final String? receivingBuildingNumber;
  final String? receivingFloor;
  final String? receivingApartment;
  final String? receivingLat;
  final String? receivingLng;
  final String? dateToReceiveShipment;
  final String? deliveringState;
  final String? deliveringCity;
  final String? deliveringStreet;
  final String? deliveringLandmark;
  final String? deliveringBuildingNumber;
  final String? deliveringFloor;
  final String? deliveringApartment;
  final String? deliveringLat;
  final String? deliveringLng;
  final String? dateToDeliverShipment;
  final String? clientName;
  final String? clientPhone;
  final String? notes;
  final String? paymentMethod;
  final String? amount;
  final String? expectedShippingCost;
  final String? agreedShippingCost;
  final int? merchantId;
  final int? courierId;
  final String? status;
  final String? handoverCodeCourierToMerchant;
  final String? handoverQrcodeCourierToMerchant;
  final String? handoverCodeMerchantToCourier;
  final String? handoverQrcodeMerchantToCourier;
  final String? handoverCodeCourierToCustomer;
  final String? handoverQrcodeCourierToCustomer;
  final int? isOfferBased;
  final int? closed;
  final String? closedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? expiredAt;
  final String? agreedShippingCostAfterDiscount;
  final String? coupon;
  final String? flags;
  final StateModel? receivingStateModel;
  final StateModel? deliveringStateModel;
  final CityModel? receivingCityModel;
  final CityModel? deliveringCityModel;
  final List<ProductModel>? products;
  final List<ShipmentDetailsModel>? children;
  final CourierModel? courier;

  factory BulkShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$BulkShipmentModelFromJson(json);

  BulkShipmentModel({
    required this.id,
    required this.parentId,
    required this.receivingState,
    required this.receivingCity,
    required this.receivingStreet,
    required this.receivingLandmark,
    required this.receivingBuildingNumber,
    required this.receivingFloor,
    required this.receivingApartment,
    required this.receivingLat,
    required this.receivingLng,
    required this.dateToReceiveShipment,
    required this.deliveringState,
    required this.deliveringCity,
    required this.deliveringStreet,
    required this.deliveringLandmark,
    required this.deliveringBuildingNumber,
    required this.deliveringFloor,
    required this.deliveringApartment,
    required this.deliveringLat,
    required this.deliveringLng,
    required this.dateToDeliverShipment,
    required this.clientName,
    required this.clientPhone,
    required this.notes,
    required this.paymentMethod,
    required this.amount,
    required this.expectedShippingCost,
    required this.agreedShippingCost,
    required this.merchantId,
    required this.courierId,
    required this.status,
    required this.handoverCodeCourierToMerchant,
    required this.handoverQrcodeCourierToMerchant,
    required this.handoverCodeMerchantToCourier,
    required this.handoverQrcodeMerchantToCourier,
    required this.handoverCodeCourierToCustomer,
    required this.handoverQrcodeCourierToCustomer,
    required this.isOfferBased,
    required this.closed,
    required this.closedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.expiredAt,
    required this.agreedShippingCostAfterDiscount,
    required this.coupon,
    required this.flags,
    required this.receivingStateModel,
    required this.deliveringStateModel,
    required this.receivingCityModel,
    required this.deliveringCityModel,
    required this.products,
    required this.children,
    required this.courier,
  });
}
