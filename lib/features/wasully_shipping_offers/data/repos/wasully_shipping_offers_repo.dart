import 'package:dio/dio.dart';

import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/data_result.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../../../wasully_details/data/models/wasully_model.dart';
import '../models/accept_offer_response_body.dart';
import '../models/courier_response_body.dart';

class WasullyShippingOffersRepo {
  Future<DataResult<List<ShippingOfferResponseBody>>> getCouriers(
      int id) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.getData(
        url: ApiConstants.shippingOffers,
        token: token,
        query: {
          'shipment_id': id,
        },
      );
      List<ShippingOfferResponseBody> data = [];
      for (var item in response.data) {
        if (item['driver'] != null) {
          data.add(ShippingOfferResponseBody.fromJson(item));
        }
      }
      return DataResult.success(data);
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<AcceptOfferResponseBody>> acceptOffer(int id) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url: ApiConstants.acceptShippingOffers,
        token: token,
        data: {'offer_id': id},
      );
      return DataResult.success(
        AcceptOfferResponseBody.fromJson(response.data),
      );
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<String>> getShipmentStatus(int id) async {
    final String token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.getData(
        url: '${ApiConstants.wasullyDetailsUrl}/$id',
        token: token,
      );
      return DataResult(
        data: WasullyModel.fromJson(response.data).status,
        success: true,
      );
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }
}
