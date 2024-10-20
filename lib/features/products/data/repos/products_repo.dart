import 'package:dio/dio.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/api_constants.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/data_result.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/dio_factory.dart';

import '../../../../core/Storage/shared_preference.dart';
import '../models/products_response_body_model.dart';

class ProductsRepo {
  Future<DataResult<ProductsResponseBodyModel>> getProducts(int page) async {
    try {
      final response = await DioFactory.getData(
        url: ApiConstants.products,
        query: {
          'page': page,
        },
        token: Preferences.instance.getAccessToken,
      );
      return DataResult.success(
        ProductsResponseBodyModel.fromJson(response.data),
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
}
