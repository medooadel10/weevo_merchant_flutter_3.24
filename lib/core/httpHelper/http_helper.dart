import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import '../Providers/add_shipment_provider.dart';
import '../Providers/auth_provider.dart';
import '../Providers/map_provider.dart';
import '../Providers/product_provider.dart';
import '../Storage/shared_preference.dart';
import 'header_config.dart';

const String baseUrl =
    'https://eg.api.weevoapp.com/api/v1/merchant/'; // Production
// const String baseUrl =
//     'https://api-dev-mobile.weevoapp.com/api/v1/merchant/'; // Debug

class HttpHelper {
  static final HttpHelper instance = HttpHelper._instance();

  HttpHelper._instance();

  Future<Response> httpPost(String path, bool withAuth,
      {Map<String, dynamic>? body,
      bool withoutPath = false,
      bool isRefresh = true}) async {
    final Response r = await post(
        Uri.parse(withoutPath ? path : '$baseUrl$path'),
        body: json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    log('request URL -> ${r.request?.url}');
    log('statusCode -> ${r.statusCode}');
    log('userToken -> ${Preferences.instance.getAccessToken}');
    log('payload -> $body');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      log('decoded response -> ${json.decode(r.body)}');
    } else if (r.statusCode == 401) {
      if (isRefresh) {
        if (Preferences.instance.getPhoneNumber.isNotEmpty &&
            Preferences.instance.getPassword.isNotEmpty) {
          await AuthProvider.listenFalse(navigator.currentContext!).authLogin();
          await getData();
        }
      }
    }
    return r;
  }

  Future<Response> httpDelete(String path, bool withAuth,
      {Map<String, dynamic>? body}) async {
    final Response r = await delete(Uri.parse('$baseUrl$path'),
        body: body ?? json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    log('request URL -> ${r.request?.url}');
    log('statusCode -> ${r.statusCode}');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      log('decoded response -> ${json.decode(r.body)}');
    } else if (r.statusCode == 401) {
      if (Preferences.instance.getPhoneNumber.isNotEmpty &&
          Preferences.instance.getPassword.isNotEmpty) {
        await AuthProvider.listenFalse(navigator.currentContext!).authLogin();
        await getData();
      }
    }
    log('response -> ${r.body}');

    return r;
  }

  Future<Response> httpGet(String path, bool withAuth,
      {bool hasBase = true}) async {
    final Response r = await get(Uri.parse('${hasBase ? baseUrl : ''}$path'),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    log('request URL -> ${r.request?.url}');
    log('statusCode -> ${r.statusCode}');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      log('decoded response -> ${json.decode(r.body)}');
    } else if (r.statusCode == 401) {
      if (Preferences.instance.getPhoneNumber.isNotEmpty &&
          Preferences.instance.getPassword.isNotEmpty) {
        await AuthProvider.listenFalse(navigator.currentContext!).authLogin();
        await getData();
      }
    }
    log('response -> ${r.body}');
    return r;
  }

  Future<Response> httpPut(String path, bool withAuth,
      {Map<String, dynamic>? body}) async {
    final Response r = await put(Uri.parse('$baseUrl$path'),
        body: json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    log('request URL -> ${r.request?.url}');
    log('statusCode -> ${r.statusCode}');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      log('decoded response -> ${json.decode(r.body)}');
    } else if (r.statusCode == 401) {
      if (Preferences.instance.getPhoneNumber.isNotEmpty &&
          Preferences.instance.getPassword.isNotEmpty) {
        await AuthProvider.listenFalse(navigator.currentContext!).authLogin();
        await getData();
      }
    }
    log('response -> ${r.body}');
    return r;
  }

  Future<void> getData() async => Future.wait([
        AuthProvider.listenFalse(navigator.currentContext!)
            .getGroupsWithBanners(),
        AddShipmentProvider.listenFalse(navigator.currentContext!)
            .getCountries(),
        ProductProvider.listenFalse(navigator.currentContext!)
            .getAllCategories(),
        MapProvider.listenFalse(navigator.currentContext!).getAllAddress(false),
        ProductProvider.listenFalse(navigator.currentContext!)
            .getProducts(false),
        AuthProvider.listenFalse(navigator.currentContext!)
            .weevoSubscriptionValidation()
      ]);
}
