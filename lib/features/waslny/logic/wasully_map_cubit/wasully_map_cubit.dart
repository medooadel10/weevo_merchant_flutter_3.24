import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

import '../../../../core/Models/address_fill.dart';
import '../../../../core/Models/placed_class.dart';
import '../../../../core_new/helpers/debouncer.dart';
import '../../data/repos/waslny_map_repo.dart';
import 'wasully_map_states.dart';

class WasullyMapCubit extends Cubit<WasullyMapStates> {
  final WaslyMapRepo _waslyMapRepo;
  WasullyMapCubit(this._waslyMapRepo) : super(WasullyMapInitialState());
  Position? _userPosition;
  GoogleMapController? mapController;
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  Future<void> getCurrentUserLocation(GoogleMapController controller) async {
    if (await _isLocationServiceEnabled() &&
        await _isLocationPermissionGranted()) {
      log('location permission granted');
      _userPosition = await Geolocator.getCurrentPosition();
      currentLocation =
          LatLng(_userPosition!.latitude, _userPosition!.longitude);
      mapController = controller;
      _animateToUserPosition();
    }
    log('location permission granted');
  }

  final location.Location _location = location.Location();
  Future<bool> _isLocationServiceEnabled() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  Future<bool> _isLocationPermissionGranted() async {
    var permissionStatus = await _location.hasPermission();
    if (permissionStatus == location.PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
    }
    return permissionStatus == location.PermissionStatus.granted;
  }

  void _animateToUserPosition() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_userPosition!.latitude, _userPosition!.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  final Debouncer _debouncer = Debouncer(milliseconds: 250);
  List<GetPlaceId> places = [];
  void searchLocation(String query) async {
    _debouncer.run(() async {
      if (query.isNotEmpty) {
        emit(WasullyMapSearchLoadingState());
        final result = await _waslyMapRepo.getPredictionList(query);
        if (result.success) {
          places = result.data ?? [];
          if (places.isNotEmpty) changeSearchContainerVisibility(true);
          emit(WasullyMapSearchSuccessState(places));
        } else {
          emit(WasullyMapSearchErrorState(result.error ?? ''));
        }
      }
    });
  }

  void clearPlaces() {
    places.clear();
    changeSearchContainerVisibility(false);
    emit(WasullyMapSearchSuccessState(places));
  }

  bool isSearchContainerVisible = false;
  void changeSearchContainerVisibility(bool visible) {
    isSearchContainerVisible = visible;
    emit(WasullyMapChangeSearchContainerVisibilityState(
        isSearchContainerVisible));
  }

  LatLng currentLocation = const LatLng(0, 0);
  void updateLocation({
    required GoogleMapController controller,
    required double lat,
    required double long,
    required WaslyMapState state,
  }) {
    currentLocation = LatLng(lat, long);
    if (state == WaslyMapState.fromSearch) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation,
            zoom: 14.0,
          ),
        ),
      );
      places.clear();
      getFullAddress();
    }
  }

  String? currentAddress;
  AddressFill? addressFill;
  void getFullAddress() async {
    emit(WasullyMapGetAddressLoadingState());
    final response = await _waslyMapRepo.getPlaceDetails(currentLocation);
    if (response.success && response.data!.isNotEmpty) {
      var addressComponents = response.data![0].addressComponents;
      String state = addressComponents
          .singleWhere((element) =>
              element.types.contains('administrative_area_level_1'))
          .longName;

      String city = addressComponents
          .singleWhere((element) =>
              element.types.contains('administrative_area_level_2'))
          .longName;

      String street = 'شارع بدون اسم';
      if (addressComponents
          .where((element) => element.types.contains('route'))
          .isNotEmpty) {
        street = addressComponents
            .singleWhere((element) => element.types.contains('route'))
            .longName;
      }
      currentAddress = '$street, $city, $state';
      addressFill = AddressFill(
        subAdministrativeArea: city,
        administrativeArea: state,
        street: street,
        lat: currentLocation.latitude,
        long: currentLocation.longitude,
        code: response.data![0].placeId,
      );
      emit(WasullyMapGetAddressSuccessState(currentAddress ?? ''));
    } else {
      emit(WasullyMapGetAddressErrorState(response.error ?? ''));
    }
  }

  void addSearchControllerListener() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        searchLocation(searchController.text);
      } else {
        changeSearchContainerVisibility(false);
      }
    });
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}

enum WaslyMapState {
  fromSearch,
  movingCamera,
}
