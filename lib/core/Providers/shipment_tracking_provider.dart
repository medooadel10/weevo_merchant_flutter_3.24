import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import '../Dialogs/loading.dart';
import '../Models/directions.dart';
import '../Models/refresh_qr_code.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';

class ShipmentTrackingProvider with ChangeNotifier {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  Directions? _directions;
  NetworkState? _state;
  RefreshQrcode? _refreshQrcode;
  bool _ctmQrCodeError = false;

  bool get ctmQrCodeError => _ctmQrCodeError;

  RefreshQrcode? get refreshQrcode => _refreshQrcode;

  Future<void> getDirections({
    required BuildContext context,
    required GoogleMapController controller,
    required LatLng directionFrom,
    required LatLng directionTo,
  }) async {
    _state = NetworkState.WAITING;
    showDialog(
        context: navigator.currentContext!,
        barrierDismissible: false,
        builder: (context) => Loading());
    ByteData originByteData =
        await DefaultAssetBundle.of(context).load("assets/images/origin.png");
    ByteData destinationByteData =
        await DefaultAssetBundle.of(navigator.currentContext!)
            .load("assets/images/destination.png");
    var originIcon = originByteData.buffer.asUint8List();
    var destinationIcon = destinationByteData.buffer.asUint8List();
    Response r = await get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${directionFrom.latitude},${directionFrom.longitude}&destination=${directionTo.latitude},${directionTo.longitude}&language=ar&key=AIzaSyB_4B59IxChSRS5-VHdYmSs6DWIVWkIro4'));
    if (r.statusCode >= 200 && r.statusCode < 300) {
      _directions = Directions.fromMap(jsonDecode(r.body));
      _markers.clear();
      _polyLines.clear();
      _markers.add(Marker(
        markerId: const MarkerId('Origin'),
        infoWindow: const InfoWindow(title: 'مكان التسليم'),
        icon: BitmapDescriptor.bytes(originIcon),
        position: directionFrom,
      ));
      _markers.add(Marker(
        markerId: const MarkerId('Destination'),
        infoWindow: const InfoWindow(title: 'مكان الاستلام'),
        icon: BitmapDescriptor.bytes(destinationIcon),
        position: directionTo,
      ));
      _polyLines.add(Polyline(
          polylineId: const PolylineId('polyline overview'),
          color: Colors.grey[600]!,
          width: 6,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          points: _directions!.polylinePoints
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList()));
      Navigator.pop(navigator.currentContext!);
      _state = NetworkState.SUCCESS;
      controller.animateCamera(
          CameraUpdate.newLatLngBounds(_directions!.bounds, 100.0));
    } else {
      Navigator.pop(navigator.currentContext!);
      _state = NetworkState.SUCCESS;
    }
    notifyListeners();
  }

  Future<void> trackUser({
    required BuildContext context,
    required GoogleMapController controller,
    required LatLng newLocation,
  }) async {
    ByteData trackingByteData = await DefaultAssetBundle.of(context)
        .load("assets/images/tracking_car_super_small.png");
    var trackingIcon = trackingByteData.buffer.asUint8List();
    _markers.removeWhere((Marker m) => m.markerId.value == 'tracking');
    _markers.add(Marker(
      markerId: const MarkerId('tracking'),
      icon: BitmapDescriptor.bytes(trackingIcon),
      position: newLocation,
    ));
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: newLocation,
      zoom: 17.0,
    )));
    notifyListeners();
  }

  Future<void>
      handleReturnedShipmentByValidatingHandoverQrCodeCourierToMerchant(
          int shipmentId, int qrCode) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
          'shipments/$shipmentId/handle-returned-shipments-by-validating-handover-code-ctm',
          true,
          body: {
            'code': qrCode,
          });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log('handleReturnedShipmentByValidatingHandoverQrCodeCourierToMerchant -> ${json.decode(r.body)}');
        _state = NetworkState.SUCCESS;
      } else {
        if (json.decode(r.body)['message'] == 'invalid code!') {
          _ctmQrCodeError = true;
        } else {
          _ctmQrCodeError = false;
        }
        log('handleReturnedShipmentByValidatingHandoverQrCodeCourierToMerchant -> ${json.decode(r.body)}');
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> reviewCourier({
    int? shipmentId,
    int? rating,
    String? title,
    String? body,
    String? recommend,
  }) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'review-courier-shipment',
        true,
        body: {
          'shipment_id': shipmentId,
          'rating': rating,
          'title': title,
          'body': body,
          'recommend': recommend,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log('review merchant -> ${json.decode(r.body)}');
        _state = NetworkState.SUCCESS;
      } else {
        log('review merchant -> ${json.decode(r.body)}');
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> refreshHandoverQrCodeCourierToCustomer(int shipmentId) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/refresh-handover-qrcode-ctc',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log('refreshHandoverQrCodeCourierToCustomer -> ${json.decode(r.body)}');
        _refreshQrcode = RefreshQrcode.fromJson(json.decode(r.body));
        _state = NetworkState.SUCCESS;
      } else {
        log('refreshHandoverQrCodeCourierToCustomer -> ${json.decode(r.body)}');
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> refreshHandoverQrCodeMerchantToCourier(int shipmentId) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/refresh-handover-qrcode-mtc',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log('refreshHandoverQrCodeMerchantToCourier -> ${json.decode(r.body)}');
        _refreshQrcode = RefreshQrcode.fromJson(json.decode(r.body));
        _state = NetworkState.SUCCESS;
      } else {
        log('refreshHandoverQrCodeMerchantToCourier -> ${json.decode(r.body)}');
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Set<Marker> get markers => _markers;

  NetworkState? get state => _state;

  Directions? get directions => _directions;

  Set<Polyline> get polyLines => _polyLines;
}
