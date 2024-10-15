import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart' as freshChat;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/api_constants.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/ui/bulk_shipment_details_screen.dart';

import '../../core_new/networking/dio_factory.dart';
import '../../features/Screens/Fragments/sign_up_personal_info_screen.dart';
import '../../features/Screens/Fragments/sign_up_phone_verification.dart';
import '../../features/Screens/after_registration.dart';
import '../../features/Screens/before_registration.dart';
import '../../features/Screens/chat_screen.dart';
import '../../features/Screens/choose_courier.dart';
import '../../features/Screens/handle_shipment.dart';
import '../../features/Screens/home.dart';
import '../../features/Screens/merchant_warehouse.dart';
import '../../features/Screens/onboarding_screens.dart';
import '../../features/Screens/wallet.dart';
import '../../features/shipment_details/ui/shipment_details_screen.dart';
import '../../features/wasully_handle_shipment/ui/widgets/wasully_rating_dialog.dart';
import '../../main.dart';
import '../Dialogs/action_dialog.dart';
import '../Dialogs/loading.dart';
import '../Dialogs/rating_dialog.dart';
import '../Models/account_existed.dart';
import '../Models/articles.dart';
import '../Models/articles_data.dart';
import '../Models/chat_data.dart';
import '../Models/create_user.dart';
import '../Models/group_banner.dart';
import '../Models/home_banner.dart';
import '../Models/image.dart';
import '../Models/list_of_available_payment_gateways.dart';
import '../Models/merchant_critical_update.dart';
import '../Models/send_otp_model.dart';
import '../Models/shipment_notification.dart';
import '../Models/shipment_tracking_model.dart';
import '../Models/sign_up_data.dart';
import '../Models/update_user_datat.dart';
import '../Models/user_data.dart';
import '../Models/weevo_plus_validation.dart';
import '../Models/weevo_user.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../Utilits/notification_const.dart';
import '../httpHelper/http_helper.dart';
import '../router/router.dart';

class AuthProvider with ChangeNotifier {
  static AuthProvider get(BuildContext context) =>
      Provider.of<AuthProvider>(context);

  static AuthProvider listenFalse(BuildContext context) =>
      Provider.of<AuthProvider>(context, listen: false);
  int _screenIndex = 0;
  String? _currentWidget;
  static const String success = 'SUCCESS';
  Widget _page = const SignUpPersonalInfo();
  bool _fromOutsideNotification = false;
  bool _fromNotificationHome = false;
  NetworkState? _resetPasswordState;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final bool _test = false;
  NetworkState? _bannerState;
  NetworkState _articleState = NetworkState.WAITING;
  NetworkState? _updateTokenState;
  NetworkState _weevoSubscriptionState = NetworkState.WAITING;
  NetworkState? _merchantCriticalUpdateState;
  NetworkState? _logoutState;
  NetworkState? _existedState;
  NetworkState _groupBannersState = NetworkState.WAITING;
  NetworkState? _listOfAvailablePaymentGatewaysState;
  NetworkState? _shipmentStatusState;
  List<GroupBanner>? _groupBanner;
  List<HomeBanner>? _homeBanner;
  List<ArticlesData>? _articles;
  bool _isLoading = false;
  bool _isImageLoading = false;
  int _addressSelectedItem = 0;
  Preferences? _preferences;
  String? _verificationId;
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  bool _frontIdImageLoading = false;
  bool _backIdImageLoading = false;
  MerchantCriticalUpdate? _merchantCriticalUpdate;
  NetworkState? _isNotificationOnState;
  NetworkState? _versionState;
  List<ListOfAvailablePaymentGateways>? _listOfAvailablePaymentGateways;
  double? currentLatitude, currentLongitude;
  Location? _location;
  PermissionStatus? _permissionGranted;
  bool? _serviceEnabled;
  LocationData? _locationData;

  int? _userId;
  String? _firstName;
  String? _lastName;
  String? _userPhoto;
  String? _userPhone;
  String? _userFirebaseToken;
  String? _userFirebaseId;
  String? _userEmail;
  String? _userType;
  String? _userPassword;
  String? _nationalIdNumber;
  String? _nationalIdPhotoBack;
  String? _nationalIdPhotoFront;
  String? _commercialActivity;
  String? _resetPasswordMessage;
  int? _totalMessages = 0;
  int? _totalNotifications = 0;
  bool? _isOn;
  int start = 120;
  bool wait = false;

  bool _canGoInside = false;
  bool _courierAppliedToShipment = false;

  bool get canGoInside => _canGoInside;

  NetworkState get weevoSubscriptionState => _weevoSubscriptionState;

  NetworkState? get logoutState => _logoutState;

  NetworkState? get resetPasswordState => _resetPasswordState;

  String? get currentWidget => _currentWidget;

  String? get verificationId => _verificationId;

  NetworkState? get bannerState => _bannerState;

  NetworkState? get articleState => _articleState;

  String? get resetPasswordMessage => _resetPasswordMessage;

  bool get isImageLoading => _isImageLoading;

  bool? get isOn => _isOn;

  NetworkState? get shipmentStatusState => _shipmentStatusState;

  NetworkState? get listOfAvailablePaymentGatewaysState =>
      _listOfAvailablePaymentGatewaysState;

  Future<void> initPreferences() async {
    _preferences = Preferences.instance;
  }

  void setVerificationId(String v) {
    _verificationId = v;
  }

  void setResetPhoneNumber(String v) {
    _userPhone = v;
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
    if (_permissionGranted == PermissionStatus.deniedForever) {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => ActionDialog(
                content: 'يجب عليك تفعيل الموقع من الاعدادت هل تود ذلك',
                cancelAction: 'لا',
                onCancelClick: () {
                  Navigator.pop(navigator.currentContext!);
                },
                approveAction: 'نعم',
                onApproveClick: () async {
                  Navigator.pop(navigator.currentContext!);
                  await geo.Geolocator.openLocationSettings();
                },
              ));
    } else if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location?.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<LocationData> getUserLocation() async {
    _location = Location();
    if (await locationServiceEnabled() && await locationPermissionGranted()) {
      _location?.changeSettings(
          accuracy: LocationAccuracy.navigation, interval: 10000);
      _locationData = await _location?.getLocation();
    }
    return _locationData!;
  }

  Future<void> setCurrentMerchantLocation() async {
    try {
      await getUserLocation();
      Response r = await HttpHelper.instance.httpPost(
        'set-current-location',
        true,
        body: {
          'lat': _locationData?.latitude,
          'lng': _locationData?.longitude,
        },
      );
      log('send current location body -> ${r.body}');
      log('send current location url -> ${r.request?.url}');
      log('send current location statusCode -> ${r.statusCode}');
    } catch (e) {
      log('location error -> ${e.toString()}');
    }
  }

  Future<void> getShipmentStatus(
    int id,
  ) async {
    try {
      _shipmentStatusState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpGet(
        'shipments/$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _shipmentStatusState = NetworkState.SUCCESS;
        _canGoInside = jsonDecode(r.body)['status'] == 'available';
        _courierAppliedToShipment =
            jsonDecode(r.body)['status'] == 'courier-applied-to-shipment';
      } else {
        _shipmentStatusState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  bool get courierAppliedToShipment => _courierAppliedToShipment;

  void setIsOn(bool v) {
    _isOn = v;
    notifyListeners();
  }

  void setResetUserFirebaseToken(String v) {
    _userFirebaseToken = v;
  }

  void setFromOutsideNotification(bool v) {
    _fromOutsideNotification = v;
  }

  void setFromNotificationHome(bool v) {
    _fromNotificationHome = v;
  }

  bool get fromNotificationHome => _fromNotificationHome;

  bool get fromOutsideNotification => _fromOutsideNotification;

  NetworkState? get isNotificationOnState => _isNotificationOnState;

  NetworkState? get updateTokenState => _updateTokenState;

  void setCurrentWidget(String v) {
    _currentWidget = v;
  }

  NetworkState? get merchantCriticalUpdateState => _merchantCriticalUpdateState;

  NetworkState? get versionState => _versionState;

  MerchantCriticalUpdate? get merchantCriticalUpdate => _merchantCriticalUpdate;

  Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Please complete the biometrics to proceed.',
        );
      } on PlatformException catch (e) {
        log(e.code);
        if (e.code == notAvailable ||
            e.code == passcodeNotSet ||
            e.code == notEnrolled) {
          isAuthenticated = await localAuthentication.authenticate(
              localizedReason: 'Please complete the biometrics to proceed.');
        }
      }
    } else {
      try {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Please complete the biometrics to proceed.',
        );
      } on PlatformException catch (e) {
        if (e.code == notAvailable ||
            e.code == passcodeNotSet ||
            e.code == notEnrolled) {
          isAuthenticated = true;
        }
      }
    }
    return isAuthenticated;
  }

  void increaseChatCounter(int count) async {
    _totalMessages = count;
  }

  void increaseNotificationCounter(int count) async {
    _totalNotifications = count;
  }

  int? get totalMessages => _totalMessages;

  int? get totalNotifications => _totalNotifications;

  Future<Img?> uploadPhotoID(
      {required String path, required String imageName}) async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'register/upload-national-id',
        false,
        body: {
          'file': path,
          'filename': imageName,
        },
      );
      log('body -> ${r.body}');
      log('statusCode -> ${r.statusCode}');
      log('url -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        return Img.fromJson(jsonDecode(r.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> deletePhotoID(
      {required String token, required String imageName}) async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'register/delete-national-id',
        false,
        body: {
          'filename': imageName,
          'token': token,
        },
      );
      log('body -> ${r.body}');
      log('statusCode -> ${r.statusCode}');
      log('url -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        return success;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  Future<void> getBanners() async {
    _bannerState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpGet(
        'banners?group_slug=merchant-home-top-banners',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _homeBanner = (json.decode(r.body) as List)
            .map((e) => HomeBanner.fromJson(e))
            .toList();
        _bannerState = NetworkState.SUCCESS;
      } else {
        _bannerState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getArticle() async {
    _articleState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpGet(
        'articles',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Articles article = Articles.fromJson(json.decode(r.body));
        _articles = article.data;
        _articleState = NetworkState.SUCCESS;
      } else {
        _articleState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  List<ArticlesData>? get articles => _articles;

  Future<void> getGroupsWithBanners() async {
    _groupBannersState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpGet(
        'banners/groups?with-banners=true',
        true,
      );
      log('${json.decode(r.body)}');
      log('${r.statusCode}');
      log(Preferences.instance.getTokenType);
      log(Preferences.instance.getAccessToken);
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _groupBanner = (json.decode(r.body) as List)
            .map((e) => GroupBanner.fromJson(e))
            .toList();
        _groupBannersState = NetworkState.SUCCESS;
      } else {
        _groupBannersState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<bool> checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  List<GroupBanner>? get groupBanner => _groupBanner;

  bool get frontIdImageLoading => _frontIdImageLoading;

  Future<String> saveUser(UserData data, {String? password}) async {
    try {
      await _preferences?.setUserEmail(data.user?.email ?? '');
      await _preferences?.setUserId(data.user?.id.toString() ?? '');
      await _preferences?.setPhoneNumber(data.user?.phone ?? '');
      if (data.user?.walletNumber != null) {
        await _preferences?.setWeevoWalletNumber(data.user?.walletNumber ?? '');
      }
      if (data.user?.cachedAverageRating != null) {
        await _preferences?.setRating(data.user?.cachedAverageRating ?? '');
      }
      if (password != null) {
        await _preferences?.setPassword(password);
      }
      if (data.user?.addressBookDefaultId != null) {
        await _preferences?.setAddressId(data.user?.addressBookDefaultId ?? 0);
      }
      if (data.user?.bankAccountClientName != null) {
        await _preferences?.setWeevoBankAccountClientName(
            data.user?.bankAccountClientName ?? '');
      }
      if (data.user?.bankBranchName != null) {
        await _preferences
            ?.setWeevoBankBranchName(data.user?.bankBranchName ?? '');
      }
      if (data.user?.bankName != null) {
        await _preferences?.setWeevoBankName(data.user?.bankName ?? '');
      }
      if (data.user?.bankAccountNumberIban != null) {
        await _preferences?.setWeevoBankAccountIbanNumber(
            data.user?.bankAccountNumberIban ?? '');
      }
      await _preferences?.setTokenType(data.tokenType ?? '');
      if (data.user?.photo != null) {
        await _preferences?.setUserPhotoUrl(data.user?.photo ?? '');
      }
      await _preferences
          ?.setUserName('${data.user?.firstName} ${data.user?.lastName}');
      await _preferences?.setAccessToken(data.accessToken ?? '');
      await _preferences?.setExpiresAt(data.expiresAt ?? '');
      if (data.user?.activeSubscriptions != null) {
        await _preferences?.setWeevoPlusEndDate(
            data.user?.activeSubscriptions?[0].endsAt ?? '');
      }
      if (data.user?.activeSubscriptions != null) {
        await _preferences?.setWeevoPlusPlanId(
            data.user?.activeSubscriptions?[0].planId.toString() ?? '');
      }
      await _preferences?.setNotificationOn(1);
      return AuthProvider.success;
    } catch (e) {
      log('error from save user -> ${e.toString()}');
      return e.toString();
    }
  }

  Future<void> notificationOff() async {
    await userReceiveNotification(value: 0);
  }

  Future<void> notificationOn() async {
    await userReceiveNotification(value: 1);
  }

  Future<void> userReceiveNotification({
    int? value,
  }) async {
    _isNotificationOnState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'receive_notifications': value,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        await _preferences
            ?.setNotificationOn(jsonDecode(r.body)['receive_notifications']);
        _isNotificationOnState = NetworkState.SUCCESS;
      } else {
        _isNotificationOnState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> setAppVersion({
    String? appVersion,
  }) async {
    _versionState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'app_version': appVersion,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _versionState = NetworkState.SUCCESS;
      } else {
        _versionState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateToken({
    String? value,
  }) async {
    _updateTokenState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'firebase_notification_token': value,
          'password_verification': password,
        },
      );
      log('firebase_notification_token-> $value');
      log('firebase_notification_token-> ${r.body}');
      log('firebase_notification_token-> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _updateTokenState = NetworkState.SUCCESS;
      } else {
        _updateTokenState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> weevoSubscriptionValidation() async {
    _weevoSubscriptionState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'weevo-plus/check-has-valid-subscription',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        WeevoPlusValidation weevoPlusValidation =
            WeevoPlusValidation.fromJson(json.decode(r.body));
        if (weevoPlusValidation.hasActiveSubscription == true) {
          _preferences?.setWeevoPlusPlanId(weevoPlusValidation
                  .activeSubscriptions?.first.planId
                  .toString() ??
              '');
          _preferences?.setWeevoPlusEndDate(
              weevoPlusValidation.activeSubscriptions?.first.endsAt ?? '');
        } else {
          _preferences?.setWeevoPlusPlanId('');
          _preferences?.setWeevoPlusEndDate('');
        }
        _weevoSubscriptionState = NetworkState.SUCCESS;
      } else {
        _weevoSubscriptionState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  List<ListOfAvailablePaymentGateways>? get listOfAvailablePaymentGateways =>
      _listOfAvailablePaymentGateways;

  Future<void> merchantUpdate(String currentVersion) async {
    _merchantCriticalUpdateState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'check-for-critical-update',
        false,
        body: {
          'current_app_version': currentVersion,
          'os': Platform.isAndroid ? 'android' : 'ios',
        },
      );
      await _preferences?.setAppVersionNumber(currentVersion);
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _merchantCriticalUpdate =
            MerchantCriticalUpdate.fromJson(json.decode(r.body));
        _merchantCriticalUpdateState = NetworkState.SUCCESS;
      } else {
        _merchantCriticalUpdateState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<bool> checkPhoneExisted(String phone) async {
    _existedState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'register/check-existence',
        false,
        body: {
          'login': phone,
        },
      );
      log('${AccountExisted.fromJson(json.decode(r.body)).existed}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log(r.body);
        AccountExisted accountExisted =
            AccountExisted.fromJson(json.decode(r.body));
        _existedState = NetworkState.SUCCESS;
        return accountExisted.existed;
      } else {
        log(r.body);
        _existedState = NetworkState.ERROR;
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
    return false;
  }

  Future<bool> checkEmailExisted(String email) async {
    _existedState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'register/check-existence',
        false,
        body: {
          'login': email,
        },
      );
      log('${AccountExisted.fromJson(json.decode(r.body)).existed}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log(r.body);
        AccountExisted accountExisted =
            AccountExisted.fromJson(json.decode(r.body));
        _existedState = NetworkState.SUCCESS;
        return accountExisted.existed;
      } else {
        log(r.body);
        _existedState = NetworkState.ERROR;
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
    return false;
  }

  NetworkState? get existedState => _existedState;

  Future<String> saveNewUser(CreateUser data, {String? password}) async {
    try {
      await _preferences?.setUserId(data.user?.id.toString() ?? '');
      await _preferences?.setPhoneNumber(data.user?.phone ?? '');
      await _preferences?.setUserEmail(data.user?.email ?? '');
      if (password != null) {
        await _preferences?.setPassword(password);
      }
      await _preferences?.setTokenType(data.tokenType ?? '');
      if (data.user?.photo != null) {
        await _preferences?.setUserPhotoUrl(data.user?.photo ?? '');
      }
      await _preferences
          ?.setUserName('${data.user?.firstName} ${data.user?.lastName}');
      await _preferences?.setAccessToken(data.accessToken ?? '');
      await _preferences?.setExpiresAt(data.expiresAt ?? '');
      await _preferences?.setNotificationOn(1);
      await _preferences?.setWeevoPlusEndDate(data.subscription?.endsAt ?? '');
      await _preferences
          ?.setWeevoPlusPlanId(data.subscription?.planId.toString() ?? '');
      return AuthProvider.success;
    } catch (e) {
      log('error from save user -> ${e.toString()}');
      return e.toString();
    }
  }

  String? get userFirebaseToken => _userFirebaseToken;

  Future<String> updateUser(
    UpdateUserData data, {
    String? password,
    String? photo,
  }) async {
    try {
      if (data.photo != null) {
        await _preferences?.setUserPhotoUrl(data.photo ?? '');
      }
      await _preferences?.setUserName('${data.firstName} ${data.lastName}');
      if (data.dateOfBirth != null) {
        await _preferences?.setDateOfBirth(data.dateOfBirth ?? '');
      }
      return AuthProvider.success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateUserEmail(String email) async {
    try {
      await _preferences?.setUserEmail(email);
      return AuthProvider.success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updatePhoneNumber(String phone) async {
    try {
      await _preferences?.setPhoneNumber(phone);
      return AuthProvider.success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updatePassword(String password) async {
    try {
      await _preferences?.setPassword(password);
      return AuthProvider.success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateUserProfile(String first, String last, String gender,
      String dateOfBirth, String? photo) async {
    try {
      await _preferences?.setUserName('$first $last');
      await _preferences?.setDateOfBirth(dateOfBirth);
      if (photo != null) {
        await _preferences?.setUserPhotoUrl(photo);
      }
      return AuthProvider.success;
    } catch (e) {
      return e.toString();
    }
  }

  bool isLogin = false;

  String? get firstName => _firstName;

  int? get userId => _userId;

  Future<Img?> uploadPhoto({
    required String path,
    required String imageName,
  }) async {
    try {
      Response response = await HttpHelper.instance.httpPost(
        'register/upload-image',
        true,
        body: {
          'file': path,
          'filename': imageName,
        },
      );
      if (response.statusCode == 200) {
        return Img.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void setUserDataOne(SignUpData data) {
    _firstName = data.firstName;
    _lastName = data.lastName;
    _userPhoto = data.photo;
    _userPhone = data.phone;
    _userEmail = data.email;
    _userType = data.userType;
    _userPassword = data.password;
    // _nationalIdNumber = data.nationalIdNumber;
    // _commercialActivity = data.commercialActivity;
  }

  void setUserDataTwo(SignUpData data) {
    _userFirebaseToken = data.userFirebaseToken;
    _userFirebaseId = data.userFirebaseId;
    log(data.toString());
  }

  String? get userFirebaseId => _userFirebaseId;

  // void setUserDataThree(SignUpData data) {
  //   _nationalIdPhotoFront = data.nationalIdFront;
  //   _nationalIdPhotoBack = data.nationalIdBack;
  //   log(data.toString());
  // }

  Future<String> deletePhoto({
    required String token,
    required String imageName,
  }) async {
    try {
      Response response = await HttpHelper.instance.httpPost(
        'register/delete-image',
        true,
        body: {
          'filename': imageName,
          'token': token,
        },
      );
      if (response.statusCode == 200) {
        return AuthProvider.success;
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  void setAddressSelectedItem(int i) {
    _addressSelectedItem = i;
    notifyListeners();
  }

  int get addressSelectedItem => _addressSelectedItem;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setImageLoading(bool value) {
    _isImageLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void updateScreen(int i) {
    _screenIndex = i;
    getCurrentPage(i);
    notifyListeners();
  }

  bool get test => _test;

  int get screenIndex => _screenIndex;

  Widget get currentPage => _page;
  CreateUser? createUser;
  String? createUserPassword;

  Future<void> createNewUser(WeevoUser user) async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'register',
        false,
        body: user.toJson(),
      );
      log('createNewUser -> ${r.body}');
      log('createNewUser -> ${r.statusCode}');
      log('createNewUser -> ${r.request?.url}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        createUser = CreateUser.fromJson(jsonDecode(r.body));
        _userId = createUser?.user?.id;
        createUserPassword = user.password;
        await FirebaseFirestore.instance
            .collection('merchant_users')
            .doc(userId.toString())
            .set({
          'id': _userId,
          'email': _userEmail,
          'name': '$_firstName $_lastName',
          'imageUrl': _userPhoto ?? '',
          'fcmToken': _preferences?.getFcmToken,
          'national_id': phone,
        });
        Weevo.facebookAppEvents.logCompletedRegistration(
            registrationMethod: 'Merchant Registered');
        verifyPhoneNumber();
      } else {
        setLoading(false);
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
      log('error from create user -> ${e.toString()}');
    }
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    wait = true;
    Timer.periodic(onsec, (timer) {
      if (start == 0) {
        timer.cancel();
        wait = false;
      } else {
        start--;
      }
      notifyListeners();
    });
  }

  void resendReset() {
    // start = (resendOtpModel != null && resendOtpModel.retryAfter != null)
    //     ? (resendOtpModel.retryAfter.toInt() * 60)
    //     : 120;
    wait = true;
    notifyListeners();
  }

  format(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0").substring(3, 8);

  SendOtpModel? sendOtpModel;
  ResendOtpModel? resendOtpModel;
  String? otpToken;

  Future<void> verifyPhoneNumber() async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        '${ApiConstants.baseUrl}/api/v2/merchant/register/send-otp',
        false,
        withoutPath: true,
        body: {
          "phone": _userPhone,
          "email": _userEmail,
          // "national_id_number": _nationalIdNumber,
        },
      );
      log('verifyPhoneNumber -> $_userPhone');
      log('verifyPhoneNumber -> ${<String, dynamic>{
        "phone": _userPhone,
        "email": _userEmail,
        // "national_id_number": _nationalIdNumber,
      }}');
      log('verifyPhoneNumber -> ${r.body}');
      log('verifyPhoneNumber -> ${r.request?.url}');
      log('verifyPhoneNumber -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        sendOtpModel = SendOtpModel.fromJson(json.decode(r.body));
        otpToken = sendOtpModel?.otpToken;
        start = (sendOtpModel?.retryAfter?.toInt() ?? 0 * 60);
        resendReset();
        startTimer();
        setLoading(false);
        Navigator.pushNamed(
            navigator.currentContext!, SignUpPhoneVerification.id);
      } else {
        setLoading(false);
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
      log('error from create user -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> checkOtp({
    required String otp,
  }) async {
    try {
      showDialog(
          context: navigator.currentContext!,
          builder: (context) => const LoadingDialog());
      Response r = await HttpHelper.instance.httpPost(
        '${ApiConstants.baseUrl}/api/v2/merchant/register/check-otp',
        false,
        withoutPath: true,
        body: {
          "otp": otp,
          "otp_token": otpToken,
          "identifier": _userPhone,
        },
      );
      log('checkOtp -> ${<String, dynamic>{
        "otp": otp,
        "otp_token": otpToken,
        "identifier": _userPhone,
      }}');
      log('checkOtp -> ${r.body}');
      log('checkOtp -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        if (isLogin) {
          await saveUser(
            userLoginData!,
            password: createUserPassword,
          );
        } else {
          await saveNewUser(
            createUser!,
            password: createUserPassword,
          );
        }
        Navigator.pop(navigator.currentContext!);
        Navigator.pushNamedAndRemoveUntil(
            navigator.currentContext!, AfterRegistration.id, (route) => false);
        reset();
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
      log('error from create user -> ${e.toString()}');
    }
  }

  Future<void> resendOtp() async {
    try {
      showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (context) => const LoadingDialog());
      Response r = await HttpHelper.instance.httpPost(
        '${ApiConstants.baseUrl}/api/v2/merchant/register/resend-otp',
        false,
        withoutPath: true,
        body: {
          "identifier": _userPhone,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Navigator.pop(navigator.currentContext!);
        resendOtpModel = ResendOtpModel.fromJson(json.decode(r.body));
        otpToken = resendOtpModel?.otpToken;
        start = (resendOtpModel?.retryAfter?.toInt() ?? 0 * 60);
        resendReset();
        startTimer();
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
      log('error from create user -> ${e.toString()}');
    }
  }

  Future<void> resetPassword({
    required String firebaseToken,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'password/reset',
        false,
        body: {
          'firebase_token': firebaseToken,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log('reset password -> ${r.body}');
        _resetPasswordState = NetworkState.SUCCESS;
      } else {
        if (json.decode(r.body)['message'] == "User doesn't exist!") {
          _resetPasswordMessage = 'هذا الحساب غير موجود';
        } else if (json.decode(r.body).toString().contains('errors')) {
          if (json.decode(r.body)['errors']['password'][0] ==
              "The password must be at least 8 characters.") {
            _resetPasswordMessage =
                'يجب ان تكون كلمة المرور مكونة من 8 أحرف علي الاقل';
          }
        } else {
          _resetPasswordMessage = 'حدث خطأ حاول مرة اخري';
        }
        _resetPasswordState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error from reset password -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    try {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => const LoadingDialog());
      Response r = await HttpHelper.instance.httpDelete(
        'deleted-account/${_preferences?.getUserId}',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: r.body.contains('message')
                      ? json.decode(r.body)['message']
                      : r.body,
                  approveAction: 'حسناً',
                  onApproveClick: () async {
                    await _preferences?.clearUser();
                    MagicRouter.pop();
                    MagicRouter.navigateAndPopAll(const BeforeRegistration());
                  },
                ));
      } else {
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: r.body.contains('message')
                      ? json.decode(r.body)['message']
                      : r.body,
                  approveAction: 'حسناً',
                  onApproveClick: () async {
                    MagicRouter.pop();
                  },
                ));
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
  }

  Future<void> weevoListOfAvailablePaymentGateways() async {
    _listOfAvailablePaymentGatewaysState = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpGet(
        'list-of-available-payment-gateways',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _listOfAvailablePaymentGateways = (json.decode(r.body) as List)
            .map((e) => ListOfAvailablePaymentGateways.fromJson(e))
            .toList();
        _listOfAvailablePaymentGatewaysState = NetworkState.SUCCESS;
      } else {
        _listOfAvailablePaymentGatewaysState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<String> setAddressId(int id) async {
    try {
      await _preferences?.setAddressId(id);
      return AuthProvider.success;
    } catch (e) {
      return e.toString();
    }
  }

  UserData? userLoginData;

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'login',
        false,
        body: {
          'login': email,
          'password': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        userLoginData = UserData.fromJson(json.decode(r.body));
        createUserPassword = password;
        await getFirebaseToken();
        if (userLoginData?.user?.emailVerifiedAt != null) {
          await saveUser(
            userLoginData!,
            password: createUserPassword,
          );
          setLoading(false);
          Navigator.pushReplacementNamed(
            navigator.currentContext!,
            AfterRegistration.id,
          );
        } else {
          isLogin = true;
          _userPhone = userLoginData?.user?.phone;
          _userEmail = userLoginData?.user?.email;
          _nationalIdNumber = userLoginData?.user?.nationalIdNumber;
          verifyPhoneNumber();
        }
      } else {
        setLoading(false);
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['errors']['login']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
      }
    } catch (e) {
      log('login body -> ${e.toString()}');
    }
  }

  Future<void> authLogin() async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'login',
        false,
        body: {
          'login': _preferences?.getPhoneNumber,
          'password': _preferences?.getPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        userLoginData = UserData.fromJson(json.decode(r.body));
        await Future.wait<bool>([
          _preferences!.setTokenType(userLoginData?.tokenType ?? ''),
          _preferences!.setAccessToken(userLoginData?.accessToken ?? ''),
        ]);
      }
    } catch (e) {
      log('login error -> ${e.toString()}');
    }
  }

  Future<void> logout(bool logoutOtherDevices) async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'logout?logout_other_devices=$logoutOtherDevices',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        await _preferences?.clearUser();
        MagicRouter.pop();
        MagicRouter.navigateAndPopAll(const BeforeRegistration());
      } else {
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
      log('error from logout user -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> clearUserData() async {
    await _preferences?.clearUser();
  }

  void getCurrentPage(int i) {
    switch (i) {
      case 0:
        _page = const SignUpPersonalInfo();
        break;
      // case 1:
      //   _page = SignUpPhoneVerification();
      //   break;
      // case 1:
      //   _page = SignUpNationalIDScreen();
      //   break;
    }
  }

  String? get id => _preferences!.getUserId;

  String? get getRating => _preferences!.getRating;

  int? get addressId => _preferences!.getAddressId;

  String? get password => _preferences!.getPassword;

  String? get name => _preferences!.getUserName;

  String? get getNationalId => _preferences!.getPhoneNumber;

  String? get dateOfBirth => _preferences!.getDateOfBirth;

  String? get email => _preferences!.getUserEmail;

  String? get photo => _preferences!.getUserPhotoUrl;

  String? get expirationDate => _preferences!.getExpiresAt;

  String? get token => _preferences!.getAccessToken;

  String? get fcmToken => _preferences!.getFcmToken;

  String? get phone => _preferences!.getPhoneNumber;

  String? get tokenIsValid => _preferences!.getAccessToken.isNotEmpty &&
          _preferences!.getExpiresAt.isNotEmpty &&
          DateTime.parse(_preferences!.getExpiresAt).isAfter(DateTime.now())
      ? _preferences!.getAccessToken
      : null;

  bool get isValid => tokenIsValid != null;

// bool _kShouldTestAsyncErrorOnInit = true;

// Toggle this for testing Crashlytics in your app locally.
//   bool _kTestingCrashlytics = true;

// initializeFirebaseCrashlytics() {
//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
// }

  Future<void> getToken() async {
    String? token = await fcm.getToken();
    await _preferences!.setFcmToken(token ?? '');
    log('token received $token');
  }

  Future<void> getFirebaseToken() async {
    freshChat.Freshchat.setNotificationConfig(
      priority: freshChat.Priority.PRIORITY_HIGH,
      importance: freshChat.Importance.IMPORTANCE_MAX,
      notificationSoundEnabled: true,
      notificationInterceptionEnabled: true,
      largeIcon: "large_icon",
      smallIcon: "small_icon",
    );
    String? token = await fcm.getToken();
    log('fcm token -> $token');
    freshChat.Freshchat.setPushRegistrationToken(token ?? '');
    if (_preferences!.getNotificationOn == 1) {
      fcm.subscribeToTopic('all');
      fcm.subscribeToTopic('merchant');
    }
    await _preferences!.setFcmToken(token ?? '');
    fcm.onTokenRefresh.listen(
      (event) {
        freshChat.Freshchat.setPushRegistrationToken(event);
      },
    );
  }

  Future<void> getInitMessage() async {
    RemoteMessage? m = await fcm.getInitialMessage();
    goTo(navigator.currentContext!, m);
  }

  void reset() {
    _userId = null;
    _firstName = null;
    _lastName = null;
    _userPhoto = null;
    _userPhone = null;
    _userEmail = null;
    _userType = null;
    _userPassword = null;
    _nationalIdNumber = null;
    _commercialActivity = null;
    _userFirebaseToken = null;
    _verificationId = null;
    _nationalIdPhotoBack = null;
    _nationalIdPhotoFront = null;
    _screenIndex = 0;
    _page = const SignUpPersonalInfo();
  }

  void goTo(BuildContext ctx, RemoteMessage? m) {
    if (m?.data['type'] == 'rating') {
      MagicRouter.navigateAndPop(const Home());
      MagicRouter.navigateAndPopAll(
        RatingDialog(
          model: ShipmentTrackingModel.fromJson(
            json.decode(
              m?.data['data'],
            ),
          ),
        ),
      );
    } else if (m?.data['type'] == 'wasully_rating') {
      log('Wasully rating dialog');
      MagicRouter.navigateAndPopAll(WasullyRatingDialog(
        model: ShipmentTrackingModel.fromJson(
          m?.data ?? {},
        ),
      ));
      // showBottomSheet(
      //   context: navigator.currentContext!,
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(20.0),
      //     topRight: Radius.circular(20.0),
      //   )),
      //   builder: (context) => WasullyRatingDialog(
      //     model: ShipmentTrackingModel.fromJson(
      //       json.decode(
      //         m.data['data'],
      //       ),
      //     ),
      //   ),
      // );
    } else {
      _fromOutsideNotification = true;
      switch (m?.data['screen_to']) {
        case productScreen:
          Navigator.pushReplacementNamed(ctx, MerchantWarehouse.id);
          break;
        case wallet:
          Navigator.pushReplacementNamed(ctx, Wallet.id);
          break;
        case homeScreen:
          Navigator.pushReplacementNamed(ctx, Home.id);
          break;
        case shipmentOffers:
          Navigator.pushNamed(
            ctx,
            ChooseCourier.id,
            arguments:
                ShipmentNotification.fromMap(json.decode(m?.data['data'])),
          );
          break;
        case shipmentDecline:
          Navigator.pushNamed(
            ctx,
            ChooseCourier.id,
            arguments:
                ShipmentNotification.fromMap(json.decode(m?.data['data'])),
          );
          break;
        case shipmentScreen:
          if (ShipmentTrackingModel.fromJson(json.decode(m?.data['data']))
                  .hasChildren ==
              0) {
            MagicRouter.navigateAndPop(ShipmentDetailsScreen(
              id: ShipmentTrackingModel.fromJson(json.decode(m?.data['data']))
                  .shipmentId!,
            ));
          } else {
            MagicRouter.navigateAndPop(
              BulkShipmentDetailsScreen(
                  shipmentId: ShipmentTrackingModel.fromJson(
                          json.decode(m?.data['data']))
                      .shipmentId!),
            );
          }
          break;
        case handleShipmentScreen:
          Navigator.pushReplacementNamed(ctx, HandleShipment.id,
              arguments:
                  ShipmentTrackingModel.fromJson(json.decode(m?.data['data'])));
          break;
        case walletScreen:
          Navigator.pushReplacementNamed(ctx, Wallet.id);
          break;
        case chatScreen:
          ChatData chatData = ChatData.fromJson(json.decode(m?.data['data']));
          ChatData finalChatData;
          if (chatData.currentUserNationalId == getNationalId) {
            finalChatData = ChatData(
              chatData.peerPhoneNumber,
              chatData.currentPhoneNumber,
              currentUserId: chatData.currentUserId,
              currentUserNationalId: chatData.currentUserNationalId,
              peerId: chatData.peerId,
              peerImageUrl: chatData.peerImageUrl,
              peerUserName: chatData.peerUserName,
              peerNationalId: chatData.peerNationalId,
              shipmentId: chatData.shipmentId,
              currentUserName: chatData.currentUserName,
              currentUserImageUrl: chatData.currentUserImageUrl,
              conversionId: chatData.conversionId,
              type: chatData.type,
            );
          } else {
            finalChatData = ChatData(
              chatData.peerPhoneNumber,
              chatData.currentPhoneNumber,
              currentUserNationalId: chatData.peerNationalId,
              peerNationalId: chatData.currentUserNationalId,
              currentUserId: chatData.peerId,
              peerId: chatData.currentUserId,
              peerImageUrl: chatData.currentUserImageUrl,
              peerUserName: chatData.currentUserName,
              currentUserName: chatData.peerUserName,
              shipmentId: chatData.shipmentId,
              currentUserImageUrl: chatData.peerImageUrl,
              conversionId: chatData.conversionId,
              type: chatData.type,
            );
          }
          Navigator.pushReplacementNamed(ctx, ChatScreen.id,
              arguments: finalChatData);
          break;
        default:
          isValid
              ? Navigator.pushReplacementNamed(
                  ctx,
                  Home.id,
                )
              : Navigator.pushReplacementNamed(
                  ctx,
                  OnBoarding.id,
                );
      }
    }
  }

  void setFrontIdImageLoading(bool value) {
    _frontIdImageLoading = value;
    notifyListeners();
  }

  void setBackIdImageLoading(bool value) {
    _backIdImageLoading = value;
    notifyListeners();
  }

  void configLocalNotification(
      Function(NotificationResponse) onSelectedNotificationCallback) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'org.weevo.merchant',
      'weevo merchant',
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectedNotificationCallback);
  }

  void showNotification(RemoteMessage remoteMessage) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'org.emarketingo.weevo',
      'Weevo App',
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'org.emarketingo.weevo',
      'Weevo App',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.max,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    FlutterRingtonePlayer().play(
        android: AndroidSounds.notification, ios: IosSounds.receivedMessage);
    await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        remoteMessage.notification?.title,
        remoteMessage.notification?.body,
        platformChannelSpecifics,
        payload: null);
  }

  // Future<String> _downloadAndSaveFile(String url, String fileName) async {
  //   if (url.isNotEmpty) {
  //     final Directory directory = await getApplicationDocumentsDirectory();
  //     final String filePath = '${directory.path}/$fileName';
  //     final Response response =
  //         await HttpHelper.instance.httpGet(url, false, hasBase: false);
  //     final File file = File(filePath);
  //     await file.writeAsBytes(response.bodyBytes);
  //     return filePath;
  //   } else {
  //     return null;
  //   }
  // }

  Future<void> getServerKey() async {
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    try {
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson({
            "type": "service_account",
            "project_id": "weevo-bfa67",
            "private_key_id": "a869e38765348eced08b59f61f98b0cd812b6cba",
            "private_key":
                "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCsbvg2TjvyfwwG\ncNmCbYb1nnUDCs8NUGBS5A6Sq+i8+Wpvh00QwkUvu3wczYrRytWRkBMP4hINueDI\ngbxI06LU6FQclv7T9Pv9FM0SXFZwe1IoM034FSsESBm+VJgzB7ab4eFbsDDgiiU0\nKl2gCHbVV4kAq06yNdPqWiQhInSORiDpvZSjJ6jfQFleGOloHUhGelGDrgYi64qq\nb1TcfDjUX8ssgjrOt+y41KbGjAKoY1LGe3ppopgpGbilPd/daHWwH+Y3CjgN3yFl\nwFIaTlxG9cs+l1vbh0+WcnhAPyi0i5A0yaqAQDlPXmLS9zApLyNSz1rzZbEA6CfE\ne871CumBAgMBAAECggEAAR1rkfBSD2iWY5FFusPqCDsIzyb5/UBMiySp2nVtmRE0\nyLlTfH0BFQStkgMbN22MEXegw+zGiJuv0iQSm1bw+dbxukiYp7axDWsdw1VhArOt\nbZCdW7IJV+r+bZ5e6I+PdPUSL7VVL5J9GJgAiHkdiZYaDuzMorbZ4q1ICAXQwp27\nOihEKiqP4bNrvW/Tax1Vr61Gy3vm0FOIThd/ki5b/sJnEIdxTFNUf8u4UTd9l5Zs\n1yR/T+C9/L5mvtxq6kXEA3CDGGhELq6hRceNmE+vMMlnfDCRDrCs7BXOONTXAUGj\nWvjdyq0z2cOU93IpodLu7fGloGThOQNU9SN+XgSS9QKBgQDuVzg1OzMI1Y7BCVtt\nu20rEsq1751p4yvW/Gt/BIeDbXlCZhXUSisiN0JACwlxpecDDNb6tNqzyV+esBnJ\n9qvr3SHRmMmg4rqePmjTFK4+HvrHZ1W/XYoX7CkdfJkBbNxdlE57b8LSQ7I8MzZ7\nvIlv1c6HxqEbjNoIjsG9NZTpLQKBgQC5NaPWdd1WU4RSL9k1oakiyHm0y2AGSYIA\nVET7pPLw1kXxLgcC00+6klrnc0gU0FUWJBFFB6o4W0Nld2Ik48H0LZi3etfe8KfJ\ncD6m01BfHhsr9W54PYI1i1acYXDJbkMkXPycPCRG5VnZlKY6GKI5reQ8uMVrYUtO\nzYs+5k/OJQKBgAnUgRX49hbkL/oYN7Qj6dG/+apdUqG+Y91/FbPsbOZnynuJmFbk\nJDlKDCp2ChKs5AVFL0yxzt9ha9cwri+dQ+P7f9yUL6S6FTZXnp0uGi2nu3Ij+e5l\nnj90VxHHRMxBQCl/52jB6Egh0KUY+6NI2GZLbDQ/Zf+r5IY71RPHtPeVAoGAHq3r\n/dJ4X5xmBtc2O9QTmFdtEa2+skvq5PMQmj6wn4RfAZyGPMmUI2uq8zv9bLU14v0G\nf1DNuZgkieJEt6eisTf8XChVKfDjWlLljezjG155UcbODczijMwQBMd/T16ccKGW\nlqq/t562S3x8LJN4C+XqMMTKrwbm2p7hugGcpqECgYEAm0Umy0pJyLKXGKdeQcM5\nuP6JAIz0neQvCy3Hf4M2kDPLN/jnUQBUQAso7LjkqoZZgO1P7JiclLEP6uJuVcga\n0L1d6K7gGS7C2A6KKVvEL4FH3681uglSfC6dTprMVzvp1cl+4X0uoHoYMaq1U1sF\n5CtJNZqlZE6dbCZmpLeXDQM=\n-----END PRIVATE KEY-----\n",
            "client_email":
                "firebase-adminsdk-r4y79@weevo-bfa67.iam.gserviceaccount.com",
            "client_id": "107215847941644970026",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url":
                "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url":
                "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-r4y79%40weevo-bfa67.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          }),
          scopes);
      final serverKey = client.credentials.accessToken.data;
      Preferences.instance.setFcmAccessToken(serverKey);
      log('Server key -> $serverKey');
    } catch (e) {
      log('fcm error -> ${e.toString()}');
      log(e.toString());
    }
  }

  Future<void> sendNotification(
      {required Map<String, dynamic> data,
      required String toToken,
      required String screenTo,
      required String title,
      String? image,
      required String body,
      required String type}) async {
    const String firebaseProjectName = 'weevo-bfa67';
    log('SEND');
    log('Fcm access token -> ${Preferences.instance.getFCMAccessToken}');
    data.addAll(
      {
        'type': type,
        'screen_to': screenTo,
      },
    );
    try {
      log('TOKKKEN : $toToken');
      await DioFactory.postData(
        url:
            'https://fcm.googleapis.com/v1/projects/$firebaseProjectName/messages:send',
        data: {
          "message": {
            "token": toToken,
            "notification": {
              "title": title,
              "body": body,
              "image": image,
            },
            'data': data,
            "android": {
              "notification": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "sound": "default"
              },
              "priority": "high"
            }
          }
        },
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Preferences.instance.getFCMAccessToken}',
        },
      );
    } on dio.DioException catch (e) {
      log('Notification error -> ${e.response?.data() ?? e.toString()}');
    }
  }

  Future<void> sendBetterOfferNotification(
      {required Map<String, dynamic> data,
      required String toToken,
      required String screenTo,
      required String title,
      String? image,
      required int betterOffer,
      required int hasOffer,
      required String body,
      required String type}) async {
    const String firebaseProjectName = 'weevo-bfa67';
    log('SEND');
    data.addAll(
      {
        'type': type,
        'screen_to': screenTo,
        'better_offer': betterOffer.toString(),
        'has_offer': hasOffer.toString(),
      },
    );
    await DioFactory.postData(
      url:
          'https://fcm.googleapis.com/v1/projects/$firebaseProjectName/messages:send',
      data: {
        "message": {
          "token": toToken,
          "notification": {
            "title": title,
            "body": body,
            "image": image,
          },
          'data': data,
          "android": {
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "sound": "default"
            },
            "priority": "high"
          }
        }
      },
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Preferences.instance.getFCMAccessToken}',
      },
    );
  }

  void initialFCM(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage m) async {
      log('m.data -> ${m.data}');
      log('m -> $m');
      log('m -> ${m.notification?.title}');
      log('m -> ${m.notification?.body}');

      if (await freshChat.Freshchat.isFreshchatNotification(m.data)) {
        log("is Freshchat notification");
        freshChat.Freshchat.handlePushNotification(m.data);
      }
      final notification = m.notification;
      if (notification != null) {
        if (m.data['type'] == 'rating') {
          MagicRouter.navigateAndPopAll(
              RatingDialog(model: ShipmentTrackingModel.fromJson(m.data)));
        } else if (m.data['type'] == 'wasully_rating') {
          MagicRouter.navigateAndPopAll(WasullyRatingDialog(
              model: ShipmentTrackingModel.fromJson(m.data)));

          // log('Wasully rating dialog');
          // MagicRouter.navigateAndPopAll(WasullyRatingDialog(
          //   model: ShipmentTrackingModel.fromJson(
          //     json.decode(
          //       m.data['data'],
          //     ),
          //   ),
          // ));
          // // showBottomSheet(
          // //   context: navigator.currentContext!,
          // //   shape: RoundedRectangleBorder(
          // //       borderRadius: BorderRadius.only(
          // //     topLeft: Radius.circular(20.0),
          // //     topRight: Radius.circular(20.0),
          // //   )),
          // //   builder: (context) => WasullyRatingDialog(
          // //     model: ShipmentTrackingModel.fromJson(
          // //       json.decode(
          // //         m.data['data'],
          // //       ),
          // //     ),
          // //   ),
          // // );
        } else {
          configLocalNotification((payload) {
            switch (m.data['screen_to']) {
              case productScreen:
                Navigator.pushNamed(context, MerchantWarehouse.id);
                break;
              case wallet:
                Navigator.pushReplacementNamed(context, Wallet.id);
                break;
              case homeScreen:
                Navigator.pushNamed(context, Home.id);
                break;
              case shipmentOffers:
                Navigator.pushNamed(
                  context,
                  ChooseCourier.id,
                  arguments: ShipmentNotification.fromMap(m.data),
                );
                break;
              case shipmentDecline:
                Navigator.pushNamed(
                  context,
                  ChooseCourier.id,
                  arguments: ShipmentNotification.fromMap(m.data),
                );
                break;
              case shipmentScreen:
                if (ShipmentTrackingModel.fromJson(m.data).hasChildren == 0) {
                  MagicRouter.navigateAndPop(ShipmentDetailsScreen(
                    id: ShipmentTrackingModel.fromJson(
                            json.decode(m.data['data']))
                        .shipmentId!,
                  ));
                } else {
                  MagicRouter.navigateAndPop(
                    BulkShipmentDetailsScreen(
                        shipmentId: ShipmentTrackingModel.fromJson(
                                json.decode(m.data['data']))
                            .shipmentId!),
                  );
                }
                break;
              case walletScreen:
                Navigator.pushNamed(context, Wallet.id);
                break;
              case handleShipmentScreen:
                Navigator.pushNamed(context, HandleShipment.id,
                    arguments: ShipmentTrackingModel.fromJson(m.data));
                break;
              case chatScreen:
                ChatData chatData = ChatData.fromJson(m.data);
                ChatData chatData0;
                if (chatData.currentUserNationalId == getNationalId) {
                  chatData0 = ChatData(
                    chatData.currentPhoneNumber,
                    chatData.peerPhoneNumber,
                    currentUserNationalId: chatData.currentUserNationalId,
                    peerNationalId: chatData.peerNationalId,
                    currentUserId: chatData.currentUserId,
                    peerId: chatData.peerId,
                    peerImageUrl: chatData.peerImageUrl,
                    peerUserName: chatData.peerUserName,
                    shipmentId: chatData.shipmentId,
                    currentUserName: chatData.currentUserName,
                    currentUserImageUrl: chatData.currentUserImageUrl,
                    conversionId: chatData.conversionId,
                    type: chatData.type,
                  );
                } else {
                  chatData0 = ChatData(
                    chatData.peerPhoneNumber,
                    chatData.currentPhoneNumber,
                    currentUserNationalId: chatData.peerNationalId,
                    peerNationalId: chatData.currentUserNationalId,
                    currentUserId: chatData.peerId,
                    peerId: chatData.currentUserId,
                    peerImageUrl: chatData.currentUserImageUrl,
                    peerUserName: chatData.currentUserName,
                    currentUserName: chatData.peerUserName,
                    shipmentId: chatData.shipmentId,
                    currentUserImageUrl: chatData.peerImageUrl,
                    conversionId: chatData.conversionId,
                    type: chatData.type,
                  );
                }
                Navigator.pushNamed(context, ChatScreen.id,
                    arguments: chatData0);
                break;
              default:
                isValid
                    ? Navigator.pushReplacementNamed(
                        context,
                        Home.id,
                      )
                    : Navigator.pushReplacementNamed(
                        context,
                        OnBoarding.id,
                      );
            }
          });
        }
        if (_currentWidget != 'ChatScreen' && _currentWidget != 'Messages') {
          showNotification(m);
        }
      }
    });
  }

  void initialOpenedAppFCM(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage m) async {
      log('m.data -> ${m.data}');
      log('m -> $m');
      if (await freshChat.Freshchat.isFreshchatNotification(m.data)) {
        log("is Freshchat notification");
        freshChat.Freshchat.handlePushNotification(m.data);
      }
      final notification = m.notification;
      if (notification != null) {
        if (m.data['type'] == 'rating') {
          MagicRouter.navigateAndPopAll(
            RatingDialog(
              model: ShipmentTrackingModel.fromJson(m.data),
            ),
          );
        } else if (m.data['type'] == 'wasully_rating') {
          log('Wasully rating dialog');
          MagicRouter.navigateAndPopAll(WasullyRatingDialog(
            model: ShipmentTrackingModel.fromJson(m.data),
          ));
          // showBottomSheet(
          //   context: navigator.currentContext!,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(20.0),
          //     topRight: Radius.circular(20.0),
          //   )),
          //   builder: (context) => WasullyRatingDialog(
          //     model: ShipmentTrackingModel.fromJson(
          //       json.decode(
          //         m.data['data'],
          //       ),
          //     ),
          //   ),
          // );
        } else {
          configLocalNotification((response) {
            switch (m.data['screen_to']) {
              case productScreen:
                Navigator.pushNamed(context, MerchantWarehouse.id);
                break;
              case wallet:
                Navigator.pushReplacementNamed(context, Wallet.id);
                break;
              case homeScreen:
                Navigator.pushNamed(context, Home.id);
                break;
              case shipmentOffers:
                log('${m.data}');
                Navigator.pushNamed(
                  context,
                  ChooseCourier.id,
                  arguments: ShipmentNotification.fromMap(m.data),
                );
                break;
              case shipmentDecline:
                Navigator.pushNamed(
                  context,
                  ChooseCourier.id,
                  arguments: ShipmentNotification.fromMap(m.data),
                );
                break;
              case shipmentScreen:
                if (ShipmentTrackingModel.fromJson(m.data).hasChildren == 0) {
                  MagicRouter.navigateAndPop(ShipmentDetailsScreen(
                    id: ShipmentTrackingModel.fromJson(
                            json.decode(m.data['data']))
                        .shipmentId!,
                  ));
                } else {
                  MagicRouter.navigateAndPop(
                    BulkShipmentDetailsScreen(
                        shipmentId: ShipmentTrackingModel.fromJson(
                                json.decode(m.data['data']))
                            .shipmentId!),
                  );
                }
                break;
              case walletScreen:
                Navigator.pushNamed(context, Wallet.id);
                break;
              case handleShipmentScreen:
                log(m.data['screen_to']);
                Navigator.pushNamed(context, HandleShipment.id,
                    arguments: ShipmentTrackingModel.fromJson(m.data));
                break;
              case chatScreen:
                ChatData chatData = ChatData.fromJson(m.data);
                ChatData chatData0;
                if (chatData.currentUserNationalId == getNationalId) {
                  chatData0 = ChatData(
                    chatData.currentPhoneNumber,
                    chatData.peerPhoneNumber,
                    currentUserNationalId: chatData.currentUserNationalId,
                    peerNationalId: chatData.peerNationalId,
                    currentUserId: chatData.currentUserId,
                    peerId: chatData.peerId,
                    peerImageUrl: chatData.peerImageUrl,
                    peerUserName: chatData.peerUserName,
                    shipmentId: chatData.shipmentId,
                    currentUserName: chatData.currentUserName,
                    currentUserImageUrl: chatData.currentUserImageUrl,
                    conversionId: chatData.conversionId,
                    type: chatData.type,
                  );
                } else {
                  chatData0 = ChatData(
                    chatData.peerPhoneNumber,
                    chatData.currentPhoneNumber,
                    peerNationalId: chatData.currentUserNationalId,
                    currentUserNationalId: chatData.peerNationalId,
                    currentUserId: chatData.peerId,
                    peerId: chatData.currentUserId,
                    peerImageUrl: chatData.currentUserImageUrl,
                    peerUserName: chatData.currentUserName,
                    currentUserName: chatData.peerUserName,
                    shipmentId: chatData.shipmentId,
                    currentUserImageUrl: chatData.peerImageUrl,
                    conversionId: chatData.conversionId,
                    type: chatData.type,
                  );
                }
                Navigator.pushNamed(context, ChatScreen.id,
                    arguments: chatData0);
                break;
              default:
                isValid
                    ? Navigator.pushReplacementNamed(
                        context,
                        Home.id,
                      )
                    : Navigator.pushReplacementNamed(
                        context,
                        OnBoarding.id,
                      );
            }
          });
        }
        if (_currentWidget != 'ChatScreen' && _currentWidget != 'Messages') {
          showNotification(m);
        }
      }
      notifyListeners();
    });
  }

  String? get appVersion => _preferences!.getCurrentAppVersionNumber;

  String? get lastName => _lastName;

  String? get userPhoto => _userPhoto;

  String? get userPhone => _userPhone;

  String? get userEmail => _userEmail;

  String? get userType => _userType;

  String? get userPassword => _userPassword;

  String? get nationalIdNumber => _nationalIdNumber;

  String? get nationalIdPhotoBack => _nationalIdPhotoBack;

  String? get nationalIdPhotoFront => _nationalIdPhotoFront;

  String? get commercialActivity => _commercialActivity;

  bool get backIdImageLoading => _backIdImageLoading;

  NetworkState get groupBannersState => _groupBannersState;

  List<HomeBanner>? get homeBanner => _homeBanner;
}
