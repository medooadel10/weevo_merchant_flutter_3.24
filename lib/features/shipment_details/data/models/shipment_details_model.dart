import 'package:json_annotation/json_annotation.dart';
import 'package:weevo_merchant_upgrade/core_new/data/models/courier_model.dart';
import 'package:weevo_merchant_upgrade/core_new/data/models/state_model.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/product_model.dart';

import '../../../../core_new/data/models/city_model.dart';

part 'shipment_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ShipmentDetailsModel {
  final int id;
  final int parentId;
  final String receivingState;
  final String receivingCity;
  final String receivingStreet;
  final String? receivingLandmark;
  final String? receivingBuildingNumber;
  final String? receivingFloor;
  final String? receivingApartment;
  final String receivingLat;
  final String receivingLng;
  final String dateToReceiveShipment;
  final String deliveringState;
  final String deliveringCity;
  final String deliveringStreet;
  final String? deliveringLandmark;
  final String? deliveringBuildingNumber;
  final String? deliveringFloor;
  final String? deliveringApartment;
  final String deliveringLat;
  final String deliveringLng;
  final String dateToDeliverShipment;
  final String clientName;
  final String clientPhone;
  final String? notes;
  final String paymentMethod;
  final String amount;
  final String? expectedShippingCost;
  final String? agreedShippingCost;
  final String? agreedShippingCostAfterDiscount;
  final int merchantId;
  final int? courierId;
  final String status;
  final String? handoverCodeCourierToMerchant;
  final String? handoverQrcodeCourierToMerchant;
  final String? handoverCodeMerchantToCourier;
  final String? handoverQrcodeMerchantToCourier;
  final String? handoverCodeCourierToCustomer;
  final String? handoverQrcodeCourierToCustomer;
  final int isOfferBased;
  final int closed;
  final String flags;
  final StateModel receivingStateModel;
  final CityModel receivingCityModel;
  final StateModel deliveringStateModel;
  final CityModel deliveringCityModel;
  final String updatedAt;
  final String createdAt;
  final List<ProductModel> products;
  final List<ShipmentDetailsModel> children;
  final CourierModel? courier;

  ShipmentDetailsModel(
    this.id,
    this.parentId,
    this.receivingState,
    this.receivingCity,
    this.receivingStreet,
    this.receivingLandmark,
    this.receivingBuildingNumber,
    this.receivingFloor,
    this.receivingApartment,
    this.receivingLat,
    this.receivingLng,
    this.dateToReceiveShipment,
    this.deliveringState,
    this.deliveringCity,
    this.deliveringStreet,
    this.deliveringLandmark,
    this.deliveringBuildingNumber,
    this.deliveringFloor,
    this.deliveringApartment,
    this.deliveringLat,
    this.deliveringLng,
    this.dateToDeliverShipment,
    this.clientName,
    this.clientPhone,
    this.notes,
    this.paymentMethod,
    this.amount,
    this.expectedShippingCost,
    this.agreedShippingCost,
    this.agreedShippingCostAfterDiscount,
    this.merchantId,
    this.courierId,
    this.status,
    this.handoverCodeCourierToMerchant,
    this.handoverQrcodeCourierToMerchant,
    this.handoverCodeMerchantToCourier,
    this.handoverQrcodeMerchantToCourier,
    this.handoverCodeCourierToCustomer,
    this.handoverQrcodeCourierToCustomer,
    this.isOfferBased,
    this.closed,
    this.flags,
    this.receivingStateModel,
    this.receivingCityModel,
    this.deliveringStateModel,
    this.deliveringCityModel,
    this.updatedAt,
    this.createdAt,
    this.products,
    this.children,
    this.courier,
  );

  factory ShipmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShipmentDetailsModelToJson(this);
}
