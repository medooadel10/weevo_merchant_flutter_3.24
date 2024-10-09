import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/Models/address.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/data_result.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../../../wasully_details/data/models/wasully_model.dart';
import '../models/create_wasully_request_body.dart';
import '../models/create_wasully_response_body.dart';
import '../models/delivery_price_request_body.dart';
import '../models/delivery_price_response_body.dart';

class WaslnyRepo {
  Future<DataResult<List<Address>>> getAddresses() async {
    try {
      final token = Preferences.instance.getAccessToken;
      final response = await DioFactory.getData(
        url: ApiConstants.addressUrl,
        token: token,
      );
      return DataResult(
        data: (response.data['data'] as List)
            .map((e) => Address.fromJson(e))
            .toList(),
        success: true,
      );
    } on DioException catch (e) {
      log('error ${e.response!.data['message']}');
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<DeliveryPriceResponseBody>> calculateDeliveryPrice(
      DeliveryPriceRequestBody body) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url: ApiConstants.deliveryPriceUrl,
        data: body.toJson(),
        token: token,
      );
      return DataResult(
        data: DeliveryPriceResponseBody.fromJson(response.data),
        success: true,
      );
    } on DioException catch (e) {
      if (e.response!.data['message'] == 'shipment.invalid locations') {
        return DataResult.error('لا يمكن التوصيل في نفس العنوان');
      }
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<CreateWasullyResponseBody>> createWasully(
    CreateWasullyRequestBody body,
  ) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url: ApiConstants.createWasully,
        token: token,
        data: body.toJson(),
      );
      return DataResult(
        data: CreateWasullyResponseBody.fromJson(response.data),
        success: true,
      );
    } on DioException catch (e) {
      log('error1 ${e.response!.data}');
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<String>> uploadImage(
      String imagePath, String fileName) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url: ApiConstants.uploadImage,
        token: token,
        data: {
          'file': imagePath,
          'filename': fileName,
        },
      );
      return DataResult(
        data: response.data['path'],
        success: true,
      );
    } on DioException catch (e) {
      log('ErrorImage: ${e.response!.data}');
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<WasullyModel>> updateWasully(
      int id, CreateWasullyRequestBody body) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.putData(
        url: '${ApiConstants.updateWasullyUrl}/$id',
        token: token,
        data: body.toJson(),
      );
      log('update wasully response ${response.data}');
      return DataResult(
        data: WasullyModel.fromJson(response.data),
        success: true,
      );
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>> deleteImage(String imagePath) async {
    final token = Preferences.instance.getAccessToken;
    try {
      await DioFactory.deleteData(
        url: ApiConstants.deleteImageUrl,
        token: token,
        data: {
          'filename': imagePath,
          'token': token,
        },
      );

      return DataResult(
        data: null,
        success: true,
      );
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }
}
