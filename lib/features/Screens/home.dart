import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/toasts.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Dialogs/crousal_dialog.dart';
import '../../core/Models/home_navigation_data.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/freshchat_provider.dart';
import '../../core/Providers/map_provider.dart';
import '../../core/Providers/product_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../../main.dart';
import '../Widgets/custom_home_navigation.dart';
import 'Fragments/main_screen.dart';
import 'Fragments/more_screen.dart';
import 'Fragments/notification_screen.dart';
import 'messages.dart';
import 'shipment_splash.dart';

class Home extends StatefulWidget {
  static String id = 'CategoryOne';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late MapProvider _mapProvider;
  late AuthProvider _authProvider;
  late FreshChatProvider freshChatInit;
  late AddShipmentProvider _shipmentProvider;
  late ProductProvider _productProvider;
  final bool _isPlus = Preferences.instance.getWeevoPlusPlanId.isNotEmpty;
  StreamSubscription<QuerySnapshot>? _chatSubscription;
  late StreamSubscription<QuerySnapshot> _notificationSubscription;
  int _totalMessages = 0;
  int _totalNotifications = 0;
  late Timer locationTimer;
  var notificationStream = Freshchat.onNotificationIntercept;
  var unreadCountStream = Freshchat.onMessageCountUpdate;
  bool isFirstTime = true;
  @override
  void initState() {
    super.initState();
    if (isFirstTime) {
      isFirstTime = false;
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
      freshChatInit = FreshChatProvider.listenFalse(context);
      AuthProvider.listenFalse(context).getServerKey();
      _mapProvider = Provider.of<MapProvider>(context, listen: false);
      _productProvider = Provider.of<ProductProvider>(context, listen: false);
      _shipmentProvider =
          Provider.of<AddShipmentProvider>(context, listen: false);
      _authProvider.initialFCM(context);
      _authProvider.initialOpenedAppFCM(context);
      checkNetwork();
    }
  }

  void checkFirstTime() {
    if (Preferences.instance.getFirstTime == 0) {
      showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (ctx) {
            return const CarouselDialog();
          });
    }
  }

  void initChatBadge() async {
    try {
      _chatSubscription = FirebaseFirestore.instance
          .collection('messages')
          .snapshots()
          .listen((v) {
        _totalMessages = 0;
        _totalMessages = v.docs
            .where((element) =>
                element.data()['lastMessage']['peerId'] == _authProvider.id &&
                element.data()['lastMessage']['read'] == false)
            .toList()
            .length;
        if (mounted) {
          setState(() {
            _authProvider.increaseChatCounter(_totalMessages);
          });
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void initNotificationBadge() async {
    try {
      _notificationSubscription = FirebaseFirestore.instance
          .collection('merchant_notifications')
          .doc(_authProvider.id)
          .collection(_authProvider.id!)
          .snapshots()
          .listen((v) {
        _totalNotifications = 0;
        _totalNotifications = v.docs
            .where((element) => element.data()['read'] == false)
            .toList()
            .length;
        setState(() {
          _authProvider.increaseNotificationCounter(_totalNotifications);
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void checkNetwork() async {
    if (await _authProvider.checkConnection()) {
      await _authProvider.getToken();
      await _authProvider.getFirebaseToken();
      getData();
      checkFirstTime();
      freshChatInit.initFreshChat();
      FirebaseFirestore.instance
          .collection('merchant_users')
          .doc(_authProvider.id)
          .set({
        'id': _authProvider.id,
        'email': _authProvider.email,
        'name': _authProvider.name,
        'imageUrl': '${_authProvider.photo}',
        'fcmToken': _authProvider.fcmToken,
        'national_id': _authProvider.phone,
      });
      _authProvider.updateToken(value: _authProvider.fcmToken);
      initChatBadge();
      initNotificationBadge();
    } else {
      showDialog(
        context: navigator.currentContext!,
        builder: (ctx) => ActionDialog(
          content: 'تأكد من الاتصال بشبكة الانترنت',
          cancelAction: 'حسناً',
          approveAction: 'حاول مرة اخري',
          onApproveClick: () async {
            MagicRouter.pop();
            checkNetwork();
          },
          onCancelClick: () {
            MagicRouter.pop();
          },
        ),
      );
    }
  }

  void getData() async {
    try {
      _authProvider.getGroupsWithBanners();
      _shipmentProvider.getCountries();
      _productProvider.getAllCategories();
      check(
          ctx: context, auth: _authProvider, state: _productProvider.catState);
      // _productProvider.getLast5Products();
      _mapProvider.getAllAddress(false);
      _productProvider.getProducts(false);
      _authProvider.weevoSubscriptionValidation();
      _authProvider.setCurrentMerchantLocation();
      locationTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
        _authProvider.setCurrentMerchantLocation();
      });
    } on Exception catch (e) {
      showToast('Get data error ${e.toString()}');
    }
    // _authProvider.getArticle();
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    freshChatInit.disposeTimer();
    freshChatInit.freshChatOnMessageCountUpdateDispose();
    _notificationSubscription.cancel();
    if (locationTimer.isActive) {
      locationTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapProvider mapProvider = Provider.of<MapProvider>(context);
    final FreshChatProvider freshChat = FreshChatProvider.get(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          switch (_currentIndex) {
            case 3:
              setState(() => _currentIndex = 0);
              break;
            case 2:
              setState(() => _currentIndex = 0);
              break;
            case 1:
              setState(() => _currentIndex = 0);
              break;
            case 0:
              showDialog(
                context: navigator.currentContext!,
                builder: (context) => ActionDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  title: 'الخروج من التطبيق',
                  content: 'هل تود الخروج من التطبيق',
                  approveAction: 'نعم',
                  cancelAction: 'لا',
                  onApproveClick: () {
                    MagicRouter.pop();
                    SystemNavigator.pop();
                  },
                  onCancelClick: () {
                    MagicRouter.pop();
                  },
                ),
              );
          }

          return false;
        },
        child: Scaffold(
          appBar: _currentIndex != 0
              ? AppBar(
                  title: Row(
                    children: [
                      if (_currentIndex == 1 || _currentIndex == 2)
                        InkWell(
                          onTap: () {
                            Freshchat.showConversations();
                          },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Badge.count(
                                count:
                                    freshChat.freshChatNewMessageCounter ?? 0,
                                textColor: Colors.white,
                                backgroundColor: weevoPrimaryBlueColor,
                                isLabelVisible: freshChat
                                            .freshChatNewMessageCounter !=
                                        null &&
                                    freshChat.freshChatNewMessageCounter! > 0,
                                child: SvgPicture.asset(
                                  'assets/images/chat.svg',
                                  width: 30.0.w,
                                  height: 30.0.h,
                                  color: weevoPrimaryOrangeColor,
                                ),
                              ),
                              // if (freshChat.freshChatNewMessageCounter !=
                              //         null &&
                              //     freshChat.freshChatNewMessageCounter! > 0)
                              //   Container(
                              //     height: 15.h,
                              //     width: 15.w,
                              //     decoration: const BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         color: Colors.white),
                              //     child: Center(
                              //       child: Text(
                              //         '${freshChat.freshChatNewMessageCounter}',
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //             color: Colors.white, fontSize: 9.sp),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Text(
                          _currentIndex == 1
                              ? 'الاشعارات'
                              : _currentIndex == 2
                                  ? 'الرسائل'
                                  : 'الحساب',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          floatingActionButton: SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton(
              elevation: 0.0,
              onPressed: () async {
                Weevo.facebookAppEvents.setAutoLogAppEventsEnabled(true);
                Weevo.facebookAppEvents
                    .setUserID(Preferences.instance.getUserId);
                Weevo.facebookAppEvents.setUserData(
                  email: Preferences.instance.getUserEmail,
                  firstName: Preferences.instance.getUserName.split('')[0],
                  lastName: Preferences.instance.getUserName.split('')[1],
                  phone: Preferences.instance.getPhoneNumber,
                );
                if (mapProvider.state == NetworkState.WAITING ||
                    productProvider.productState == NetworkState.WAITING) {
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (ctx) => const ActionDialog(
                      content: 'برجاء الانتظار',
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 800), () {
                    MagicRouter.pop();
                  });
                } else {
                  Navigator.pushNamed(
                    navigator.currentContext!,
                    ShipmentSplash.id,
                  );
                }
              },
              backgroundColor: weevoPrimaryBlueColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/weevo_new_logo.png',
                  height: 45.0.h,
                  width: 45.0.w,
                  color: Colors.white,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _currentIndex == 0
                    ? Padding(
                        padding: const EdgeInsets.all(
                          20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Freshchat.showConversations();
                              },
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Badge.count(
                                    count:
                                        freshChat.freshChatNewMessageCounter ??
                                            0,
                                    textColor: Colors.white,
                                    backgroundColor: weevoPrimaryBlueColor,
                                    isLabelVisible: freshChat
                                                .freshChatNewMessageCounter !=
                                            null &&
                                        freshChat.freshChatNewMessageCounter! >
                                            0,
                                    child: SvgPicture.asset(
                                      'assets/images/chat.svg',
                                      width: 30.0.w,
                                      height: 30.0.h,
                                      color: weevoPrimaryOrangeColor,
                                    ),
                                  ),
                                  // if (freshChat.freshChatNewMessageCounter !=
                                  //         null &&
                                  //     freshChat.freshChatNewMessageCounter! > 0)
                                  //   Container(
                                  //     height: 15.h,
                                  //     width: 15.w,
                                  //     decoration: const BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: Colors.white),
                                  //     child: Center(
                                  //       child: Text(
                                  //         '${freshChat.freshChatNewMessageCounter}',
                                  //         textAlign: TextAlign.center,
                                  //         style: TextStyle(
                                  //             color: Colors.white, fontSize: 9.sp),
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                            Image.asset(
                              'assets/images/weevo_blue_logo.png',
                              height: 35.0.h,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Expanded(
                  child: _getCurrentScreen(context, _isPlus),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: SafeArea(
            bottom: Platform.isAndroid,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0.w,
              ),
              height: 75.0.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  HomeNavigationData.navigationData.length,
                  (index) => CustomHomeNavigation(
                    svgPicture: index == _currentIndex
                        ? HomeNavigationData.navigationData[index].svgPicture
                        : HomeNavigationData.navigationData[index].svgPicture,
                    label: HomeNavigationData.navigationData[index].label,
                    isSelected: index == _currentIndex,
                    svgPictureSelected: HomeNavigationData
                        .navigationData[index].svgPicutureSelected,
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCurrentScreen(BuildContext ctx, bool isPlus) {
    late Widget w;
    switch (_currentIndex) {
      case 0:
        w = MainScreen(isPlus: isPlus);
        break;
      case 1:
        w = const NotificationScreen();
        break;
      case 2:
        w = const Messages(
          fromHome: true,
        );
        break;
      case 3:
        w = const MoreScreen();
        break;
    }
    return w;
  }
}
