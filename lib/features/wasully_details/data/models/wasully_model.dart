import '../../../../core/Models/courier.dart';
import '../../../../core_new/data/models/city_model.dart';
import '../../../../core_new/data/models/state_model.dart';

class WasullyModel {
  final int id;
  final String slug;
  final String title;
  final String? image;
  final String userPhone;
  final String clientPhone;
  final String whoPay;
  final String paymentMethod;
  final String status;
  final StateModel? receivingStateModel;
  final CityModel? receivingCityModel;
  final String? receivingCity;
  final String? receivingState;
  final String? receivingStreet;
  final StateModel? deliveringStateModel;
  final CityModel? deliveringCityModel;
  final String? deliveringCity;
  final String? deliveringState;
  final String? deliveringStreet;
  final String? receivingLat;
  final String? receivingLng;
  final String? deliveringLat;
  final String? deliveringLng;
  final String price;
  final String amount;
  final int? tip; // nullable
  final String? createdAt;
  final String? updatedAt;
  final int merchantId;
  final int? courierId;
  final String? handoverQrcodeCourierToCustomer;
  final String? handoverCodeCourierToCustomer;
  final String? handoverQrcodeMerchantToCourier;
  final String? handoverCodeMerchantToCourier;
  final String? handoverQrcodeCourierToMerchant;
  final String? handoverCodeCourierToMerchant;
  final String? closedAt;
  final int? closed;
  final int? isOfferBased;
  final Courier? courier;

  WasullyModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.image,
    required this.userPhone,
    required this.clientPhone,
    required this.whoPay,
    required this.paymentMethod,
    required this.status,
    required this.receivingStateModel,
    required this.receivingCityModel,
    required this.receivingStreet,
    required this.deliveringStateModel,
    required this.deliveringCityModel,
    required this.deliveringStreet,
    required this.receivingLat,
    required this.receivingLng,
    required this.deliveringLat,
    required this.deliveringLng,
    required this.price,
    required this.amount,
    required this.tip,
    required this.createdAt,
    required this.updatedAt,
    required this.merchantId,
    required this.courierId, // nullable
    required this.handoverQrcodeCourierToCustomer, // nullable
    required this.handoverCodeCourierToCustomer, // nullable
    required this.handoverQrcodeMerchantToCourier, // nullable
    required this.handoverCodeMerchantToCourier, // nullable
    required this.handoverQrcodeCourierToMerchant, // nullable
    required this.handoverCodeCourierToMerchant, // nullable
    required this.closedAt, // nullable
    required this.closed,
    required this.isOfferBased,
    required this.courier,
    required this.receivingCity,
    required this.receivingState,
    required this.deliveringCity,
    required this.deliveringState,
  });

  factory WasullyModel.fromJson(Map<String, dynamic> json) {
    return WasullyModel(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      image: json['image'],
      userPhone: json['phone_user'],
      clientPhone: json['client_phone'],
      whoPay: json['who_pay'],
      paymentMethod: json['payment_method'],
      status: json['status'],
      receivingStateModel: StateModel.fromJson(json['receiving_state_model']),
      receivingCityModel: CityModel.fromJson(json['receiving_city_model']),
      receivingStreet: json['receiving_street'],
      deliveringStateModel: StateModel.fromJson(json['delivering_state_model']),
      deliveringCityModel: CityModel.fromJson(json['delivering_city_model']),
      deliveringStreet: json['delivering_street'],
      receivingLat: json['receiving_lat'],
      receivingLng: json['receiving_lng'],
      deliveringLat: json['delivering_lat'],
      deliveringLng: json['delivering_lng'],
      price: json['price'].toString(),
      amount: json['amount'].toString(),
      tip: json['tip'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      merchantId: json['merchant_id'],
      courierId: json['courier_id'],
      handoverQrcodeCourierToCustomer:
          json['handover_qrcode_courier_to_customer'],
      handoverCodeCourierToCustomer: json['handover_code_courier_to_customer'],
      handoverQrcodeMerchantToCourier:
          json['handover_qrcode_merchant_to_courier'],
      handoverCodeMerchantToCourier: json['handover_code_merchant_to_courier'],
      handoverQrcodeCourierToMerchant:
          json['handover_qrcode_courier_to_merchant'],
      handoverCodeCourierToMerchant: json['handover_code_courier_to_merchant'],
      closedAt: json['closed_at'],
      closed: json['closed'],
      isOfferBased: json['is_offer_based'],
      courier: Courier.fromJson(json['courier'] ?? {}),
      receivingCity: json['receiving_city'] is int
          ? '${json['receiving_city']}'
          : json['receiving_city'],
      receivingState: json['receiving_state'] is int
          ? '${json['receiving_state']}'
          : json['receiving_state'],
      deliveringCity: json['delivering_city'] is int
          ? '${json['delivering_city']}'
          : json['delivering_city'],
      deliveringState: json['delivering_state'] is int
          ? '${json['delivering_state']}'
          : json['delivering_state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
    };
  }
}
