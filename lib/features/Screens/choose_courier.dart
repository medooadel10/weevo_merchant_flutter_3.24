import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Dialogs/loading.dart';
import '../../core/Models/accept_merchant_offer.dart';
import '../../core/Models/shipment_notification.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/choose_captain_provider.dart';
import '../../core/Providers/display_shipment_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../../core_new/networking/api_constants.dart';
import '../Widgets/courier_item.dart';
import '../shipment_details/ui/shipment_details_screen.dart';
import '../shipments/ui/screens/shipments_screen.dart';
import 'child_shipment_details.dart';
import 'home.dart';

class ChooseCourier extends StatefulWidget {
  static const String id = 'Choose_Courier';
  final ShipmentNotification shipmentNotification;

  const ChooseCourier({
    super.key,
    required this.shipmentNotification,
  });

  @override
  State<ChooseCourier> createState() => _ChooseCourierState();
}

class _ChooseCourierState extends State<ChooseCourier> {
  late ChooseCaptainProvider _chooseCaptainProvider;
  late ScrollController _scrollController;
  Timer? _t;
  late AuthProvider _authProvider;
  final Preferences _preferences = Preferences.instance;
  bool _dialogOpened = false;

  @override
  void dispose() {
    _t?.cancel();

    _scrollController.dispose();
    _preferences.setShipmentOfferCount(
        widget.shipmentNotification.shipmentId.toString(),
        _chooseCaptainProvider.listOfOffers.length);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _chooseCaptainProvider = Provider.of(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _scrollController = ScrollController();
    _chooseCaptainProvider.courierOffers(
      shipmentId: widget.shipmentNotification.shipmentId!,
      isFirstTime: true,
    );
    check(
        auth: _authProvider,
        state: _chooseCaptainProvider.state!,
        ctx: context);
    _t = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _authProvider
          .getShipmentStatus(widget.shipmentNotification.shipmentId!);
      if (_authProvider.courierAppliedToShipment) {
        if (!_dialogOpened) {
          _dialogOpened = true;
          showDialog(
              context: navigator.currentContext!,
              builder: (cx) => ActionDialog(
                    content: 'قام احد المناديب بقبول شحنتك و دفع مقدم الشحن',
                    approveAction: 'الذهاب للشحنة',
                    onApproveClick: () {
                      Navigator.pop(cx);
                      _t?.cancel();
                      _dialogOpened = false;
                      if (widget.shipmentNotification.childrenShipment == 0) {
                        MagicRouter.navigateAndPop(ShipmentDetailsScreen(
                          id: widget.shipmentNotification.shipmentId!,
                        ));
                      } else {
                        Navigator.pushReplacementNamed(
                            context, ChildShipmentDetails.id,
                            arguments: widget.shipmentNotification.shipmentId);
                      }
                    },
                  ));
        }
      } else {
        _chooseCaptainProvider.courierOffers(
          shipmentId: widget.shipmentNotification.shipmentId!,
          isFirstTime: false,
        );
        if (_chooseCaptainProvider.listOfOffers.isNotEmpty) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(seconds: 5),
              curve: Curves.fastOutSlowIn);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DisplayShipmentProvider displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context, listen: false);
    return Consumer<ChooseCaptainProvider>(
      builder: (c, data, ch) => WillPopScope(
        onWillPop: () async {
          if (_authProvider.fromOutsideNotification) {
            _authProvider.setFromOutsideNotification(false);
            Navigator.pushReplacementNamed(context, Home.id);
          } else {
            displayShipmentProvider.setShipmentFromHome(true);
            MagicRouter.navigateAndPop(const ShipmentsScreen());
          }
          return false;
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (_authProvider.fromOutsideNotification) {
                      _authProvider.setFromOutsideNotification(false);
                      Navigator.pushReplacementNamed(context, Home.id);
                    } else {
                      displayShipmentProvider.setShipmentFromHome(true);
                      MagicRouter.navigateAndPop(const ShipmentsScreen());
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                  ),
                ),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'شحنة ${widget.shipmentNotification.shipmentId}',
                          style: const TextStyle(
                            color: weevoPrimaryOrangeColor,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/new_icon.png',
                          fit: BoxFit.contain,
                          height: 30.0.h,
                          width: 30.0.w,
                          color: weevoPrimaryOrangeColor,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.shipmentNotification.shippingCost!,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w600,
                                color: weevoPrimaryOrangeColor,
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              'جنية',
                              style: TextStyle(
                                fontSize: 12.0.sp,
                                color: weevoPrimaryOrangeColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: data.state == NetworkState.WAITING ||
                      data.listOfOffers.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'برجاء الانتظار',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0,
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              SpinKitThreeBounce(
                                color: weevoPrimaryOrangeColor,
                                size: 20.0,
                              ),
                            ],
                          ),
                          Text(
                            'جاري البحث عن مناديب',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : data.state == NetworkState.SUCCESS ||
                          data.state == NetworkState.LIVEDATA
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: data.listOfOffers.length,
                                itemBuilder: (BuildContext ctx, int i) =>
                                    CourierItem(
                                  key: ValueKey('${data.listOfOffers[i].id}'),
                                  courierOffer: data.listOfOffers[i],
                                  onAcceptOffer: () async {
                                    showDialog(
                                        context: navigator.currentContext!,
                                        builder: (context) =>
                                            const LoadingDialog());
                                    DocumentSnapshot userToken =
                                        await FirebaseFirestore.instance
                                            .collection('courier_users')
                                            .doc(data.listOfOffers[i].driverId
                                                .toString())
                                            .get();
                                    String token = userToken['fcmToken'];
                                    if (widget.shipmentNotification
                                            .childrenShipment ==
                                        0) {
                                      int shipmentId = data.listOfOffers[i].id!;
                                      await data.sendAcceptOffer(
                                          offerId: shipmentId);
                                      if (_chooseCaptainProvider.state ==
                                          NetworkState.SUCCESS) {
                                        FirebaseFirestore.instance
                                            .collection('courier_notifications')
                                            .doc(data.listOfOffers[i].driverId
                                                .toString())
                                            .collection(data
                                                .listOfOffers[i].driverId
                                                .toString())
                                            .add({
                                          'read': false,
                                          'date_time':
                                              DateTime.now().toIso8601String(),
                                          'type': '',
                                          'title': 'تم قبول العرض الخاص بك',
                                          'body':
                                              'التاجر ${_authProvider.name}تم قبول العرض الخاص بك من قِبل ',
                                          'user_icon': _authProvider.photo !=
                                                      null &&
                                                  _authProvider
                                                      .photo!.isNotEmpty
                                              ? _authProvider.photo!.contains(
                                                      ApiConstants.baseUrl)
                                                  ? _authProvider.photo
                                                  : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                              : '',
                                          'screen_to':
                                              'shipment_details_screen',
                                          'data': AcceptMerchantOffer(
                                                  shipmentId: widget
                                                      .shipmentNotification
                                                      .shipmentId!,
                                                  childrenShipment: widget
                                                      .shipmentNotification
                                                      .childrenShipment!)
                                              .toMap(),
                                        });
                                        await _authProvider.sendNotification(
                                            title: 'تم قبول العرض الخاص بك',
                                            body:
                                                'التاجر ${_authProvider.name}تم قبول العرض الخاص بك من قِبل ',
                                            toToken: token,
                                            image: _authProvider
                                                    .photo!.isNotEmpty
                                                ? _authProvider.photo!.contains(
                                                        ApiConstants.baseUrl)
                                                    ? _authProvider.photo
                                                    : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                                : '',
                                            screenTo: 'shipment_details_screen',
                                            type: '',
                                            data: AcceptMerchantOffer(
                                                    shipmentId: widget
                                                        .shipmentNotification
                                                        .shipmentId!,
                                                    childrenShipment: widget
                                                        .shipmentNotification
                                                        .childrenShipment!)
                                                .toMap());
                                        displayShipmentProvider
                                            .setAcceptNewShipment(true);
                                        MagicRouter.pop();
                                        MagicRouter.navigateAndPop(
                                            ShipmentDetailsScreen(
                                          id: data.listOfOffers[i].shipmentId!,
                                        ));
                                      } else if (_chooseCaptainProvider.state ==
                                          NetworkState.ERROR) {
                                        MagicRouter.pop();
                                        showDialog(
                                            context: navigator.currentContext!,
                                            builder: (ctx) => ActionDialog(
                                                  content:
                                                      'حدث خطأ برجاء المحاولة مرة أخري',
                                                  approveAction: 'حسناً',
                                                  onApproveClick: () {
                                                    Navigator.pop(ctx);
                                                  },
                                                ));
                                      }
                                    } else {
                                      int shipmentId = data.listOfOffers[i].id!;
                                      await data.sendAcceptOffer(
                                          offerId: shipmentId);
                                      if (_chooseCaptainProvider.state ==
                                          NetworkState.SUCCESS) {
                                        FirebaseFirestore.instance
                                            .collection('courier_notifications')
                                            .doc(data.listOfOffers[i].driverId
                                                .toString())
                                            .collection(data
                                                .listOfOffers[i].driverId
                                                .toString())
                                            .add({
                                          'read': false,
                                          'date_time':
                                              DateTime.now().toIso8601String(),
                                          'type': '',
                                          'title': 'تم قبول العرض الخاص بك',
                                          'body':
                                              'التاجر ${_authProvider.name}تم قبول العرض الخاص بك من قِبل ',
                                          'user_icon': _authProvider
                                                  .photo!.isNotEmpty
                                              ? _authProvider.photo!.contains(
                                                      ApiConstants.baseUrl)
                                                  ? _authProvider.photo
                                                  : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                              : '',
                                          'screen_to':
                                              'shipment_details_screen',
                                          'data': AcceptMerchantOffer(
                                                  shipmentId: widget
                                                      .shipmentNotification
                                                      .shipmentId!,
                                                  childrenShipment: widget
                                                      .shipmentNotification
                                                      .childrenShipment!)
                                              .toMap(),
                                        });
                                        await _authProvider.sendNotification(
                                            title: 'تم قبول العرض الخاص بك',
                                            body:
                                                'التاجر ${_authProvider.name}تم قبول العرض الخاص بك من قِبل ',
                                            toToken: token,
                                            image: _authProvider
                                                    .photo!.isNotEmpty
                                                ? _authProvider.photo!.contains(
                                                        ApiConstants.baseUrl)
                                                    ? _authProvider.photo
                                                    : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                                : '',
                                            screenTo: 'shipment_details_screen',
                                            type: '',
                                            data: AcceptMerchantOffer(
                                                    shipmentId: widget
                                                        .shipmentNotification
                                                        .shipmentId!,
                                                    childrenShipment: widget
                                                        .shipmentNotification
                                                        .childrenShipment!)
                                                .toMap());
                                        displayShipmentProvider
                                            .setAcceptNewShipment(true);
                                        displayShipmentProvider
                                            .setFromChildrenReview(true);
                                        MagicRouter.pop();
                                        Navigator.pushReplacementNamed(
                                            navigator.currentContext!,
                                            ChildShipmentDetails.id,
                                            arguments: widget
                                                .shipmentNotification
                                                .shipmentId);
                                      } else if (_chooseCaptainProvider.state ==
                                          NetworkState.ERROR) {
                                        MagicRouter.pop();
                                        showDialog(
                                            context: navigator.currentContext!,
                                            builder: (ctx) => ActionDialog(
                                                  content:
                                                      'حدث خطأ برجاء المحاولة مرة أخري',
                                                  approveAction: 'حسناً',
                                                  onApproveClick: () {
                                                    Navigator.pop(ctx);
                                                  },
                                                ));
                                      }
                                    }
                                  },
                                  onBetterOffer: () async {
                                    DocumentSnapshot userToken =
                                        await FirebaseFirestore.instance
                                            .collection('courier_users')
                                            .doc(data.listOfOffers[i].driverId
                                                .toString())
                                            .get();
                                    String token = userToken['fcmToken'];
                                    showDialog(
                                        context: navigator.currentContext!,
                                        builder: (context) =>
                                            const LoadingDialog());
                                    FirebaseFirestore.instance
                                        .collection('courier_notifications')
                                        .doc(data.listOfOffers[i].driverId
                                            .toString())
                                        .collection(data
                                            .listOfOffers[i].driverId
                                            .toString())
                                        .add({
                                      'read': false,
                                      'date_time':
                                          DateTime.now().toIso8601String(),
                                      'title': 'عرض أفضل',
                                      'body':
                                          'التاجر ${_authProvider.name}يريد منك تقديم عرض أفضل ',
                                      'user_icon': _authProvider
                                              .photo!.isNotEmpty
                                          ? _authProvider.photo!.contains(
                                                  ApiConstants.baseUrl)
                                              ? _authProvider.photo
                                              : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                          : '',
                                      'screen_to': '',
                                      'type': '',
                                      'data': ShipmentNotification(
                                        merchantName: widget
                                            .shipmentNotification.merchantName,
                                        merchantImage: widget
                                            .shipmentNotification.merchantImage,
                                        merchantFcmToken: widget
                                            .shipmentNotification
                                            .merchantFcmToken,
                                        receivingState: widget
                                            .shipmentNotification
                                            .receivingState,
                                        deliveryState: widget
                                            .shipmentNotification.deliveryState,
                                        deliveryCity: widget
                                            .shipmentNotification.deliveryCity,
                                        receivingCity: widget
                                            .shipmentNotification.receivingCity,
                                        totalShipmentCost: widget
                                            .shipmentNotification
                                            .totalShipmentCost,
                                        shippingCost: widget
                                            .shipmentNotification.shippingCost,
                                        childrenShipment: widget
                                            .shipmentNotification
                                            .childrenShipment,
                                        offerId: data.listOfOffers[i].id,
                                        shipmentId: widget
                                            .shipmentNotification.shipmentId,
                                      ).toMap(),
                                    });
                                    await _authProvider
                                        .sendBetterOfferNotification(
                                            title: 'عرض أفضل',
                                            body:
                                                'التاجر ${_authProvider.name}يريد منك تقديم عرض أفضل ',
                                            toToken: token,
                                            image: _authProvider
                                                    .photo!.isNotEmpty
                                                ? _authProvider.photo!.contains(
                                                        ApiConstants.baseUrl)
                                                    ? _authProvider.photo
                                                    : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                                : '',
                                            screenTo: '',
                                            type: '',
                                            betterOffer: 1,
                                            hasOffer: 1,
                                            data: ShipmentNotification(
                                              merchantName: widget
                                                  .shipmentNotification
                                                  .merchantName,
                                              merchantImage: widget
                                                  .shipmentNotification
                                                  .merchantImage,
                                              merchantId: _authProvider.id,
                                              merchantFcmToken: widget
                                                  .shipmentNotification
                                                  .merchantFcmToken,
                                              receivingState: widget
                                                  .shipmentNotification
                                                  .receivingState,
                                              deliveryState: widget
                                                  .shipmentNotification
                                                  .deliveryState,
                                              deliveryCity: widget
                                                  .shipmentNotification
                                                  .deliveryCity,
                                              receivingCity: widget
                                                  .shipmentNotification
                                                  .receivingCity,
                                              totalShipmentCost: widget
                                                  .shipmentNotification
                                                  .totalShipmentCost,
                                              shippingCost: widget
                                                  .shipmentNotification
                                                  .shippingCost,
                                              childrenShipment: widget
                                                  .shipmentNotification
                                                  .childrenShipment,
                                              offerId: data.listOfOffers[i].id,
                                              shipmentId: widget
                                                  .shipmentNotification
                                                  .shipmentId,
                                            ).toMap());
                                    MagicRouter.pop();
                                  },
                                ),
                              ),
                            ),
                            data.state == NetworkState.LIVEDATA
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'برجاء الانتظار',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            SpinKitThreeBounce(
                                              color: weevoPrimaryBlueColor,
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'جاري البحث عن مناديب',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container()
                          ],
                        )
                      : const Center(
                          child: Text(
                            'حدث خطأ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                            ),
                          ),
                        )),
        ),
      ),
    );
  }
}
