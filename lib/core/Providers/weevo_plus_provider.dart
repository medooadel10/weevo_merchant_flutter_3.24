import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Models/credit_card.dart';
import '../Models/e_wallet.dart';
import '../Models/meeza_card.dart';
import '../Models/payment_status.dart';
import '../Models/plan_subscription.dart';
import '../Models/plus_plan.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';

class WeevoPlusProvider with ChangeNotifier {
  NetworkState? _state;
  List<PlusPlan>? _plusPlans;
  PlanSubscription? _planSub;
  CreditCard? _creditCard;
  MeezaCard? _meezaCard;
  EWallet? _eWallet;
  PaymentStatus? _paymentStatus;

  NetworkState? get state => _state;

  Future<void> getWeevoPlans() async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'weevo-plus/get-plans',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _plusPlans = (json.decode(r.body) as List)
            .map((e) => PlusPlan.fromJson(e))
            .toList();
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> planSubscription({required int planId}) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'weevo-plus/subscribe?plan_id=$planId',
        true,
      );
      log('status -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _planSub = PlanSubscription.fromJson(json.decode(r.body));
        log('plaSub -> ${_planSub.toString()}');
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> payUsingMeezaCard({
    required String pan,
    required String expirationDate,
    required String cvv,
    required int transactionId,
  }) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'weevo-plus/pay/using-meezacard',
        true,
        body: {
          'PAN': pan,
          'DateExpiration': expirationDate,
          'cvv2': cvv,
          'transaction_id': transactionId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _meezaCard = MeezaCard.fromJson(json.decode(r.body));
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> payUsingCreditCard({required int transactionId}) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'weevo-plus/pay/using-creditcard',
        true,
        body: {
          'transaction_id': transactionId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _creditCard = CreditCard.fromJson(json.decode(r.body));
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> payUsingEwallet({
    required String mobileNumber,
    required int transactionId,
  }) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'weevo-plus/pay/using-e-wallet',
        true,
        body: {
          'MobileNumber': mobileNumber,
          'transaction_id': transactionId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _eWallet = EWallet.fromJson(json.decode(r.body));
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> checkPaymentStatus({
    required String systemReferenceNumber,
    required int transactionId,
  }) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'weevo-plus/check-upg-transaction-status',
        true,
        body: {
          'SystemReference': systemReferenceNumber,
          'transaction_id': transactionId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _paymentStatus = PaymentStatus.fromJson(json.decode(r.body));
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  PlanSubscription? get planSub => _planSub;

  EWallet? get eWallet => _eWallet;

  CreditCard? get creditCard => _creditCard;

  List<PlusPlan>? get plusPlans => _plusPlans;

  MeezaCard? get meezaCard => _meezaCard;

  PaymentStatus? get paymentStatus => _paymentStatus;
}
