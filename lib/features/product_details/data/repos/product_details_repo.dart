import 'package:dio/dio.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/data_result.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/dio_factory.dart';

class ProductDetailsRepo {
  Future<DataResult<ProductModel>> getProductDetails(int id) async {
    try {
      final response = await DioFactory.getData(
        url: '${ApiConstants.products}/$id',
        token: Preferences.instance.getAccessToken,
      );
      return DataResult.success(ProductModel.fromJson(response.data));
    } on DioException catch (e) {
      return DataResult.error(e.response?.data['message'] ?? 'حدث خطأ ما');
    }
  }

  Future<DataResult<void>> deleteProduct(int id) async {
    try {
      await DioFactory.deleteData(
        url: '${ApiConstants.products}/$id',
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
