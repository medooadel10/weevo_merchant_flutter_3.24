import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/data_result.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/dio_factory.dart';

import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../models/shipment_details_model.dart';

class ShipmentDetailsRepo {
  Future<DataResult<ShipmentDetailsModel>> getShipmentDetails(
      int shipmentId) async {
    try {
      final response = await DioFactory.getData(
        url: '${ApiConstants.shipmentsUrl}/$shipmentId',
        token: Preferences.instance.getAccessToken,
      );
      return DataResult.success(
        ShipmentDetailsModel.fromJson(response.data),
      );
    } on DioException catch (e) {
      return DataResult.error(
        e.response?.data['message'] ??
            e.message ??
            e.error?.toString() ??
            'حدث خطأ ما, الرجاء المحاولة مرة اخرى',
      );
    }
  }

  Future<DataResult<void>> cancelShipment(int shipmentId, String reason) async {
    try {
      await DioFactory.postData(
        url: '${ApiConstants.shipmentsUrl}/$shipmentId/cancel',
        token: Preferences.instance.getAccessToken,
        data: {
          'cancellation_reason': reason,
        },
      );
      return DataResult.success(null);
    } on DioException catch (e) {
      log('cancel shipment error ${e.response?.data['message']}');
      return DataResult.error(
        e.response?.data['message'] ??
            e.message ??
            e.error?.toString() ??
            'حدث خطأ ما, الرجاء المحاولة مرة اخرى',
      );
    }
  }

  Future<DataResult<void>> updateShippingCost(
      int shipmentId, String cost) async {
    try {
      await DioFactory.putData(
        url: '${ApiConstants.shipmentsUrl}/$shipmentId',
        data: {
          'expected_shipping_cost': cost,
          'agreed_shipping_cost_after_discount': cost,
        },
        token: Preferences.instance.getAccessToken,
      );
      return DataResult.success(null);
    } on DioException catch (e) {
      return DataResult.error(
        e.response?.data['message'] ??
            e.message ??
            e.error?.toString() ??
            'حدث خطأ ما, الرجاء المحاولة مرة اخرى',
      );
    }
  }

  Future<DataResult<void>> restoreCancelledShipment(int shipmentId) async {
    try {
      await DioFactory.postData(
        url: '${ApiConstants.shipmentsUrl}/$shipmentId/restore-cancelled',
        data: {},
        token: Preferences.instance.getAccessToken,
      );
      return DataResult.success(null);
    } on DioException catch (e) {
      return DataResult.error(
        e.response?.data['message'] ??
            e.message ??
            e.error?.toString() ??
            'حدث خطأ ما, الرجاء المحاولة مرة اخرى',
      );
    }
  }
}
