import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

class Preferences {
  static late SharedPreferences _preferences;
  static final Preferences instance = Preferences._instance();
  static const String username = 'WEEVO_USER_NAME';
  static const String id = 'WEEVO_ID';
  static const String firstTime = 'first_time';
  static const String password = 'WEEVO_PASSWORD';
  static const String email = 'WEEVO_EMAIL';
  static const String phoneNumber = 'WEEVO_PHONE_NUMBER';
  static const String Rating = 'WEEVO_Rating';
  static const String photoUrl = 'WEEVO_PHOTO_URL';
  static const String accessToken = 'WEEVO_ACCESS_TOKEN';
  static const String FCMAccessToken = 'WEEVO_FCM_ACCESS_TOKEN';
  static const String fcmToken = 'WEEVO_FCM_TOKEN';
  static const String tokenType = 'WEEVO_TOKEN_TYPE';
  static const String dateOfBirth = 'WEEVO_DATE_OF_BIRTH';
  static const String expiresAt = 'WEEVO_EXPIRES_AT';
  static const String addressId = 'WEEVO_ADDRESS_ID';
  static const String notificationOn = 'WEEVO_NOTIFICATION_ON';
  static const String weevoPlusEndDate = 'WEEVO_PLUS_END_DATE';
  static const String weevoPlusPlanId = 'WEEVO_PLUS_PLAN_ID';
  static const String weevoBankAccountClientName =
      'weevo_Bank_Account_Client_Name';
  static const String weevoBankName = 'WEEVO_BANK_NAME';
  static const String weevoBankBranchName = 'WEEVO_BANK_BRANCH_NAME';
  static const String weevoWalletNumber = 'WEEVO_WALLET_NUMBER';
  static const String weevoBankAccountIbanNumber =
      'WEEVO_BANK_ACCOUNT_IBAN_NUMBER';
  static const String weevoShareFirstTime = 'WEEVO_SHARE_FIRST_TIME_';
  static const String weevoShipmentNote = 'WEEVO_SHIPMENT_NOTE_';
  static const String weevoShipmentOfferCount = 'WEEVO_SHIPMENT_OFFERS_COUNT_';
  static const String merchantVersionNumber =
      'WEEVO_MERCHANT_APP_VERSION_NUMBER';

  Preferences._instance();

  static Future<SharedPreferences> initPref() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  Future<bool> setUserId(String value) async {
    bool isSet = await _preferences.setString(id, value);
    return isSet;
  }

  Future<bool> setPassword(String value) async {
    bool isSet = await _preferences.setString(password, value);
    return isSet;
  }

  Future<bool> setAppVersionNumber(String value) async {
    bool isSet = await _preferences.setString(merchantVersionNumber, value);
    return isSet;
  }

  Future<bool> setUserName(String value) async {
    bool isSet = await _preferences.setString(username, value);
    return isSet;
  }

  Future<bool> setUserEmail(String value) async {
    bool isSet = await _preferences.setString(email, value);
    return isSet;
  }

  Future<bool> setShareFirstTime(String key, int value) async {
    bool isSet = await _preferences.setInt('$weevoShareFirstTime$key', value);
    return isSet;
  }

  Future<bool> setNotificationOn(int v) async {
    bool isSet = await _preferences.setInt(notificationOn, v);
    return isSet;
  }

  Future<bool> setFirstTime(int value) async {
    bool isSet = await _preferences.setInt(firstTime, value);
    return isSet;
  }

  Future<bool> setTokenType(String value) async {
    bool isSet = await _preferences.setString(tokenType, value);
    return isSet;
  }

  Future<bool> setExpiresAt(String value) async {
    bool isSet = await _preferences.setString(expiresAt, value);
    return isSet;
  }

  Future<bool> setUserPhotoUrl(String value) async {
    bool isSet = await _preferences.setString(photoUrl, value);
    return isSet;
  }

  Future<bool> setAccessToken(String value) async {
    bool isSet = await _preferences.setString(accessToken, value);
    return isSet;
  }

  Future<bool> setDateOfBirth(String value) async {
    bool isSet = await _preferences.setString(dateOfBirth, value);
    return isSet;
  }

  Future<bool> setFcmToken(String value) async {
    bool isSet = await _preferences.setString(fcmToken, value);
    return isSet;
  }

  Future<bool> setFcmAccessToken(String value) async {
    bool isSet = await _preferences.setString(FCMAccessToken, value);
    return isSet;
  }

  Future<bool> setPhoneNumber(String value) async {
    bool isSet = await _preferences.setString(phoneNumber, value);
    return isSet;
  }

  Future<bool> setRating(String value) async {
    bool isSet = await _preferences.setString(Rating, value);
    return isSet;
  }

  Future<bool> setWeevoPlusPlanId(String value) async {
    bool isSet = await _preferences.setString(weevoPlusPlanId, value);
    return isSet;
  }

  Future<bool> setWeevoPlusEndDate(String value) async {
    bool isSet = await _preferences.setString(weevoPlusEndDate, value);
    return isSet;
  }

  Future<bool> setWeevoBankAccountClientName(String value) async {
    bool isSet =
        await _preferences.setString(weevoBankAccountClientName, value);
    return isSet;
  }

  Future<bool> setWeevoWalletNumber(String value) async {
    bool isSet = await _preferences.setString(weevoWalletNumber, value);
    return isSet;
  }

  Future<bool> setWeevoBankAccountIbanNumber(String value) async {
    bool isSet =
        await _preferences.setString(weevoBankAccountIbanNumber, value);
    return isSet;
  }

  Future<bool> setWeevoBankBranchName(String value) async {
    bool isSet = await _preferences.setString(weevoBankBranchName, value);
    return isSet;
  }

  Future<bool> setWeevoBankName(String value) async {
    bool isSet = await _preferences.setString(weevoBankName, value);
    return isSet;
  }

  Future<bool> setShipmentNote(String key, int value) async {
    bool isSet = await _preferences.setInt('$weevoShipmentNote$key', value);
    return isSet;
  }

  Future<bool> setShipmentOfferCount(String key, int value) async {
    bool isSet =
        await _preferences.setInt('$weevoShipmentOfferCount$key', value);
    return isSet;
  }

  Future<bool> setAddressId(int value) async {
    bool isSet = await _preferences.setInt(addressId, value);
    return isSet;
  }

  Future<bool> clearUser() async {
    bool isCleared = await _preferences.clear();
    return isCleared;
  }

  String get getUserId => _preferences.getString(id) ?? '';

  String get getFcmToken => _preferences.getString(fcmToken) ?? '';

  String get getPassword => _preferences.getString(password) ?? '';

  String get getCurrentAppVersionNumber =>
      _preferences.getString(merchantVersionNumber) ?? '';

  String get getPhoneNumber => _preferences.getString(phoneNumber) ?? '';

  String get getRating => _preferences.getString(Rating) ?? '';

  String get getAccessToken => _preferences.getString(accessToken) ?? '';

  String get getFCMAccessToken => _preferences.getString(FCMAccessToken) ?? '';

  String get getDateOfBirth => _preferences.getString(dateOfBirth) ?? '';

  String get getTokenType => _preferences.getString(tokenType) ?? '';

  String get getUserName => _preferences.getString(username) ?? '';

  String get getUserEmail => _preferences.getString(email) ?? '';

  int get getAddressId => _preferences.getInt(addressId) ?? -1;

  int getWeevoShareFirstTime(String key) =>
      _preferences.getInt('$weevoShareFirstTime$key') ?? -1;

  int get getNotificationOn => _preferences.getInt(notificationOn) ?? -1;

  int get getFirstTime => _preferences.getInt(firstTime) ?? 0;

  String get getUserPhotoUrl => _preferences.getString(photoUrl) ?? '';

  String get getExpiresAt => _preferences.getString(expiresAt) ?? '';

  String get getWeevoBankName => _preferences.getString(weevoBankName) ?? '';

  String get getWeevoBankBranchName =>
      _preferences.getString(weevoBankBranchName) ?? '';

  String get getWeevoBankAccountIbanNumber =>
      _preferences.getString(weevoBankAccountIbanNumber) ?? '';

  int getWeevoShipmentNote(String key) =>
      _preferences.getInt('$weevoShipmentNote$key') ?? -1;

  int getWeevoShipmentOfferCount(String key) =>
      _preferences.getInt('$weevoShipmentOfferCount$key') ?? -1;

  String get getWeevoWalletNumber =>
      _preferences.getString(weevoWalletNumber) ?? '';

  String get getWeevoBankAccountClientName =>
      _preferences.getString(weevoBankAccountClientName) ?? '';

  String get getWeevoPlusPlanId =>
      _preferences.getString(weevoPlusPlanId) ?? '';

  String get getWeevoPlusEndDate =>
      _preferences.getString(weevoPlusEndDate) ?? '';
}
