import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Models/courier_offer.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';

class ChooseCaptainProvider with ChangeNotifier {
  NetworkState? _state;
  List<CourierOffer> _listOfOffers = [];
  List<CourierOffer> _newComerOffers = [];

  List<CourierOffer> get listOfOffers => _listOfOffers;

  NetworkState? get state => _state;

  Future<void> postShipmentToGetOffers({required int shipmentId}) async {
    try {
      log('ShipmentId: $shipmentId');
      _state = NetworkState.WAITING;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/post-shipment-to-get-offers',
        true,
      );
      log('post shipment to get offers -> ${r.body}');
      log('post shipment to get offers -> ${r.statusCode}');
      log('post shipment to get offers -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.SUCCESS;
      } else {
        log('Error in post shipment to get offers -> ${r.body}');
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> postShipmentToCouriers({required int shipmentId}) async {
    try {
      _state = NetworkState.WAITING;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/post-shipment-for-public',
        true,
      );
      log('post-shipment-for-public -> ${r.body}');
      log('post-shipment-for-public -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.SUCCESS;
      } else {
        log(r.body);
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> sendAcceptOffer({required int offerId}) async {
    try {
      _state = NetworkState.WAITING;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'shipping-offers/accept',
        true,
        body: {
          'offer_id': offerId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
      log(r.body);
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> courierOffers(
      {required int shipmentId, required bool isFirstTime}) async {
    try {
      if (isFirstTime) {
        _state = NetworkState.WAITING;
      } else {
        _state = NetworkState.LIVEDATA;
        notifyListeners();
      }

      Response r = await HttpHelper.instance.httpGet(
        'shipping-offers?shipment_id=$shipmentId',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.SUCCESS;
        if (isFirstTime) {
          _listOfOffers = [];
          _listOfOffers = (jsonDecode(r.body) as List)
              .map((e) => CourierOffer.fromJson(e))
              .where((r) =>
                  DateTime.now()
                      .difference(DateTime.parse(r.expiresAt ?? '2022-08-08'))
                      .inSeconds <
                  0)
              .toList();
        } else {
          _newComerOffers = [];
          if ((jsonDecode(r.body) as List).isNotEmpty) {
            (jsonDecode(r.body) as List)
                .map((e) => CourierOffer.fromJson(e))
                .forEach((i) {
              if (_listOfOffers.any((u) => (u.id == i.id))) {
                _listOfOffers.removeWhere((e) =>
                    ((i.id == e.id) &&
                        (DateTime.parse(i.updatedAt ?? '2022-08-08').isAfter(
                            DateTime.parse(e.updatedAt ?? '2022-08-08')))) ||
                    (DateTime.now()
                            .difference(
                                DateTime.parse(e.expiresAt ?? '2022-08-08'))
                            .inSeconds >
                        0));
                notifyListeners();
              } else if (_listOfOffers.any((u) =>
                  (DateTime.now().difference(
                          DateTime.parse(u.expiresAt ?? '2022-08-08')))
                      .inMinutes >=
                  5)) {
                _listOfOffers.removeWhere((e) =>
                    DateTime.now()
                        .difference(DateTime.parse(e.expiresAt ?? '2022-08-08'))
                        .inMinutes >=
                    5);
                notifyListeners();
              } else {
                if (DateTime.now()
                        .difference(DateTime.parse(i.expiresAt ?? '2022-08-08'))
                        .inSeconds >
                    0) {
                } else {
                  _newComerOffers.add(i);
                }
              }
            });
          } else {
            _listOfOffers.clear();
          }
          _listOfOffers.addAll(_newComerOffers);
          _listOfOffers.sort((a, b) =>
              DateTime.parse(a.updatedAt ?? '2022-08-08')
                  .compareTo(DateTime.parse(b.updatedAt ?? '2022-08-08')));
        }
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
      _state = NetworkState.ERROR;
    }
    notifyListeners();
  }
}
