import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/data_result.dart';

import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../models/bulk_shipment_model.dart';

class BulkShipmentDetailsRepo {
  Future<DataResult<BulkShipmentModel>> getBulkShipmentDetails(int id) async {
    try {
      log('token ${Preferences.instance.getAccessToken}');
      final String token = Preferences.instance.getAccessToken;
      final response = await DioFactory.getData(
        url: '${ApiConstants.shipmentsUrl}/$id',
        token: token,
      );
      return DataResult.success(BulkShipmentModel.fromJson(response.data));
    } on DioException catch (e) {
      log(e.toString());
      return DataResult.error(e.toString());
    }
  }
}
