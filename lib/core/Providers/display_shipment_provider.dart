import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../features/Screens/new_shipment_offer_based.dart';
import '../Dialogs/action_dialog.dart';
import '../Dialogs/loading.dart';
import '../Models/bulk_shipment.dart';
import '../Models/courier_review.dart';
import '../Models/display_bulk_shipment.dart';
import '../Models/display_child_details.dart';
import '../Models/shipment_response.dart';
import '../Models/shipment_status.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';

class DisplayShipmentProvider with ChangeNotifier {
  static DisplayShipmentProvider get(BuildContext context) =>
      Provider.of<DisplayShipmentProvider>(context);

  static DisplayShipmentProvider listenFalse(BuildContext context) =>
      Provider.of<DisplayShipmentProvider>(context, listen: false);

  List<DisplayBulkShipment> _offerBasedShipments = [];
  final List<DisplayBulkShipment> _availableShipments = [];
  final List<DisplayBulkShipment> _unCompletedShipments = [];
  final List<DisplayBulkShipment> _merchantAcceptedShipments = [];
  final List<DisplayBulkShipment> _courierOnHisWayToGetShipmentShipments = [];
  final List<DisplayBulkShipment> _deliveredShipments = [];
  final List<DisplayBulkShipment> _onDeliveryShipments = [];
  final List<DisplayBulkShipment> _returnedShipments = [];
  final List<DisplayBulkShipment> _cancelledShipments = [];
  List<CourierReview> _courierReviews = [];
  List<ShipmentStatus> _shipmentStatus = [];
  NetworkState? _myReviewsState;
  NetworkState? _shipmentByIdState;
  NetworkState? _bulkShipmentByIdState;
  bool _myReviewsEmpty = false;
  int _currentShipmentIndex = 0;
  int _currentSelectedShipmentIndex = 0;
  final Widget _currentShipmentWidget = const NewShipmentHost();
  List<CourierReview> _myReviews = [];
  double ratingTotal = 0;

  NetworkState? get bulkShipmentByIdState => _bulkShipmentByIdState;

  int get currentSelectedShipmentIndex => _currentSelectedShipmentIndex;

  List<ShipmentStatus> get shipmentStatus => _shipmentStatus;

  List<CourierReview> get courierReviews => _courierReviews;
  bool _fromNewShipment = false;
  bool _acceptNewShipment = false;
  bool _fromChildrenReview = false;

  NetworkState? _offerBasedState;
  NetworkState? _unCompletedState;
  NetworkState? _courierReviewState;
  NetworkState? _merchantAcceptedShipmentState;
  NetworkState? _courierOnHisWayToGetShipmentState;
  NetworkState? _availableState;
  NetworkState? _returnedState;
  NetworkState? _cancelledState;
  NetworkState? _onDeliveryState;
  NetworkState? _deliveredState;
  NetworkState? _shipmentStatusState;

  bool _offerBasedNextPageLoading = false;
  final bool _availableNextPageLoading = false;
  final bool _unCompletedNextPageLoading = false;
  final bool _merchantAcceptedNextPageLoading = false;
  final bool _courierOnHisWayToGetShipmentNextPageLoading = false;
  final bool _deliveredNextPageLoading = false;
  final bool _onDeliveryNextPageLoading = false;
  final bool _returnedNextPageLoading = false;
  final bool _cancelledNextPageLoading = false;

  bool _offerBasedShipmentIsEmpty = false;
  final bool _unCompletedShipmentIsEmpty = false;
  bool _courierReviewsEmpty = false;
  final bool _availableShipmentIsEmpty = false;
  final bool _merchantAcceptedShipmentIsEmpty = false;
  final bool _courierOnHisWayToGetShipmentShipmentIsEmpty = false;
  final bool _deliveredShipmentIsEmpty = false;
  final bool _onDeliveryShipmentIsEmpty = false;
  final bool _returnedShipmentIsEmpty = false;
  final bool _cancelledShipmentIsEmpty = false;

  int _offerBasedCurrentPage = 1;
  final int _availableCurrentPage = 1;
  final int _courierOnHisWayToGetShipmentCurrentPage = 1;
  final int _unCompletedCurrentPage = 1;
  final int _merchantAcceptedCurrentPage = 1;
  final int _onDeliveryCurrentPage = 1;
  final int _deliveredCurrentPage = 1;
  final int _returnedCurrentPage = 1;
  final int _cancelledCurrentPage = 1;

  DisplayChildDetails? _shipmentById;
  BulkShipment? _bulkShipmentById;

  int? _offerBasedLastPage;
  int? _availableLastPage;
  int? _merchantAcceptedLastPage;
  int? _unCompletedLastPage;
  int? _onDeliveryLastPage;
  int? _deliveredLastPage;
  int? _returnedLastPage;
  int? _cancelledLastPage;
  int? _courierOnHisWayToGetShipmentLastPage;

  int _offerBasedTotalItems = 0;
  final int _availableTotalItems = 0;
  final int _merchantAcceptedTotalItems = 0;
  final int _courierOnHisWatToGetShipmentTotalItems = 0;
  final int _deliveredTotalItems = 0;
  final int _unCompletedTotalItems = 0;
  final int _onDeliveryTotalItems = 0;
  final int _returnedTotalItems = 0;
  final int _cancelledTotalItems = 0;
  final int _availableShipmentIndex = 1;

  int get availableShipmentIndex => _availableShipmentIndex;
  bool _shipmentFromHome = false;

  // void getRatingAverage(){
  //   for (var i = 0; i < courierReviews.length; i++) {
  //     ratingTotal += courierReviews[i].rating;
  //   }
  // }

  NetworkState? get shipmentStatusState => _shipmentStatusState;

  void setFromNewShipment(bool v) {
    _fromNewShipment = v;
  }

  int get currentShipmentIndex => _currentShipmentIndex;

  void changePortion(int i, bool init) {
    _currentShipmentIndex = i;
    _currentSelectedShipmentIndex = i;
    // getCurrentShipmentWidget(i);
    if (!init) {
      notifyListeners();
    }
  }

  Widget get currentShipmentWidget => _currentShipmentWidget;

  // void getCurrentShipmentWidget(int i) {
  //   switch (_currentShipmentIndex) {
  //     case 0:
  //       _currentShipmentWidget = NewShipmentHost(key: ValueKey('$i'));
  //       break;
  //     case 1:
  //       _currentShipmentWidget = UnCompletedShipmentHost(key: ValueKey('$i'));
  //       break;
  //     case 2:
  //       _currentShipmentWidget =
  //           MerchantAcceptedShipmentHost(key: ValueKey('$i'));
  //       break;
  //     case 3:
  //       _currentShipmentWidget =
  //           CourierOnHisWayToGetShipmentHost(key: ValueKey('$i'));
  //       break;
  //     case 4:
  //       _currentShipmentWidget = OnDeliveryShipmentHost(key: ValueKey('$i'));
  //       break;
  //     case 5:
  //       _currentShipmentWidget = DeliveredShipmentHost(key: ValueKey('$i'));
  //       break;
  //     case 6:
  //       _currentShipmentWidget = ReturnedShipmentHost(key: ValueKey('$i'));
  //       break;
  //     case 7:
  //       _currentShipmentWidget = CancelledShipmentHost(key: ValueKey('$i'));
  //       break;
  //   }
  // }

  void setFromChildrenReview(bool v) {
    _fromChildrenReview = v;
  }

  bool get fromNewShipment => _fromNewShipment;

  bool get fromChildrenReview => _fromChildrenReview;

  NetworkState? get shipmentByIdState => _shipmentByIdState;

  void setShipmentFromHome(bool v) {
    _shipmentFromHome = v;
  }

  bool get shipmentFromHome => _shipmentFromHome;

  NetworkState? get offerBasedState => _offerBasedState;

  void setAcceptNewShipment(bool v) {
    _acceptNewShipment = v;
  }

  bool get acceptNewShipment => _acceptNewShipment;

  // Future<void> getAvailableShipment({
  //   required bool isPagination,
  //   required bool isRefreshing,
  //   required bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _availableCurrentPage = 1;
  //       _availableState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipments?status=available&is_offer_based=0&page=$_availableCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _availableTotalItems = main.total ?? 0;
  //       _availableLastPage = main.lastPage;
  //       if (_availableCurrentPage == 1) {
  //         _availableShipments = main.data ?? [];
  //       } else {
  //         _availableShipments.addAll(main.data ?? []);
  //       }
  //       _availableShipmentIsEmpty = _availableShipments.isEmpty;
  //       _availableState = NetworkState.SUCCESS;
  //     } else {
  //       _availableState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  NetworkState? get courierReviewState => _courierReviewState;

  Future<void> listOfCourierReviews({required int courierId}) async {
    _courierReviewState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'list-courier-reviews',
        true,
        body: {
          'courier_id': courierId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _courierReviews = (json.decode(r.body) as List)
            .map((e) => CourierReview.fromJson(e))
            .toList();
        // getRatingAverage();
        _courierReviewsEmpty = _courierReviews.isEmpty;
        _courierReviewState = NetworkState.SUCCESS;
      } else {
        _courierReviewState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> listOfMyReviews() async {
    _myReviewsState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'my-reviews',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _myReviews = (json.decode(r.body) as List)
            .map((e) => CourierReview.fromJson(e))
            .toList();
        _myReviewsEmpty = _myReviews.isEmpty;
        _myReviewsState = NetworkState.SUCCESS;
      } else {
        _myReviewsState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  // Future<void> getUnCompletedShipment({
  //   required bool isPagination,
  //   required bool isRefreshing,
  //   required bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _unCompletedCurrentPage = 1;
  //       _unCompletedState = NetworkState.WAITING;
  //       log('{$unCompletedState}');
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipments?status=new&page=$_unCompletedCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _unCompletedTotalItems = main.total;
  //       _unCompletedLastPage = main.lastPage;
  //       if (_onDeliveryCurrentPage == 1) {
  //         _unCompletedShipments = main.data;
  //       } else {
  //         _unCompletedShipments.addAll(main.data);
  //       }
  //       _unCompletedShipmentIsEmpty = _unCompletedShipments.isEmpty;
  //       _unCompletedState = NetworkState.SUCCESS;
  //       log('{$unCompletedState}');
  //     } else {
  //       _unCompletedState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  // Future<void> getMerchantAcceptedShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _merchantAcceptedCurrentPage = 1;
  //       _merchantAcceptedShipmentState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipments?status=merchant-accepted-shipping-offer,courier-applied-to-shipment&page=$_merchantAcceptedCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _merchantAcceptedTotalItems = main.total;
  //       _merchantAcceptedLastPage = main.lastPage;
  //       if (_merchantAcceptedCurrentPage == 1) {
  //         _merchantAcceptedShipments = main.data;
  //       } else {
  //         _merchantAcceptedShipments.addAll(main.data);
  //       }
  //       _merchantAcceptedShipmentIsEmpty = _merchantAcceptedShipments.isEmpty;
  //       _merchantAcceptedShipmentState = NetworkState.SUCCESS;
  //     } else {
  //       _merchantAcceptedShipmentState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  // Future<void> getOnDeliveryShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _onDeliveryCurrentPage = 1;
  //       _onDeliveryState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipments?status=on-delivery&page=$_onDeliveryCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _onDeliveryTotalItems = main.total;
  //       _onDeliveryLastPage = main.lastPage;
  //       if (_onDeliveryCurrentPage == 1) {
  //         _onDeliveryShipments = main.data;
  //       } else {
  //         _onDeliveryShipments.addAll(main.data);
  //       }
  //       _onDeliveryShipmentIsEmpty = _onDeliveryShipments.isEmpty;
  //       _onDeliveryState = NetworkState.SUCCESS;
  //     } else {
  //       _onDeliveryState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  // Future<void> getDeliveryShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _deliveredCurrentPage = 1;
  //       _deliveredState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipments?status=delivered,bulk-shipment-closed&page=$_deliveredCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _deliveredTotalItems = main.total;
  //       _deliveredLastPage = main.lastPage;
  //       if (_deliveredLastPage == 1) {
  //         _deliveredShipments = main.data;
  //       } else {
  //         _deliveredShipments.addAll(main.data);
  //       }
  //       _deliveredShipmentIsEmpty = _deliveredShipments.isEmpty;
  //       _deliveredState = NetworkState.SUCCESS;
  //     } else {
  //       _deliveredState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  // Future<void> getReturnedShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _returnedCurrentPage = 1;
  //       _returnedState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipments?status=returned,bulk-shipment-closed&page=$_returnedCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _returnedTotalItems = main.total;
  //       _returnedLastPage = main.lastPage;
  //       if (_returnedCurrentPage == 1) {
  //         _returnedShipments = main.data;
  //       } else {
  //         _returnedShipments.addAll(main.data);
  //       }
  //       _returnedShipmentIsEmpty = _returnedShipments.isEmpty;
  //       _returnedState = NetworkState.SUCCESS;
  //     } else {
  //       _returnedState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  // Future<void> getCancelledShipment({
  //   bool isPagination,
  //   bool isRefreshing,
  //   bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _cancelledCurrentPage = 1;
  //       _cancelledState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipments?status=cancelled,bulk-shipment-cancelled&page=$_cancelledCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _cancelledTotalItems = main.total;
  //       _cancelledLastPage = main.lastPage;
  //       if (_cancelledCurrentPage == 1) {
  //         _cancelledShipments = main.data;
  //       } else {
  //         _cancelledShipments.addAll(main.data);
  //       }
  //       _cancelledShipmentIsEmpty = _cancelledShipments.isEmpty;
  //       _cancelledState = NetworkState.SUCCESS;
  //     } else {
  //       _cancelledState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  Future<void> updateOneShipment(
      {required int shipmentId, required String newShippingCost}) async {
    try {
      showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (context) => const LoadingDialog());
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId?_method=PUT',
        true,
        body: {
          'expected_shipping_cost': newShippingCost,
        },
      );
      log('update shipping cost body -> ${r.body}');
      log('update shipping cost status code -> ${r.statusCode}');
      log('update shipping cost url -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        await getOfferBasedShipment(
            isPagination: false, isFirstTime: false, isRefreshing: false);
        await getShipmentById(
          id: shipmentId,
          isFirstTime: false,
        );
        Navigator.pop(navigator.currentContext!);
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: 'تم تعديل سعر الشحن بنجاح',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
      } else {
        Navigator.pop(navigator.currentContext!);
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getOfferBasedShipment({
    required bool isPagination,
    required bool isRefreshing,
    required bool isFirstTime,
  }) async {
    try {
      if (!isPagination && !isRefreshing) {
        _offerBasedCurrentPage = 1;
        _offerBasedState = NetworkState.WAITING;
        if (!isFirstTime) {
          notifyListeners();
        }
      }
      Response r = await HttpHelper.instance.httpGet(
        'shipments?status=available&is_offer_based=1&page=$_offerBasedCurrentPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
        _offerBasedTotalItems = main.total ?? 0;
        _offerBasedLastPage = main.lastPage;
        if (_offerBasedCurrentPage == 1) {
          _offerBasedShipments = main.data ?? [];
        } else {
          _offerBasedShipments.addAll(main.data ?? []);
        }
        _offerBasedShipmentIsEmpty = _offerBasedShipments.isEmpty;
        _offerBasedState = NetworkState.SUCCESS;
      } else {
        _offerBasedState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  // Future<void> getCourierOnHisWayToGetShipment({
  //   required bool isPagination,
  //   required bool isRefreshing,
  //   required bool isFirstTime,
  // }) async {
  //   try {
  //     if (!isPagination && !isRefreshing) {
  //       _courierOnHisWayToGetShipmentCurrentPage = 1;
  //       _courierOnHisWayToGetShipmentState = NetworkState.WAITING;
  //       if (!isFirstTime) {
  //         notifyListeners();
  //       }
  //     }
  //     Response r = await HttpHelper.instance.httpGet(
  //       'shipments?status=on-the-way-to-get-shipment-from-merchant&page=$_courierOnHisWayToGetShipmentCurrentPage',
  //       true,
  //     );
  //     if (r.statusCode >= 200 && r.statusCode < 300) {
  //       ShipmentResponse main = ShipmentResponse.fromJson(jsonDecode(r.body));
  //       _courierOnHisWatToGetShipmentTotalItems = main.total;
  //       _courierOnHisWayToGetShipmentLastPage = main.lastPage;
  //       if (_courierOnHisWayToGetShipmentCurrentPage == 1) {
  //         _courierOnHisWayToGetShipmentShipments = main.data;
  //       } else {
  //         _courierOnHisWayToGetShipmentShipments.addAll(main.data);
  //       }
  //       _courierOnHisWayToGetShipmentShipmentIsEmpty =
  //           _courierOnHisWayToGetShipmentShipments.isEmpty;
  //       _courierOnHisWayToGetShipmentState = NetworkState.SUCCESS;
  //     } else {
  //       _courierOnHisWayToGetShipmentState = NetworkState.ERROR;
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  Future<void> getShipmentById({
    required int id,
    required bool isFirstTime,
  }) async {
    try {
      _shipmentByIdState = NetworkState.WAITING;
      if (!isFirstTime) {
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'shipments/$id',
        true,
      );
      log('body -> ${json.decode(r.body)}');
      log('status code -> ${r.statusCode}');
      log('url -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _shipmentById = DisplayChildDetails.fromJson(jsonDecode(r.body));
        _shipmentByIdState = NetworkState.SUCCESS;
      } else {
        _shipmentByIdState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  BulkShipment? get bulkShipmentById => _bulkShipmentById;

  Future<void> getBulkShipmentById(
    int id,
  ) async {
    try {
      _bulkShipmentByIdState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpGet(
        'shipments/$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _bulkShipmentById = BulkShipment.fromJson(jsonDecode(r.body));
        _bulkShipmentByIdState = NetworkState.SUCCESS;
      } else {
        _bulkShipmentByIdState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getShipmentStatus() async {
    _shipmentStatusState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpGet(
        'shipments-stats',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _shipmentStatus = (json.decode(r.body) as List)
            .map((e) => ShipmentStatus.fromJson(e))
            .toList();
        _shipmentStatusState = NetworkState.SUCCESS;
      } else {
        _shipmentStatusState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  DisplayChildDetails? get shipmentById => _shipmentById;

  // Future<void> clearAvailableShipmentList() async {
  //   _availableShipments.clear();
  //   notifyListeners();
  //   _availableCurrentPage = 1;
  //   await getAvailableShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearUnCompletedShipmentList() async {
  //   _unCompletedShipments.clear();
  //   notifyListeners();
  //   _unCompletedCurrentPage = 1;
  //   await getUnCompletedShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  Future<void> clearOfferBasedShipmentList() async {
    _offerBasedShipments.clear();
    notifyListeners();
    _offerBasedCurrentPage = 1;
    await getOfferBasedShipment(
        isPagination: false, isRefreshing: true, isFirstTime: false);
    notifyListeners();
  }

  // Future<void> clearMerchantAcceptedShipmentList() async {
  //   _merchantAcceptedShipments.clear();
  //   notifyListeners();
  //   _merchantAcceptedCurrentPage = 1;
  //   await getMerchantAcceptedShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearDeliveredShipmentList() async {
  //   _deliveredShipments.clear();
  //   notifyListeners();
  //   _deliveredCurrentPage = 1;
  //   await getDeliveryShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearOnDeliveryShipmentList() async {
  //   _onDeliveryShipments.clear();
  //   notifyListeners();
  //   _onDeliveryCurrentPage = 1;
  //   await getOnDeliveryShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearReturnedShipmentList() async {
  //   _returnedShipments.clear();
  //   notifyListeners();
  //   _returnedCurrentPage = 1;
  //   await getReturnedShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  // Future<void> clearCancelledShipmentList() async {
  //   _cancelledShipments.clear();
  //   notifyListeners();
  //   _cancelledCurrentPage = 1;
  //   await getCancelledShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  Future<void> offerBasedNextPage() async {
    if (_offerBasedCurrentPage < _offerBasedLastPage!) {
      _offerBasedNextPageLoading = true;
      notifyListeners();
      _offerBasedCurrentPage++;
      await getOfferBasedShipment(
          isPagination: true, isRefreshing: false, isFirstTime: false);
      _offerBasedNextPageLoading = false;
      notifyListeners();
    }
  }

  // Future<void> unCompletedNextPage() async {
  //   if (_unCompletedCurrentPage < _unCompletedLastPage) {
  //     _unCompletedNextPageLoading = true;
  //     notifyListeners();
  //     _unCompletedCurrentPage++;
  //     await getUnCompletedShipment(
  //         isPagination: true, isRefreshing: false, isFirstTime: false);
  //     _unCompletedNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> merchantAcceptedNextPage() async {
  //   if (_merchantAcceptedCurrentPage < _merchantAcceptedLastPage) {
  //     _merchantAcceptedNextPageLoading = true;
  //     notifyListeners();
  //     _merchantAcceptedCurrentPage++;
  //     await getMerchantAcceptedShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _merchantAcceptedNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> availableNextPage() async {
  //   if (_availableCurrentPage < _availableLastPage) {
  //     _availableNextPageLoading = true;
  //     notifyListeners();
  //     _availableCurrentPage++;
  //     await getAvailableShipment(
  //         isPagination: true, isRefreshing: false, isFirstTime: false);
  //     _availableNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> onDeliveryNextPage() async {
  //   if (_onDeliveryCurrentPage < _onDeliveryLastPage) {
  //     _onDeliveryNextPageLoading = true;
  //     notifyListeners();
  //     _onDeliveryCurrentPage++;
  //     await getOnDeliveryShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _onDeliveryNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> deliveredNextPage() async {
  //   if (_deliveredCurrentPage < _deliveredLastPage) {
  //     _deliveredNextPageLoading = true;
  //     notifyListeners();
  //     _deliveredCurrentPage++;
  //     await getDeliveryShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _deliveredNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> returnedNextPage() async {
  //   if (_returnedCurrentPage < _returnedLastPage) {
  //     _returnedNextPageLoading = true;
  //     notifyListeners();
  //     _returnedCurrentPage++;
  //     await getReturnedShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _returnedNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> cancelledNextPage() async {
  //   if (_cancelledCurrentPage < _cancelledLastPage) {
  //     _cancelledNextPageLoading = true;
  //     notifyListeners();
  //     _cancelledCurrentPage++;
  //     await getCancelledShipment(
  //         isPagination: true, isFirstTime: false, isRefreshing: false);
  //     _cancelledNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> courierOnHisWayToGetShipmentNextPage() async {
  //   if (_courierOnHisWayToGetShipmentCurrentPage <
  //       _courierOnHisWayToGetShipmentLastPage) {
  //     _courierOnHisWayToGetShipmentNextPageLoading = true;
  //     notifyListeners();
  //     _courierOnHisWayToGetShipmentCurrentPage++;
  //     await getCourierOnHisWayToGetShipment(
  //         isPagination: true, isRefreshing: false, isFirstTime: false);
  //     _courierOnHisWayToGetShipmentNextPageLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> clearCourierOnHisWayToGetShipmentShipmentList() async {
  //   _courierOnHisWayToGetShipmentShipments.clear();
  //   notifyListeners();
  //   _courierOnHisWayToGetShipmentCurrentPage = 1;
  //   await getCourierOnHisWayToGetShipment(
  //       isPagination: false, isRefreshing: true, isFirstTime: false);
  //   notifyListeners();
  // }

  int get availableTotalItems => _availableTotalItems;

  int get offerBasedTotalItems => _offerBasedTotalItems;

  int? get availableLastPage => _availableLastPage;

  int? get offerBasedLastPage => _offerBasedLastPage;

  int get availableCurrentPage => _availableCurrentPage;

  int get offerBasedCurrentPage => _offerBasedCurrentPage;

  bool get availableShipmentIsEmpty => _availableShipmentIsEmpty;

  bool get offerBasedShipmentIsEmpty => _offerBasedShipmentIsEmpty;

  bool get availableNextPageLoading => _availableNextPageLoading;

  bool get offerBasedNextPageLoading => _offerBasedNextPageLoading;

  List<DisplayBulkShipment> get courierOnHisWayToGetShipmentShipments =>
      _courierOnHisWayToGetShipmentShipments;

  List<DisplayBulkShipment> get availableShipments => _availableShipments;

  List<DisplayBulkShipment> get offerBasedShipments => _offerBasedShipments;

  NetworkState? get availableState => _availableState;

  int get cancelledTotalItems => _cancelledTotalItems;

  int get returnedTotalItems => _returnedTotalItems;

  int get onDeliveryTotalItems => _onDeliveryTotalItems;

  int get deliveredTotalItems => _deliveredTotalItems;

  int get merchantAcceptedTotalItems => _merchantAcceptedTotalItems;

  int? get cancelledLastPage => _cancelledLastPage;

  int? get returnedLastPage => _returnedLastPage;

  int? get deliveredLastPage => _deliveredLastPage;

  int? get onDeliveryLastPage => _onDeliveryLastPage;

  int? get merchantAcceptedLastPage => _merchantAcceptedLastPage;

  int get cancelledCurrentPage => _cancelledCurrentPage;

  int get returnedCurrentPage => _returnedCurrentPage;

  int get deliveredCurrentPage => _deliveredCurrentPage;

  int get onDeliveryCurrentPage => _onDeliveryCurrentPage;

  int get merchantAcceptedCurrentPage => _merchantAcceptedCurrentPage;

  bool get cancelledShipmentIsEmpty => _cancelledShipmentIsEmpty;

  bool get returnedShipmentIsEmpty => _returnedShipmentIsEmpty;

  bool get onDeliveryShipmentIsEmpty => _onDeliveryShipmentIsEmpty;

  bool get deliveredShipmentIsEmpty => _deliveredShipmentIsEmpty;

  bool get merchantAcceptedShipmentIsEmpty => _merchantAcceptedShipmentIsEmpty;

  bool get cancelledNextPageLoading => _cancelledNextPageLoading;

  bool get returnedNextPageLoading => _returnedNextPageLoading;

  bool get onDeliveryNextPageLoading => _onDeliveryNextPageLoading;

  bool get deliveredNextPageLoading => _deliveredNextPageLoading;

  bool get merchantAcceptedNextPageLoading => _merchantAcceptedNextPageLoading;

  NetworkState? get deliveredState => _deliveredState;

  NetworkState? get onDeliveryState => _onDeliveryState;

  NetworkState? get cancelledState => _cancelledState;

  NetworkState? get returnedState => _returnedState;

  NetworkState? get merchantAcceptedShipmentState =>
      _merchantAcceptedShipmentState;

  List<DisplayBulkShipment> get cancelledShipments => _cancelledShipments;

  List<DisplayBulkShipment> get returnedShipments => _returnedShipments;

  List<DisplayBulkShipment> get onDeliveryShipments => _onDeliveryShipments;

  List<DisplayBulkShipment> get deliveredShipments => _deliveredShipments;

  List<DisplayBulkShipment> get merchantAcceptedShipments =>
      _merchantAcceptedShipments;

  int get unCompletedTotalItems => _unCompletedTotalItems;

  int? get unCompletedLastPage => _unCompletedLastPage;

  int get unCompletedCurrentPage => _unCompletedCurrentPage;

  bool get unCompletedShipmentIsEmpty => _unCompletedShipmentIsEmpty;

  bool get unCompletedNextPageLoading => _unCompletedNextPageLoading;

  NetworkState? get unCompletedState => _unCompletedState;

  List<DisplayBulkShipment> get unCompletedShipments => _unCompletedShipments;

  NetworkState? get courierOnHisWayToGetShipmentState =>
      _courierOnHisWayToGetShipmentState;

  bool get courierOnHisWayToGetShipmentNextPageLoading =>
      _courierOnHisWayToGetShipmentNextPageLoading;

  bool get courierOnHisWayToGetShipmentShipmentIsEmpty =>
      _courierOnHisWayToGetShipmentShipmentIsEmpty;

  int get courierOnHisWayToGetShipmentCurrentPage =>
      _courierOnHisWayToGetShipmentCurrentPage;

  int? get courierOnHisWayToGetShipmentLastPage =>
      _courierOnHisWayToGetShipmentLastPage;

  int get courierOnHisWatToGetShipmentTotalItems =>
      _courierOnHisWatToGetShipmentTotalItems;

  bool get courierReviewsEmpty => _courierReviewsEmpty;

  List<CourierReview> get myReviews => _myReviews;

  bool get myReviewsEmpty => _myReviewsEmpty;

  NetworkState? get myReviewsState => _myReviewsState;
}
