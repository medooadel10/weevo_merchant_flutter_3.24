import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../features/Screens/Fragments/add_shipment_1.dart';
import '../../features/Screens/Fragments/add_shipment_2.dart';
import '../../features/Screens/Fragments/add_shipment_3.dart';
import '../../features/Screens/Fragments/add_shipment_4.dart';
import '../../features/Widgets/loading_dialog.dart';
import '../../features/shipment_details/data/models/shipment_details_model.dart';
import '../Dialogs/action_dialog.dart';
import '../Models/address.dart';
import '../Models/child_shipment.dart';
import '../Models/city.dart';
import '../Models/country.dart';
import '../Models/coupon_model.dart';
import '../Models/price_from_distance.dart';
import '../Models/product_model.dart';
import '../Models/shipment_model.dart';
import '../Models/shipment_notification.dart';
import '../Models/state.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';
import '../router/router.dart';

class AddShipmentProvider with ChangeNotifier {
  static AddShipmentProvider get(BuildContext context) =>
      Provider.of<AddShipmentProvider>(context);

  static AddShipmentProvider listenFalse(BuildContext context) =>
      Provider.of<AddShipmentProvider>(context, listen: false);

  Widget _w = const AddShipment1();
  int _currentIndex = 0;
  int? _previousIndex; // Allow this to be null
  bool test = false;
  final Preferences preferences = Preferences.instance;
  TextEditingController receiveLocationAddressNameController =
      TextEditingController();
  TextEditingController receiveLocationLatController = TextEditingController();
  TextEditingController receiveLocationLangController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  bool _shipmentFromInside = false;
  NetworkState?
      _countriesState; // NetworkState should be updated for null safety
  bool isUpdated = false;
  bool isUpdateFromServer = false;
  String? _shipmentMessage;
  String? _shipmentFromWhere;
  String? _updateServerShipmentFromWhere;
  final List<ChildShipment> _shipments = [];
  Address? _merchantAddress; // Address model should be updated for null safety
  String? _realDeliveryDateTime;
  int? _shipmentId;
  String? _realReceiveDateTime;
  String? _stateName;
  String? _cityName;
  String? _landmarkName;
  String? _clientAddress;
  String? _clientPhoneNumber;
  String? _clientName;
  String? _paymentMethod;
  String? _otherDetails;
  String? _shipmentFee;

  double _total = 0.0;
  bool _isNotEmpty = false;
  List<Product> _chosenProducts = [];
  List<Product> _shipmentProducts = [];
  List<Product> _searchList = [];
  List<States> _statesFilterList = [];
  List<Cities> _citiesFilterList = [];
  List<States> states = [];
  NetworkState? _state;
  NetworkState? _cancelShipmentState;
  NetworkState? _restoreShipmentState;
  int? _captainShipmentId;
  String? _captainShippingCost;
  ShipmentNotification? _shipmentNotification;
  String? _cancelMessage;

  List<Product> get searchList => _searchList;

  bool get shipmentFromInside => _shipmentFromInside;

  bool get isNotEmpty => _isNotEmpty;

  void setIsUpdated(bool updated) {
    isUpdated = updated;
    notifyListeners();
  }

  NetworkState? get cancelShipmentState => _cancelShipmentState;

  int? get captainShipmentId => _captainShipmentId;

  String? get captainShippingCost => _captainShippingCost;

  int? getStateIdByName(String stateName) {
    States? state = states.firstWhereOrNull((x) {
      return stateName.noramlizeText().contains(x.name?.noramlizeText() ?? '');
    });
    return state?.id;
  }

  NetworkState? get state => _state;

  void setShipmentFromInside(bool v) {
    _shipmentFromInside = v;
  }

  NetworkState? get countriesState => _countriesState;

  int? getCityIdByName(String stateName, String cityName) {
    Cities? cities;
    States? state = states.firstWhereOrNull(
      (x) => x.name == stateName,
    );
    cities = state?.cities?.firstWhereOrNull((y) => y.name == cityName);
    return cities?.id;
  }

  String? get cancelMessage => _cancelMessage;

  int? get shipmentId => _shipmentId;

  void setIsUpdatedFromServer(bool updated) {
    isUpdateFromServer = updated;
    notifyListeners();
  }

  String? getStateNameById(int id) =>
      states.firstWhereOrNull((i) => i.id == id)?.name;

  String? getCityNameById(int stateId, int cityId) {
    Cities? cities;
    States? state = states.firstWhereOrNull((x) => x.id == stateId);
    cities = state?.cities?.firstWhereOrNull((y) => y.id == cityId);
    return cities?.name;
  }

  List<Product> get shipmentProducts => _shipmentProducts;

  void addShipmentProducts(List<Product> products) {
    _shipmentProducts = [];
    _shipmentProducts.addAll(products);
  }

  void updateShipmentProduct(Product product) {
    int productInShipmentIndex = _shipmentProducts.indexWhere(
      (item) => item.name == product.name,
    );
    int productInChosenIndex = _chosenProducts.indexWhere(
      (item) => item.name == product.name,
    );
    _shipmentProducts[productInShipmentIndex] = product;
    _chosenProducts[productInChosenIndex] = product;
    notifyListeners();
  }

  Future<void> getCountries() async {
    states = [];
    _countriesState = NetworkState.WAITING;
    try {
      Response r =
          await HttpHelper.instance.httpGet('location/countries', true);
      log('countries -> ${json.decode(r.body)}');
      log('countries ->  ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        var data = jsonDecode(r.body) as List;
        Countries countries = Countries.fromJson(data[0]);
        states = countries.states ?? [];
        _countriesState = NetworkState.SUCCESS;
      } else {
        _countriesState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  PriceFromDistanceModel? priceFromDistanceModel;

  Future<void> getPriceFromLocation() async {
    try {
      int? stateId = getStateIdByName(stateName ?? '');
      Response r = await HttpHelper.instance.httpPost(
        'shipments/calculate-distance-price',
        true,
        body: {
          'receiving_lat': _merchantAddress?.lat,
          'receiving_lng': _merchantAddress?.lng,
          'delivering_lat': receiveLocationLatController.text,
          'delivering_lng': receiveLocationLangController.text,
          'merchant_id': preferences.getUserId,
          "stateId": stateId,
        },
      );
      log('getPriceFromLocation Body -> ${{
        'receiving_lat': _merchantAddress?.lat,
        'receiving_lng': _merchantAddress?.lng,
        'delivering_lat': receiveLocationLatController.text,
        'delivering_lng': receiveLocationLangController.text,
        'merchantId': preferences.getUserId,
        "stateId": stateId,
      }}');
      log('getPriceFromLocation Body -> ${r.body}');
      log('getPriceFromLocation statusCode -> ${r.statusCode}');
      log('getPriceFromLocation request -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        priceFromDistanceModel =
            PriceFromDistanceModel.fromJson(json.decode(r.body));
      } else {}
    } catch (e) {
      log('location -> ${e.toString()}');
    }
  }

  void setShipmentFromWhere(String value) {
    _shipmentFromWhere = value;
  }

// use it to know from where you are coming from details shipment with one product or more than one;

  void setUpdateServerShipmentFromWhere(String value) {
    _updateServerShipmentFromWhere = value;
  }

  String? get updateServerShipmentFromWhere => _updateServerShipmentFromWhere;

  String? get shipmentFromWhere => _shipmentFromWhere;

  void setData({
    required ChildShipment model,
    required int i,
  }) {
    _realDeliveryDateTime = model.dateToDeliverShipment;
    _realReceiveDateTime = model.dateToReceiveShipment;
    _clientAddress = model.receivingStreet;
    _clientName = model.clientName;
    _paymentMethod = model.paymentMethod == 'cod'
        ? paymentList[1].paymentMethodTitle
        : paymentList[0].paymentMethodTitle;
    _landmarkName = model.receivingLandmark;
    _cityName = getCityNameById(int.parse(model.receivingState ?? '0'),
        int.parse(model.receivingCity ?? '0'));
    _stateName = getStateNameById(int.parse(model.receivingState ?? '0'));
    _clientPhoneNumber = model.clientPhone;
    _otherDetails = model.notes;
    _chosenProducts = model.products ?? [];
    _shipmentFee = model.shippingCost;
    // _productTotalPrice = model.amount;
    _total = double.parse(model.amount ?? '0');
    _previousIndex = i;
    _isNotEmpty = _chosenProducts.isNotEmpty;
    notifyListeners();
  }

  void setDataFromServer({
    required ShipmentDetailsModel model,
  }) {
    _shipmentId = model.id;
    _realDeliveryDateTime = model.dateToDeliverShipment;
    _realReceiveDateTime = model.dateToReceiveShipment;
    _clientAddress = model.receivingStreet;
    _clientName = model.clientName;
    _paymentMethod = model.paymentMethod == 'cod'
        ? paymentList[1].paymentMethodTitle
        : paymentList[0].paymentMethodTitle;
    _landmarkName = model.receivingLandmark;
    _cityName = getCityNameById(int.tryParse(model.receivingState) ?? 0,
        int.tryParse(model.receivingCity) ?? 0);
    _stateName = getStateNameById(int.tryParse(model.receivingState) ?? 0);
    _clientPhoneNumber = model.clientPhone;
    _otherDetails = model.notes;
    _chosenProducts = model.products
        .map((e) => Product(
              id: e.productInfo.id,
              name: e.productInfo.name,
              width: e.productInfo.width,
              height: e.productInfo.height,
              length: e.productInfo.length,
              weight: e.productInfo.weight,
              quantity: e.qty,
              image: e.productInfo.image,
              price: e.price,
              description: e.productInfo.description,
              categoryId: e.productInfo.categoryId,
            ))
        .toList();
    _shipmentFee = model.expectedShippingCost ?? '0';
    // _productTotalPrice = model.amount;
    _total = double.parse(model.amount);
    _isNotEmpty = _chosenProducts.isNotEmpty;
    notifyListeners();
  }

  Future<void> updateOneShipment({
    required ChildShipment shipment,
    required String userId,
  }) async {
    try {
      _state = NetworkState.WAITING;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId?_method=PUT',
        true,
        body: {
          'receiving_state': shipment.receivingState,
          'receiving_city': shipment.receivingCity,
          'receiving_street': shipment.receivingStreet,
          'receiving_landmark': shipment.receivingLandmark,
          'receiving_lat': shipment.receivingLat,
          'receiving_lng': shipment.receivingLng,
          'date_to_receive_shipment': shipment.dateToReceiveShipment,
          'delivering_state': shipment.deliveringState,
          'delivering_city': shipment.deliveringCity,
          'delivering_street': shipment.deliveringStreet,
          'delivering_landmark': shipment.deliveringLandmark,
          'delivering_building_number': shipment.deliveringBuildingNumber,
          'delivering_floor': shipment.deliveringFloor,
          'delivering_apartment': shipment.deliveringApartment,
          'delivering_lat': shipment.deliveringLat,
          'delivering_lng': shipment.deliveringLng,
          'payment_method': shipment.paymentMethod,
          'date_to_deliver_shipment': shipment.dateToDeliverShipment,
          'client_name': shipment.clientName,
          'client_phone': shipment.clientPhone,
          'notes': shipment.notes,
          'coupon': shipment.coupon,
          'amount': shipment.amount,
          'expected_shipping_cost': shipment.shippingCost,
          'agreed_shipping_cost_after_discount': shipment.shippingCost,
          'merchant_id': userId,
          'products': shipment.products
              ?.map((e) => {
                    'id': e.id,
                    'qty': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        },
      );
      log('bulk shipment response -> ${r.body}');
      log('bulk shipment response -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
      _state = NetworkState.ERROR;
    }
    notifyListeners();
  }

  Future<void> addBulkShipment({
    required List<ChildShipment> uploadedShipments,
    required String userId,
  }) async {
    try {
      _state = NetworkState.WAITING;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'shipments/bulk',
        true,
        body: {
          'shipments': uploadedShipments
              .map((uploadedShipment) => <String, dynamic>{
                    'receiving_state': uploadedShipment.receivingState,
                    'receiving_city': uploadedShipment.receivingCity,
                    'receiving_street': uploadedShipment.receivingStreet,
                    'receiving_landmark': uploadedShipment.receivingLandmark,
                    'receiving_lat': uploadedShipment.receivingLat,
                    'receiving_lng': uploadedShipment.receivingLng,
                    'date_to_receive_shipment':
                        uploadedShipment.dateToReceiveShipment,
                    'delivering_state': uploadedShipment.deliveringState,
                    'delivering_city': uploadedShipment.deliveringCity,
                    'delivering_street': uploadedShipment.deliveringStreet,
                    'delivering_landmark': uploadedShipment.deliveringLandmark,
                    'delivering_building_number':
                        uploadedShipment.deliveringBuildingNumber,
                    'delivering_floor': uploadedShipment.deliveringFloor,
                    'delivering_apartment':
                        uploadedShipment.deliveringApartment,
                    'delivering_lat': uploadedShipment.deliveringLat,
                    'delivering_lng': uploadedShipment.deliveringLng,
                    'payment_method': uploadedShipment.paymentMethod,
                    'date_to_deliver_shipment':
                        uploadedShipment.dateToDeliverShipment,
                    'client_name': uploadedShipment.clientName,
                    'client_phone': uploadedShipment.clientPhone,
                    'coupon': uploadedShipment.coupon,
                    'notes': uploadedShipment.notes,
                    'amount': uploadedShipment.amount,
                    'expected_shipping_cost': uploadedShipment.shippingCost,
                    'merchant_id': userId,
                    'products': uploadedShipment.products
                        ?.map((e) => {
                              'id': e.id,
                              'qty': e.quantity,
                              'price': e.price,
                            })
                        .toList(),
                  })
              .toList(),
        },
      );
      log('bulk shipment response -> ${r.body}');
      log('bulk shipment response -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _captainShipmentId = jsonDecode(r.body)['id'];
        _captainShippingCost = jsonDecode(r.body)['expected_shipping_cost'];
        log('bulk shipment response -> ${r.body}');
        _shipmentNotification = ShipmentNotification(
          childrenShipment: (jsonDecode(r.body)['children'] as List).length,
          merchantFcmToken: Preferences.instance.getFcmToken,
          merchantImage: Preferences.instance.getUserPhotoUrl,
          merchantName: Preferences.instance.getUserName,
          receivingState: jsonDecode(r.body)['children'][0]['receiving_state'],
          shipmentId: jsonDecode(r.body)['id'],
          shippingCost: jsonDecode(r.body)['expected_shipping_cost'].toString(),
          totalShipmentCost: jsonDecode(r.body)['amount'].toString(),
          deliveryState: jsonDecode(r.body)['children'][0]['delivering_state'],
        );
        log('shipmentNotification -> ${shipmentNotification.toString()}');
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  bool couponFound = false;
  CouponModel? couponModel;

  Future<void> checkCoupons() async {
    try {
      couponModel = null;
      if (couponCodeController.text.isNotEmpty) {
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => const LoadingDialog());
      }
      Response r = await HttpHelper.instance
          .httpPost('coupons/checkCoupon', true, body: {
        'couponType': couponCodeController.text.isNotEmpty ? '1' : '3',
        if (couponCodeController.text.isEmpty) 'userId': preferences.getUserId,
        if (couponCodeController.text.isNotEmpty)
          'code': couponCodeController.text
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        if (couponCodeController.text.isNotEmpty) {
          couponFound = false;
          MagicRouter.pop();
        } else {
          couponFound = true;
        }
        couponModel = CouponModel.fromJson(json.decode(r.body));
      } else {
        if (couponCodeController.text.isNotEmpty) {
          MagicRouter.pop();
          showDialog(
              context: navigator.currentContext!,
              builder: (_) => ActionDialog(
                    content: r.body.contains('message')
                        ? '${json.decode(r.body)['message']}'
                        : r.body,
                    approveAction: 'حسناً',
                    onApproveClick: () {
                      MagicRouter.pop();
                      couponCodeController.clear();
                    },
                  ));
        } else {
          couponFound = false;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> addOneShipment({
    required ChildShipment shipment,
    required String userId,
  }) async {
    try {
      _state = NetworkState.WAITING;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'shipments',
        true,
        body: {
          'receiving_state': shipment.receivingState,
          'receiving_city': shipment.receivingCity,
          'receiving_street': shipment.receivingStreet,
          'receiving_landmark': shipment.receivingLandmark,
          'receiving_lat': shipment.receivingLat,
          'receiving_lng': shipment.receivingLng,
          'date_to_receive_shipment': shipment.dateToReceiveShipment,
          'delivering_state': shipment.deliveringState,
          'delivering_city': shipment.deliveringCity,
          'delivering_street': shipment.deliveringStreet,
          'delivering_landmark': shipment.deliveringLandmark,
          'delivering_building_number': shipment.deliveringBuildingNumber,
          'delivering_floor': shipment.deliveringFloor,
          'delivering_apartment': shipment.deliveringApartment,
          'delivering_lat': shipment.deliveringLat,
          'delivering_lng': shipment.deliveringLng,
          'payment_method': shipment.paymentMethod,
          'date_to_deliver_shipment': shipment.dateToDeliverShipment,
          'client_name': shipment.clientName,
          'client_phone': shipment.clientPhone,
          'notes': shipment.notes,
          'coupon': shipment.coupon,
          'amount': shipment.amount,
          'expected_shipping_cost': shipment.shippingCost,
          'merchant_id': userId,
          'products': shipment.products
              ?.map((e) => {
                    'id': e.id,
                    'qty': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        },
      );
      log('one shipment payload -> ${{
        'receiving_state': shipment.receivingState,
        'receiving_city': shipment.receivingCity,
        'receiving_street': shipment.receivingStreet,
        'receiving_landmark': shipment.receivingLandmark,
        'receiving_lat': shipment.receivingLat,
        'receiving_lng': shipment.receivingLng,
        'date_to_receive_shipment': shipment.dateToReceiveShipment,
        'delivering_state': shipment.deliveringState,
        'delivering_city': shipment.deliveringCity,
        'delivering_street': shipment.deliveringStreet,
        'delivering_landmark': shipment.deliveringLandmark,
        'delivering_building_number': shipment.deliveringBuildingNumber,
        'delivering_floor': shipment.deliveringFloor,
        'delivering_apartment': shipment.deliveringApartment,
        'delivering_lat': shipment.deliveringLat,
        'delivering_lng': shipment.deliveringLng,
        'payment_method': shipment.paymentMethod,
        'date_to_deliver_shipment': shipment.dateToDeliverShipment,
        'client_name': shipment.clientName,
        'client_phone': shipment.clientPhone,
        'notes': shipment.notes,
        'amount': shipment.amount,
        'expected_shipping_cost': shipment.shippingCost,
        'merchant_id': userId,
        'products': shipment.products
            ?.map((e) => {
                  'id': e.id,
                  'qty': e.quantity,
                  'price': e.price,
                })
            .toList(),
      }}');
      log('one shipment response -> ${r.body}');
      log('one shipment statusCode -> ${r.statusCode}');
      log('one shipment url -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _captainShipmentId = jsonDecode(r.body)['id'];
        _captainShippingCost =
            jsonDecode(r.body)['expected_shipping_cost'].toString();
        log('one shipment response -> ${r.body}');
        _shipmentNotification = ShipmentNotification(
          childrenShipment: 0,
          merchantFcmToken: Preferences.instance.getFcmToken,
          merchantImage: Preferences.instance.getUserPhotoUrl,
          merchantName: Preferences.instance.getUserName,
          receivingState: jsonDecode(r.body)['receiving_state_model']['name'],
          receivingCity: jsonDecode(r.body)['receiving_city_model']['name'],
          deliveryCity: jsonDecode(r.body)['delivering_city_model']['name'],
          shipmentId: jsonDecode(r.body)['id'],
          shippingCost: jsonDecode(r.body)['expected_shipping_cost'].toString(),
          totalShipmentCost: jsonDecode(r.body)['amount'].toString(),
          deliveryState: jsonDecode(r.body)['delivering_state_model']['name'],
        );
        log('shipmentNotification -> ${shipmentNotification.toString()}');
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> cancelShipment({
    required int shipmentId,
  }) async {
    try {
      _cancelShipmentState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/cancel',
        true,
      );
      log('cancelShipment -> ${r.body}');
      log('cancelShipment -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _cancelMessage = jsonDecode(r.body)['message'];
        _cancelShipmentState = NetworkState.SUCCESS;
      } else {
        _cancelShipmentState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> restoreCancelShipment({
    required int shipmentId,
  }) async {
    try {
      _restoreShipmentState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/restore-cancelled',
        true,
      );
      log(r.body);
      log('${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        FirebaseFirestore.instance
            .collection('locations')
            .where('shipmentId', isEqualTo: shipmentId)
            .get()
            .then((value) {
          for (var element in value.docs) {
            FirebaseFirestore.instance
                .collection('locations')
                .doc(element.id)
                .delete();
          }
        });
        Response r1 = await HttpHelper.instance.httpPost(
          'shipments/$shipmentId/post-shipment-to-get-offers',
          true,
        );
        log(r1.body);
        log('${r1.statusCode}');
        if (r1.statusCode >= 200 && r1.statusCode < 300) {
          _restoreShipmentState = NetworkState.SUCCESS;
        }
      } else {
        _restoreShipmentState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
      _state = NetworkState.ERROR;
    }
    notifyListeners();
  }

  void setShipmentNotification(ShipmentNotification v) {
    _shipmentNotification = v;
  }

  void setCaptainShipmentId(int v) {
    _captainShipmentId = v;
  }

  ShipmentNotification? get shipmentNotification => _shipmentNotification;

  void getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        _w = const AddShipment1();
        break;
      case 1:
        _w = const AddShipment2();
        break;
      case 2:
        _w = const AddShipment3();
        break;
      case 3:
        _w = const AddShipment4();
        break;
    }
  }

  void setShipmentMessage(String? msg) {
    _shipmentMessage = msg;
  }

  String? get shipmentMessage => _shipmentMessage;

  void setIndex(int i) {
    _currentIndex = i;
    getCurrentPage();
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  Widget get w => _w;

  void setPrice() {
    _total = 0;
    if (_isNotEmpty) {
      for (var item in _chosenProducts) {
        _total += item.price ?? 0 * (item.quantity ?? 0);
      }
    }
  }

  void addShipmentProduct(Product item) {
    _chosenProducts.add(item);
    _isNotEmpty = _chosenProducts.isNotEmpty;
    setPrice();
    notifyListeners();
  }

  void removeShipmentProduct(Product item) {
    _chosenProducts.removeWhere((i) => i.id == item.id);
    _isNotEmpty = _chosenProducts.isNotEmpty;
    setPrice();
    notifyListeners();
  }

  void addAllChosenProduct(List<Product> products) {
    _chosenProducts.clear();
    _chosenProducts.addAll(products);
    _isNotEmpty = _chosenProducts.isNotEmpty;
    setPrice();
    notifyListeners();
  }

  double get total => _total;

  bool isChosen(Product item) {
    Product? p = _chosenProducts.firstWhereOrNull(
      (i) => i.id == item.id,
    );
    return p == null ? false : true;
  }

  void filterShipment(List<Product> shipmentList, String title) {
    _searchList = [];
    _searchList = shipmentList
        .where(
          (element) =>
              element.name?.toLowerCase().contains(title.toLowerCase()) ??
              false,
        )
        .toList();
    notifyListeners();
  }

  void filterStates(List<States> states, String title) {
    _statesFilterList = states
        .where(
          (element) => element.name?.contains(title.toLowerCase()) ?? false,
        )
        .toList();
    notifyListeners();
  }

  void filterCities(List<Cities> cities, String title) {
    _citiesFilterList = cities
        .where(
          (element) => element.name?.contains(title.toLowerCase()) ?? false,
        )
        .toList();
    notifyListeners();
  }

  void setRealDeliveryDateTime(String v) {
    _realDeliveryDateTime = v;
    notifyListeners();
  }

  void setRealReceiveDateTime(String? v) {
    _realReceiveDateTime = v;
    notifyListeners();
  }

  void setChosenList(List<Product> v) {
    _chosenProducts = v;
    notifyListeners();
  }

  void setClientAddress(String? v) {
    _clientAddress = v;
    notifyListeners();
  }

  void setClientPhoneNumber(String? v) {
    _clientPhoneNumber = v;
    notifyListeners();
  }

  void setClientName(String? v) {
    _clientName = v;
    notifyListeners();
  }

  void setPaymentMethod(String? v) {
    _paymentMethod = v;
    notifyListeners();
  }

  void setOtherDetails(String? v) {
    _otherDetails = v;
    notifyListeners();
  }

  void setShipmentFee(String? v) {
    _shipmentFee = v;
    notifyListeners();
  }

  int? get previousIndex => _previousIndex;

  void setMerchantAddress(Address a) {
    _merchantAddress = a;
    notifyListeners();
  }

  void setCityName(String? value) {
    _cityName = value;
    notifyListeners();
  }

  void setStateName(String value) {
    _stateName = value;
    notifyListeners();
  }

  void setLandmarkName(String? value) {
    _landmarkName = value;
    notifyListeners();
  }

// void setProductTotalPrice(String v) {
//   _productTotalPrice = v;
// }

  void addNewShipment(ChildShipment a) {
    _shipments.add(a);
    notifyListeners();
  }

  void deleteShipment(ShipmentModel d) {
    _shipments.remove(d);
    notifyListeners();
  }

  void updateShipment(ChildShipment u, int i) {
    _shipments.removeAt(i);
    _shipments.insert(i, u);
    notifyListeners();
  }

  List<ChildShipment> get shipments => _shipments;

  Address? get merchantAddress => _merchantAddress;

  String? get realDeliveryDateTime => _realDeliveryDateTime;

  String? get stateName => _stateName;

  String? get cityName => _cityName;

  String? get clientAddress => _clientAddress;

  String? get clientPhoneNumber => _clientPhoneNumber;

  String? get clientName => _clientName;

  String? get paymentMethod => _paymentMethod;

  String? get otherDetails => _otherDetails;

  String? get landmark => _landmarkName;

  List<Product> get chosenProducts => _chosenProducts;

  String? get shipmentFee => _shipmentFee;

// String get productTotalPrice => _productTotalPrice;

  void reset(bool isUpdated) {
    _realDeliveryDateTime = null;
    _merchantAddress = null;
    _clientAddress = null;
    _clientPhoneNumber = null;
    _clientName = null;
    _paymentMethod = null;
    _otherDetails = null;
    _landmarkName = null;
    _cityName = null;
    _stateName = null;
    _realReceiveDateTime = null;
    // _productTotalPrice = null;
    _total = 0;
    _shipmentFee = null;
    if (!isUpdated) {
      _chosenProducts.clear();
      _isNotEmpty = _chosenProducts.isNotEmpty;
    }
  }

  List<States> get statesFilterList => _statesFilterList;

  String? get realReceiveDateTime => _realReceiveDateTime;

  List<Cities> get citiesFilterList => _citiesFilterList;

  NetworkState? get restoreShipmentState => _restoreShipmentState;
}
