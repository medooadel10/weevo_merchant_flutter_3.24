import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Dialogs/action_dialog.dart';
import '../Models/update_user_datat.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';

class UpdateProfileProvider with ChangeNotifier {
  bool _profileImageLoading = false;
  UpdateUserData? _updatedUser;
  NetworkState? _updatePhoneState;
  NetworkState? _updatePersonalInfoState;
  NetworkState? _updateEmailState;
  NetworkState? _updatePasswordState;
  NetworkState? _updateCurrentAddressIdState;
  NetworkState? _getUserDataByTokenState;
  final Preferences _preferences = Preferences.instance;

  NetworkState? get updatePhoneState => _updatePhoneState;

  UpdateUserData? get updatedUser => _updatedUser;

  NetworkState? get updateCurrentAddressIdState => _updateCurrentAddressIdState;

  NetworkState? get updatePersonalInfoState => _updatePersonalInfoState;

  Future<void> updateEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    try {
      _updateEmailState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'email': newEmail,
          'password_verification': currentPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _updateEmailState = NetworkState.SUCCESS;
      } else {
        _updateEmailState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  bool get profileImageLoading => _profileImageLoading;

  void setImageLoading(bool value) {
    _profileImageLoading = value;
    notifyListeners();
  }

  NetworkState? get getUserDataByTokenState => _getUserDataByTokenState;

  Future<void> getUserDataByToken() async {
    try {
      _getUserDataByTokenState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'me',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log('getUserDataByToken -> ${json.decode(r.body)}');
        if (json.decode(r.body)['address_book_default_id'] != null) {
          await _preferences
              .setAddressId(json.decode(r.body)['address_book_default_id']);
          log('addressId -> ${_preferences.getAddressId}');
          log('address_book_default_id -> ${json.decode(r.body)['address_book_default_id']}');
        }
        _getUserDataByTokenState = NetworkState.SUCCESS;
      } else {
        _getUserDataByTokenState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateCurrentAddressId({
    required int? addressId,
    required String currentPassword,
  }) async {
    try {
      _updateCurrentAddressIdState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'address_book_default_id': addressId,
          'password_verification': currentPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _updateCurrentAddressIdState = NetworkState.SUCCESS;
      } else {
        _updateCurrentAddressIdState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updatePassword({
    required String password,
    required String currentPassword,
  }) async {
    try {
      _updatePasswordState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'password': password,
          'password_verification': currentPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _updatePasswordState = NetworkState.SUCCESS;
      } else {
        _updatePasswordState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updatePhone({
    required BuildContext context,
    required VoidCallback onApprove,
    required String phone,
  }) async {
    try {
      _updatePhoneState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'phone': phone,
          'password_verification': _preferences.getPassword,
        },
      );
      log('body response -> ${r.body}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        UpdateUserData updateData =
            UpdateUserData.fromJson(json.decode(r.body));
        await _preferences.setPhoneNumber(updateData.phone!);
        _updatePhoneState = NetworkState.SUCCESS;
      } else {
        String msg = json.decode(r.body)['errors']['phone'][0];
        if (msg == 'The phone has already been taken.') {
          showDialog(
              context: navigator.currentContext!,
              builder: (context) => ActionDialog(
                    content: 'الرقم موجود بالفعل',
                    onApproveClick: onApprove,
                    approveAction: 'حسناً',
                  ));
        }
        _updatePhoneState = NetworkState.ERROR;
      }
    } catch (e) {
      log('update phone error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> updatePersonalInfo({
    required String firstName,
    required String lastName,
    required String photo,
    required String currentPassword,
  }) async {
    try {
      _updatePersonalInfoState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'photo': photo,
          'password_verification': currentPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _updatedUser = UpdateUserData.fromJson(jsonDecode(r.body));
        _updatePersonalInfoState = NetworkState.SUCCESS;
      } else {
        log(jsonDecode(r.body));
        _updatePersonalInfoState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  NetworkState? get updateEmailState => _updateEmailState;

  NetworkState? get updatePasswordState => _updatePasswordState;
}
