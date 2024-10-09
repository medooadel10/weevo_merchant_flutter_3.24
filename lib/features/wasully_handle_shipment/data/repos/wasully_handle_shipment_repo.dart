import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/Models/refresh_qr_code.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/data_result.dart';
import '../../../../core_new/networking/dio_factory.dart';

class WasullyHandleShipmentRepo {
  Future<DataResult<RefreshQrcode>> refreshHandoverQrCodeMerchantToCourier(
      int shipmentId) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/merchant/wasuliy/wasuliy/$shipmentId/refresh-handover-qrcode-mtc',
        data: {},
        token: token,
      );
      return DataResult.success(RefreshQrcode.fromJson(response.data));
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<RefreshQrcode>> refreshHandoverQrCodeCourierToCustomer(
      int shipmentId) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/merchant/wasuliy/wasuliy/$shipmentId/refresh-handover-qrcode-ctc',
        data: {},
        token: token,
      );
      return DataResult.success(RefreshQrcode.fromJson(response.data));
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>>
      handleReturnedShipmentByValidatingHandoverQrCodeCourierToMerchant(
          int shipmentId, int qrCode) async {
    final token = Preferences.instance.getAccessToken;
    try {
      await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/merchant/wasuliy/$shipmentId/handle-returned-shipments-by-validating-handover-code-ctm',
        data: {
          'code': qrCode,
        },
        token: token,
      );
      return DataResult.success(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
      } else {
        log('response -> ${e.response?.data}');
        if (e.response?.data['message'] == 'invalid code!') {
          return DataResult.error(
              'الكود الذي أدخلته غير صحيح\nيرجي التأكد من الكود\nوأعادة المحاولة مرة آخري');
        }
        return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
      }
    }
  }

  Future<DataResult<void>> reviewCourier({
    required int shipmentId,
    required int rating,
    required String title,
    required String? body,
    required String recommend,
  }) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/merchant/wasuliy/review-courier-shipment',
        data: {
          'shipment_id': shipmentId,
          'rating': rating,
          'title': title,
          'body': body,
          'recommend': recommend,
        },
        token: token,
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return DataResult.success(null);
      } else if (response.statusCode == 401) {
        return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
      } else {
        return DataResult.error('أدخل القيم بطريقة صحيحة');
      }
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }
}
