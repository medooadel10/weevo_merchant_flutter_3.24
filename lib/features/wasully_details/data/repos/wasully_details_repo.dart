import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/data_result.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../models/wasully_model.dart';
import '../models/wasully_update_price_request_body.dart';

class WasullyDetailsRepo {
  Future<DataResult<WasullyModel>> getWasullyDetails(int id) async {
    final String token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.getData(
        url: '${ApiConstants.wasullyDetailsUrl}/$id',
        token: token,
      );
      return DataResult(
        data: WasullyModel.fromJson(response.data),
        success: true,
      );
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<WasullyModel>> updateWasullyPrice({
    required int id,
    required WasullyUpdatePriceRequestBody body,
  }) async {
    final String token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.putData(
        url: '${ApiConstants.updateWasullyUrl}/$id',
        token: token,
        data: body.toJson(),
      );
      return DataResult(
        data: WasullyModel.fromJson(response.data),
        success: true,
      );
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>> cancelWasully(int id, String reason) async {
    final String token = Preferences.instance.getAccessToken;
    try {
      await DioFactory.postData(
        url: '${ApiConstants.cancelWasullyUrl}/$id/cancel',
        token: token,
        data: {
          'cancellation_reason': reason,
        },
      );
      return DataResult(
        success: true,
      );
    } on DioException catch (e) {
      log('cancel wasully error $id-> ${e.response?.data}');
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>> restoreWasully(int id) async {
    final String token = Preferences.instance.getAccessToken;
    try {
      await DioFactory.postData(
        url: '${ApiConstants.restoreWasullyUrl}/$id/restore-cancelled',
        token: token,
        data: {},
      );
      return DataResult(
        success: true,
      );
    } on DioException catch (e) {
      log('restore wasully error $id-> ${e.response?.data}');
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }
}
