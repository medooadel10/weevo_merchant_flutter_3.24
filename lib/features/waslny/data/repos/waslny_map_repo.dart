import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/Models/placed_class.dart';
import '../../../../core_new/networking/data_result.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../models/places_response_body.dart';

class WaslyMapRepo {
  Future<DataResult<List<GetPlaceId>>> getPredictionList(String address) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?&query=$address&key=AIzaSyBTdtjPztYGOEWJxdnF6NZod1pER67fces&language=ar';
    try {
      final response = await DioFactory.getData(url: url);
      var places = (response.data['results'] as List)
          .map((element) => GetPlaceId.fromJson(element))
          .toList();
      return DataResult(data: places, success: true);
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<List<PlaceResult>>> getPlaceDetails(LatLng location) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=AIzaSyBTdtjPztYGOEWJxdnF6NZod1pER67fces&language=ar';
    try {
      final response = await DioFactory.getData(url: url);
      List<PlaceResult> places = (response.data['results'] as List).map((e) {
        return PlaceResult.fromJson(e);
      }).toList();
      return DataResult.success(places);
    } on DioException {
      return DataResult.error('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }
}
