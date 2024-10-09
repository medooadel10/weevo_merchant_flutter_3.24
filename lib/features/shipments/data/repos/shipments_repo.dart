import 'package:dio/dio.dart';

import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/data_result.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../models/shipments_response_body_model.dart';

class ShipmentsRepo {
  Future<DataResult<ShipmentsResponseBody>> getShipments(
    int page,
    String status,
  ) async {
    final String token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.getData(
        url: ApiConstants.shipmentsUrl,
        token: token,
        query: {
          'page': page,
          'status': status,
        },
      );
      return DataResult(
        data: ShipmentsResponseBody.fromJson(response.data),
        success: true,
      );
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }
}
