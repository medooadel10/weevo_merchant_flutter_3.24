import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart' as location;
import 'package:provider/provider.dart';

import '../Models/address.dart';
import '../Models/address_fill.dart';
import '../Models/main_address.dart';
import '../Models/placed_class.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';

class MapProvider extends ChangeNotifier {
  static MapProvider get(BuildContext context) =>
      Provider.of<MapProvider>(context);

  static MapProvider listenFalse(BuildContext context) =>
      Provider.of<MapProvider>(context, listen: false);

  String _currentAddress = '';
  static double? myLat, myLong;
  bool _addressLoading = false;
  bool _loadingSearchList = false;
  AddressFill? _addressFill;
  List<Address>? _address = [];
  Address? _fullAddress;
  String? _from;
  bool? _addressIsEmpty = false;
  int? _currentAddressId;
  NetworkState? deleteAddressState;
  NetworkState _state = NetworkState.WAITING;
  location.Location? _location;
  location.PermissionStatus? _permissionGranted;
  bool? _serviceEnabled;
  location.LocationData? _locationData;

  int? get currentAddressId => _currentAddressId;

  void setCurrentAddressId(int value) {
    _currentAddressId = value;
    notifyListeners();
  }

  void setInitCurrentAddressId(int value) {
    _currentAddressId = value;
  }

  NetworkState get state => _state;

  List<Address>? get address => _address;

  Future<void> addAddress(Address a) async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'address-book',
        true,
        body: a.toJson(),
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _address?.add(a);
        _addressIsEmpty = _address?.isEmpty;
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void setFullAddress(Address? value) {
    _fullAddress = value;
    notifyListeners();
  }

  void setInitFullAddress(Address value) {
    _fullAddress = value;
  }

  Future<void> updateAddress(Address a) async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'address-book/${a.id}?_method=PUT',
        true,
        body: a.toJson(),
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        int addressIndex = _address?.indexWhere(
              (item) => item.id == a.id,
            ) ??
            0;
        _address?[addressIndex] = a;
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteAddress(int id) async {
    try {
      deleteAddressState = NetworkState.WAITING;
      _address?.removeWhere((a) => a.id == id);
      _addressIsEmpty = _address?.isEmpty;
      notifyListeners();
      Response r = await HttpHelper.instance.httpDelete(
        'address-book/$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        deleteAddressState = NetworkState.SUCCESS;
      } else {
        deleteAddressState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> clearAddressList() async {
    _address?.clear();
    notifyListeners();
    await getAllAddress(true);
    notifyListeners();
  }

  Future<void> getAllAddress(bool isRefreshing) async {
    _address = [];
    try {
      if (!isRefreshing) {
        _state = NetworkState.WAITING;
      }
      Response r = await HttpHelper.instance.httpGet(
        'address-book',
        true,
      );
      log('address -> ${r.body}');
      log('address -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        MainAddress main = MainAddress.fromJson(jsonDecode(r.body));
        if (main.data!.isNotEmpty) {
          _address = main.data;
          _addressIsEmpty = _address?.isEmpty;
          if (Preferences.instance.getAddressId != -1) {
            _fullAddress = _address
                ?.where((i) => i.id == Preferences.instance.getAddressId)
                .toList()[0];
          }
        }
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log('address -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<location.LocationData> getUserLocation() async {
    _location = location.Location();
    if (await locationServiceEnabled() && await locationPermissionGranted()) {
      _location?.changeSettings(accuracy: location.LocationAccuracy.navigation);
      _locationData = await _location?.getLocation();
    }
    return _locationData!;
  }

  Future<bool> locationServiceEnabled() async {
    _serviceEnabled = await _location?.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await _location?.requestService();
      if (!_serviceEnabled!) {
        return false;
      }
    }
    return true;
  }

  Future<bool> locationPermissionGranted() async {
    _permissionGranted = await _location?.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _location?.requestPermission();
      if (_permissionGranted != location.PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void setFrom(String value) {
    _from = value;
    notifyListeners();
  }

  String? get from => _from;

  Address? get fullAddress => _fullAddress;

  bool? get addressIsEmpty => _addressIsEmpty;

  void setAddressLoading(bool value) {
    _addressLoading = value;
    notifyListeners();
  }

  void updateLocation({
    required GoogleMapController controller,
    required double lat,
    required double long,
    required MapState state,
  }) {
    myLat = lat;
    myLong = long;
    if (state == MapState.fromSearch) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(myLat!, myLong!),
            zoom: 18.0,
          ),
        ),
      );
      _searchList.clear();
    }
    notifyListeners();
  }

  String get currentAddress => _currentAddress;

  bool get addressLoading => _addressLoading;

  void getMyLocation(GoogleMapController controller) async {
    await getUserLocation();

    myLat = _locationData?.latitude ?? 0;
    myLong = _locationData?.longitude ?? 0;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(myLat!, myLong!),
          zoom: 18.0,
        ),
      ),
    );
    notifyListeners();
  }

  bool get loadingSearchList => _loadingSearchList;
  List<GetPlaceId> _searchList = [];

  List<GetPlaceId> get searchList => _searchList;

  void getPredictionList(String address) async {
    _loadingSearchList = true;
    notifyListeners();
    try {
      String url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?latlng=40.714224,-73.961452&query=$address&key=AIzaSyBTdtjPztYGOEWJxdnF6NZod1pER67fces&language=ar';

      Response response = await HttpHelper.instance.httpGet(
        url,
        false,
        hasBase: false,
      );
      if (response.statusCode == 200) {
        var dataDecoded = jsonDecode(response.body);
        var detailsList = dataDecoded['results'];
        var thisList = (detailsList as List)
            .map(
              (element) => GetPlaceId(
                formattedAddress: element['formatted_address'],
                name: element['name'],
                lat: element['geometry']['location']['lat'],
                lang: element['geometry']['location']['lng'],
              ),
            )
            .toList();
        _searchList = thisList;
        _loadingSearchList = false;
        notifyListeners();
      }
    } catch (error) {
      log(error.toString());
    }
  }

  void initResetCurrentAddress() {
    _currentAddress = '';
    _searchList = [];
    myLat = 0;
    myLong = 0;
  }

  void getFullAddress() async {
    List<Placemark> addresses = await placemarkFromCoordinates(
      myLat!,
      myLong!,
    );
    _currentAddress =
        '${addresses.first.street}, ${addresses.first.subAdministrativeArea}, ${addresses.first.administrativeArea}, ${addresses.first.country}';
    _addressFill = AddressFill(
      subAdministrativeArea: addresses.first.subAdministrativeArea ?? '',
      administrativeArea: addresses.first.administrativeArea ?? '',
      street: addresses.first.street ?? '',
      lat: myLat!,
      long: myLong!,
    );
    notifyListeners();
  }

  AddressFill? get addressFill => _addressFill;
}

enum MapState {
  fromSearch,
  movingCamera,
}
