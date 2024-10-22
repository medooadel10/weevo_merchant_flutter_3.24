import 'package:dio/dio.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/api_constants.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/data_result.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/dio_factory.dart';
import 'package:weevo_merchant_upgrade/features/add_product/data/models/add_product_request_model.dart';

import '../models/add_product_response_model.dart';

class AddProductRepo {
  Future<DataResult<AddProductResponseModel>> addProduct(
      AddProductRequestModel data) async {
    try {
      final response = await DioFactory.postData(
        url: ApiConstants.products,
        data: data.toJson(),
        token: Preferences.instance.getAccessToken,
      );
      return DataResult.success(
          AddProductResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return DataResult.error(e.response?.data['message'] ?? 'حدث خطأ ما');
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
      return DataResult.error(e.response?.data['message'] ?? 'حدث خطأ ما');
    }
  }
}
