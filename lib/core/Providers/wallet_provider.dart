import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weevo_merchant_upgrade/core/Models/transaction.dart';

import '../../core_new/networking/api_constants.dart';
import '../../features/Screens/deposit_done.dart';
import '../../features/Widgets/credit_record/credit_approved_requests.dart';
import '../../features/Widgets/credit_record/credit_deduction_request.dart';
import '../../features/Widgets/credit_record/credit_pending_requests.dart';
import '../../features/Widgets/credit_record/credit_recent.dart';
import '../../features/Widgets/wallet_home.dart';
import '../../features/Widgets/wallet_withdrawal.dart';
import '../../features/Widgets/withdraw_sub_widget/withdrawal_add_amount.dart';
import '../../features/Widgets/withdraw_sub_widget/withdrawal_bank_account.dart';
import '../../features/Widgets/withdraw_sub_widget/withdrawal_e_wallet.dart';
import '../../features/Widgets/withdraw_sub_widget/withdrawal_meza_card.dart';
import '../../features/Widgets/withdraw_sub_widget/withdrawal_payment.dart';
import '../../features/Widgets/withdrawal_record/approved_withdrawal_request.dart';
import '../../features/Widgets/withdrawal_record/declined_withdrawal_request.dart';
import '../../features/Widgets/withdrawal_record/pending_withdrawal_request.dart';
import '../../features/Widgets/withdrawal_record/transferred_withdrawal_request.dart';
import '../../features/Widgets/withdrawal_record/withdrawal_recent.dart';
import '../Models/bank_branch_model.dart';
import '../Models/bank_model.dart';
import '../Models/transaction_data.dart';
import '../Models/update_user.dart';
import '../Models/wallet_account_model.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';

class WalletProvider with ChangeNotifier {
  int _mainIndex = 0;
  int _withdrawIndex = 0;
  int _creditMainIndex = 0;
  int _withdrawMainIndex = 0;
  Widget _mainWidget = const WalletHome();
  Widget _withdrawWidget = const WithdrawalAddAmount();
  Widget _creditMainWidget = const CreditPendingRequests();
  Widget _withdrawMainWidget = const PendingWithdrawalRequests();
  List<TransactionData> _pendingWithdrawList = [];
  List<TransactionData> _approvedWithdrawList = [];
  List<TransactionData> _declinedWithdrawList = [];
  List<TransactionData> _transferredWithdrawList = [];
  List<TransactionData> _approvedCreditTransactionList = [];
  List<TransactionData> _creditDeductionList = [];
  List<TransactionData> _pendingCreditTransactionList = [];
  int? _withdrawalAmount;
  NetworkState? _state;
  NetworkState? _currentBalanceState;
  NetworkState? _pendingBalanceState;
  NetworkState? _bankAccountStatus;
  String? _currentBalance;
  String? _pendingBalance;
  int? _accountTypeIndex = 0; // assuming an initial value is appropriate
  bool _loading = false;
  final Preferences _preferences = Preferences.instance;
  String? creditApprovedDateFrom;
  String? creditApprovedDateTo;
  String? creditPendingDateFrom;
  String? creditPendingDateTo;
  String? creditDeductionDateFrom;
  String? creditDeductionDateTo;
  String? approvedWithdrawDateFrom;
  String? approvedWithdrawDateTo;
  String? pendingWithdrawDateFrom;
  String? pendingWithdrawDateTo;
  String? declinedWithdrawDateFrom;
  String? declinedWithdrawDateTo;
  String? transferredWithdrawDateFrom;
  String? transferredWithdrawDateTo;
  NetworkState? _creditPendingState;
  NetworkState? _creditDeductionState;
  NetworkState? _creditApprovedState;
  NetworkState? _pendingWithdrawState;
  NetworkState? _approvedWithdrawState;
  NetworkState? _declinedWithdrawState;
  NetworkState? _transferredWithdrawState;
  int _pendingWithdrawPage = 1;
  int _approvedWithdrawPage = 1;
  int _declinedWithdrawPage = 1;
  int _transferredWithdrawPage = 1;
  int? _pendingWithdrawLastPage;
  int? _creditDeductionLastPage;
  int? _approvedWithdrawLastPage;
  int? _declinedWithdrawLastPage;
  int? _transferredWithdrawLastPage;
  bool _pendingWithdrawPaging = false;
  bool _approvedWithdrawPaging = false;
  bool _declinedWithdrawPaging = false;
  bool _transferredWithdrawPaging = false;
  bool _pendingWithdrawEmpty = false;
  bool _approvedWithdrawEmpty = false;
  bool _declinedWithdrawEmpty = false;
  bool _transferredWithdrawEmpty = false;
  int _approvedCreditPage = 1;
  int _creditDeductionPage = 1;
  int _pendingCreditPage = 1;
  int? _approvedCreditLastPage;
  int? _pendingCreditLastPage;
  bool _pendingCreditPaging = false;
  bool _approvedCreditPaging = false;
  bool _creditDeductionPaging = false;
  bool _approvedCreditListEmpty = false;
  bool _pendingCreditListEmpty = false;
  bool _creditDeductionListEmpty = false;
  bool _changeWalletNumberFromWithdraw = false;

  bool get changeWalletNumberFromWithdraw => _changeWalletNumberFromWithdraw;

  bool get loading => _loading;

  String? get currentBalance => _currentBalance;

  NetworkState? get state => _state;

  int? get withdrawalAmount => _withdrawalAmount;

  void setWithdrawalAmount(int? value) {
    _withdrawalAmount = value;
  }

  Widget get depositWidget => _withdrawWidget;

  void setAccountTypeIndex(int? i) {
    _accountTypeIndex = i;
  }

  int? get accountTypeIndex => _accountTypeIndex;

  void setChangeWalletNumberFromWithdraw(bool v) {
    _changeWalletNumberFromWithdraw = v;
  }

  void setWithdrawIndex(int i) {
    _withdrawIndex = i;
    getCurrentWithdrawWidget();
    notifyListeners();
  }

  void setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  int get depositIndex => _withdrawIndex;
  String? errorMessage;

  resetCreditApprovedFilter() {
    creditApprovedDateFrom = null;
    creditApprovedDateTo = null;
  }

  resetCreditPendingFilter() {
    creditPendingDateFrom = null;
    creditPendingDateTo = null;
  }

  resetApprovedWithdrawFilter() {
    approvedWithdrawDateFrom = null;
    approvedWithdrawDateTo = null;
  }

  resetPendingWithdrawFilter() {
    pendingWithdrawDateFrom = null;
    pendingWithdrawDateTo = null;
  }

  resetDeclinedWithdrawFilter() {
    declinedWithdrawDateFrom = null;
    declinedWithdrawDateTo = null;
  }

  resetTransferredWithdrawFilter() {
    transferredWithdrawDateFrom = null;
    transferredWithdrawDateTo = null;
  }

  Future<void> bankAccountWithdrawal({
    required double amount,
    required String bankId,
    required String branchId,
    required String ownerName,
    required String accountNumber,
    required String accountIban,
  }) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance
          .httpPost('wallet/transactions/withdraw', true, body: {
        "cashout_type": "bank",
        "title": "bank title",
        "payload": {"reference": "1212"},
        "amount": amount,
        "bank_data": {
          "bank_id": bankId,
          "bank_branch_id": branchId,
          "account_owner": ownerName,
          "account_number": accountNumber,
          "account_iban": accountIban
        }
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.SUCCESS;
      } else {
        errorMessage = json.decode(r.body)['message'];
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> walletWithdrawal(
      {required double amount,
      required String walletOwner,
      required String walletNumber}) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/withdraw',
        true,
        body: {
          "cashout_type": "wallet",
          "title": "wallet title",
          "payload": {
            "reference": "1212",
          },
          "amount": amount,
          "wallet_data": {
            "wallet_owner": walletOwner,
            "wallet_number": walletNumber
          }
        },
      );
      log(r.body);
      log('${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.SUCCESS;
      } else {
        errorMessage = json.decode(r.body)['message'];
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> mezaWithdrawal(
      {required double amount,
      required String cardOwner,
      required String cardNumber}) async {
    try {
      _state = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpPost(
        'wallet/transactions/withdraw',
        true,
        body: {
          "cashout_type": "meeza",
          "title": "meeza title",
          "payload": {
            "reference": "1212",
          },
          "amount": 21,
          "meeza_data": {
            "card_owner": cardOwner,
            "card_number": cardNumber,
          }
        },
      );
      log(r.body);
      log('${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.SUCCESS;
      } else {
        errorMessage = json.decode(r.body)['message'];
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  NetworkState? get bankAccountStatus => _bankAccountStatus;

  void setCreditMainIndex(int i) {
    _creditMainIndex = i;
    getCreditCurrentWidget();
    notifyListeners();
  }

  int get withdrawMainIndex => _withdrawMainIndex;

  int get creditMainIndex => _creditMainIndex;

  void getCreditCurrentWidget() {
    switch (_creditMainIndex) {
      case 0:
        _creditMainWidget = const CreditPendingRequests();
        break;
      case 1:
        _creditMainWidget = const CreditApprovedRequest();
        break;
      case 2:
        _creditMainWidget = const CreditDeductionRequest();
        break;
    }
  }

  Widget get creditMainWidget => _creditMainWidget;

  Widget get withdrawMainWidget => _withdrawMainWidget;

  void setWithdrawMainIndex(int i) {
    _withdrawMainIndex = i;
    getWithdrawCurrentWidget();
    notifyListeners();
  }

  String get walletNumber => _preferences.getWeevoWalletNumber;

  String get ownerName => _preferences.getWeevoBankAccountClientName;

  String get bankIbnaNumber => _preferences.getWeevoBankAccountIbanNumber;

  String get bankBranchName => _preferences.getWeevoBankBranchName;

  String get bankName => _preferences.getWeevoBankName;

  void getWithdrawCurrentWidget() {
    switch (_withdrawMainIndex) {
      case 0:
        _withdrawMainWidget = const PendingWithdrawalRequests();
        break;
      case 1:
        _withdrawMainWidget = const ApprovedWithdrawalRequests();
        break;
      case 2:
        _withdrawMainWidget = const TransferredWithdrawalRequests();
        break;
      case 3:
        _withdrawMainWidget = const DeclinedWithdrawalRequests();
    }
  }

  Future<void> getCurrentBalance({bool? fromRefresh}) async {
    _currentBalance = '0.00';
    try {
      _currentBalanceState = NetworkState.WAITING;
      if (fromRefresh != null && fromRefresh) {
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/balance',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _currentBalance = r.body;
        _currentBalanceState = NetworkState.SUCCESS;
      } else {
        _currentBalanceState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  List<BankModel>? banks;
  List<BankBranchModel>? branches;

  Future<void> banksApi() async {
    try {
      Response r = await HttpHelper.instance.httpGet(
        '${ApiConstants.baseUrl}/api/v1/fawaterak/banks',
        true,
        hasBase: false,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        banks = (json.decode(r.body) as List)
            .map((e) => BankModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> branchesApi(int id) async {
    try {
      Response r = await HttpHelper.instance.httpGet(
        '${ApiConstants.baseUrl}/api/v1/fawaterak/bank/branches?bank_id=$id',
        true,
        hasBase: false,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        branches = (json.decode(r.body) as List)
            .map((e) => BankBranchModel.fromJson(e))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> getPendingBalance({bool? fromRefresh}) async {
    _pendingBalance = '0.00';
    try {
      _pendingBalanceState = NetworkState.WAITING;
      if (fromRefresh != null && fromRefresh) {
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/pending-balance',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _pendingBalance = r.body;
        _pendingBalanceState = NetworkState.SUCCESS;
      } else {
        _pendingBalanceState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> updateBankAccountInformation({
    required BankAccount bankAccount,
  }) async {
    _bankAccountStatus = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'bank_account_number_iban': bankAccount.accountIBAN,
          'bank_account_client_name': bankAccount.accountOwnerName,
          'bank_branch_name': bankAccount.bankBranchName,
          'bank_name': bankAccount.bankName,
          'password_verification': Preferences.instance.getPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        UpdateUser user = UpdateUser.fromJson(json.decode(r.body));
        await saveBankData(user);
        _bankAccountStatus = NetworkState.SUCCESS;
      } else {
        _bankAccountStatus = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateWalletNumber({
    required String walletNumber,
  }) async {
    _bankAccountStatus = NetworkState.WAITING;
    try {
      Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'wallet_number': walletNumber,
          'password_verification': Preferences.instance.getPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        UpdateUser user = UpdateUser.fromJson(json.decode(r.body));
        await saveWalletNumber(user.walletNumber ?? '');
        _bankAccountStatus = NetworkState.SUCCESS;
      } else {
        _bankAccountStatus = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> saveWalletNumber(String walletNumber) async {
    await _preferences.setWeevoWalletNumber(walletNumber);
  }

  Future<void> saveBankData(UpdateUser user) async {
    await _preferences
        .setWeevoBankAccountClientName(user.bankAccountClientName ?? '');
    await _preferences
        .setWeevoBankAccountIbanNumber(user.bankAccountNumberIban ?? '');
    await _preferences.setWeevoBankBranchName(user.bankBranchName ?? '');
    await _preferences.setWeevoBankName(user.bankName ?? '');
  }

  NetworkState? get currentBalanceState => _currentBalanceState;

  void setMainIndex(int i) {
    _mainIndex = i;
    getCurrentWidget();
    notifyListeners();
  }

  void getCurrentWidget() {
    switch (_mainIndex) {
      case 0:
        _mainWidget = const WalletHome();
        break;
      case 1:
        _mainWidget = const WalletDeposit();
        break;
      case 2:
        _mainWidget = const WalletCreditRecord();
        break;
      case 3:
        _mainWidget = const WalletWithdrawalRecord();
    }
  }

  void getCurrentWithdrawWidget() {
    switch (_withdrawIndex) {
      case 0:
        _withdrawWidget = const WithdrawalAddAmount();
        break;
      case 1:
        _withdrawWidget = const WithdrawPayment();
        break;
      case 2:
        _withdrawWidget = const WithdrawalBankAccount();
        break;
      case 3:
        _withdrawWidget = const WithdrawEWallet();
        break;
      case 4:
        _withdrawWidget = const WithdrawalMezaCard();
        break;
      case 5:
        _withdrawWidget = const WithdrawDone();
        break;
    }
  }

  Widget get mainWidget => _mainWidget;

  int get mainIndex => _mainIndex;

  Future<void> pendingCreditListOfTransaction({
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _creditPendingState = NetworkState.WAITING;
        _pendingCreditTransactionList = [];
        _pendingCreditPage = 1;
      }
      if (isFilter) {
        _creditPendingState = NetworkState.WAITING;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=credit&status=pending&${creditPendingDateFrom != null ? 'created_at_from=$creditPendingDateFrom&' : ''}${creditPendingDateTo != null ? 'created_at_to=$creditPendingDateTo&' : ''}page=$_pendingCreditPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _pendingCreditTransactionList.addAll(transaction.data ?? []);
        _pendingCreditLastPage = transaction.lastPage;
        _pendingCreditListEmpty = _pendingCreditTransactionList.isEmpty;
        _creditPendingState = NetworkState.SUCCESS;
      } else {
        _creditPendingState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _creditPendingState = NetworkState.ERROR;
    }
    notifyListeners();
  }

  void nextPendingCreditPage() async {
    if (_pendingCreditPage < _pendingCreditLastPage!) {
      _pendingCreditPaging = true;
      notifyListeners();
      _pendingCreditPage++;
      await pendingCreditListOfTransaction(
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _pendingCreditPaging = false;
      notifyListeners();
    }
  }

  void nextCreditDeductionPage() async {
    if (_creditDeductionPage < _creditDeductionLastPage!) {
      _creditDeductionPaging = true;
      notifyListeners();
      _creditDeductionPage++;
      await creditDeductionListOfTransaction(
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _creditDeductionPaging = false;
      notifyListeners();
    }
  }

  List<TransactionData> get creditTransactionList =>
      _pendingCreditTransactionList;

  void nextApprovedCreditPage() async {
    if (_approvedCreditPage < _approvedCreditLastPage!) {
      _approvedCreditPaging = true;
      notifyListeners();
      _approvedCreditPage++;
      await approvedCreditListOfTransaction(
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _approvedCreditPaging = false;
      notifyListeners();
    }
  }

  Future<void> clearApprovedCreditList() async {
    creditApprovedDateFrom = null;
    creditApprovedDateTo = null;
    _approvedCreditTransactionList.clear();
    notifyListeners();
    _approvedCreditPage = 1;
    await approvedCreditListOfTransaction(
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  Future<void> clearPendingCreditList() async {
    creditPendingDateFrom = null;
    creditPendingDateTo = null;
    _pendingCreditTransactionList.clear();
    notifyListeners();
    _pendingCreditPage = 1;
    await pendingCreditListOfTransaction(
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  Future<void> clearCreditDeductionList() async {
    creditDeductionDateFrom = null;
    creditDeductionDateTo = null;
    _creditDeductionList.clear();
    notifyListeners();
    _creditDeductionPage = 1;
    await creditDeductionListOfTransaction(
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  List<TransactionData> get creditDeductionList => _creditDeductionList;

  Future<void> approvedCreditListOfTransaction({
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _approvedCreditTransactionList = [];
        _creditApprovedState = NetworkState.WAITING;
        _approvedCreditPage = 1;
      }
      if (isFilter) {
        _creditApprovedState = NetworkState.WAITING;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=credit&status=approved&${creditApprovedDateFrom != null ? 'created_at_from=$creditApprovedDateFrom&' : ''}${creditApprovedDateTo != null ? 'created_at_to=$creditApprovedDateTo&' : ''}page=$_approvedCreditPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _approvedCreditTransactionList.addAll(transaction.data ?? []);
        _approvedCreditLastPage = transaction.lastPage;
        _approvedCreditListEmpty = _approvedCreditTransactionList.isEmpty;
        _creditApprovedState = NetworkState.SUCCESS;
      } else {
        _creditApprovedState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _creditApprovedState = NetworkState.ERROR;
    }
    notifyListeners();
  }

  Future<void> creditDeductionListOfTransaction({
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _creditDeductionList = [];
        _creditDeductionState = NetworkState.WAITING;
        _creditDeductionPage = 1;
      }
      if (isFilter) {
        _creditDeductionState = NetworkState.WAITING;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debit&${creditDeductionDateFrom != null ? 'created_at_from=$creditDeductionDateFrom&' : ''}${creditDeductionDateTo != null ? 'created_at_to=$creditDeductionDateFrom&' : ''}page=$_creditDeductionPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        log('${transaction.data}');
        _creditDeductionList.addAll(transaction.data ?? []);
        _creditDeductionLastPage = transaction.lastPage;
        _creditDeductionListEmpty = _creditDeductionList.isEmpty;
        _creditDeductionState = NetworkState.SUCCESS;
      } else {
        _creditDeductionState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  bool get pendingCreditListEmpty => _pendingCreditListEmpty;

  bool get approvedCreditListEmpty => _approvedCreditListEmpty;

  bool get approvedCreditPaging => _approvedCreditPaging;

  bool get pendingCreditPaging => _pendingCreditPaging;

  int? get pendingCreditLastPage => _pendingCreditLastPage;

  int? get approvedCreditLastPage => _approvedCreditLastPage;

  int get pendingCreditPage => _pendingCreditPage;

  int get approvedCreditPage => _approvedCreditPage;

  bool get transferredWithdrawEmpty => _transferredWithdrawEmpty;

  bool get declinedWithdrawEmpty => _declinedWithdrawEmpty;

  bool get approvedWithdrawEmpty => _approvedWithdrawEmpty;

  bool get pendingWithdrawEmpty => _pendingWithdrawEmpty;

  bool get transferredWithdrawPaging => _transferredWithdrawPaging;

  bool get declinedWithdrawPaging => _declinedWithdrawPaging;

  bool get approvedWithdrawPaging => _approvedWithdrawPaging;

  bool get pendingWithdrawPaging => _pendingWithdrawPaging;

  int? get transferredWithdrawLastPage => _transferredWithdrawLastPage;

  int? get declinedWithdrawLastPage => _declinedWithdrawLastPage;

  int? get approvedWithdrawLastPage => _approvedWithdrawLastPage;

  int? get pendingWithdrawLastPage => _pendingWithdrawLastPage;

  int get transferredWithdrawPage => _transferredWithdrawPage;

  int get declinedWithdrawPage => _declinedWithdrawPage;

  int get approvedWithdrawPage => _approvedWithdrawPage;

  int get pendingWithdrawPage => _pendingWithdrawPage;

  NetworkState? get transferredWithdrawState => _transferredWithdrawState;

  NetworkState? get declinedWithdrawState => _declinedWithdrawState;

  NetworkState? get approvedWithdrawState => _approvedWithdrawState;

  NetworkState? get pendingWithdrawState => _pendingWithdrawState;

  NetworkState? get creditPendingState => _creditPendingState;

  List<TransactionData> get pendingCreditTransactionList =>
      _pendingCreditTransactionList;

  List<TransactionData> get approvedCreditTransactionList =>
      _approvedCreditTransactionList;

  List<TransactionData> get transferredWithdrawList => _transferredWithdrawList;

  List<TransactionData> get declinedWithdrawList => _declinedWithdrawList;

  List<TransactionData> get approvedWithdrawList => _approvedWithdrawList;

  List<TransactionData> get pendingWithdrawList => _pendingWithdrawList;

  Widget get withdrawWidget => _withdrawWidget;

  int get withdrawIndex => _withdrawIndex;

  Future<void> approvedWithdrawTransactions({
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _approvedWithdrawList = [];
        _approvedWithdrawState = NetworkState.WAITING;
        _approvedWithdrawPage = 1;
      }
      if (isFilter) {
        _approvedWithdrawState = NetworkState.WAITING;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debitWithdraw&status=approved&${approvedWithdrawDateFrom != null ? 'created_at_from=$approvedWithdrawDateFrom&' : ''}${approvedWithdrawDateTo != null ? 'created_at_to=$approvedWithdrawDateTo&' : ''}page=$_approvedWithdrawPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _approvedWithdrawList.addAll(transaction.data ?? []);
        _approvedWithdrawLastPage = transaction.lastPage;
        _approvedWithdrawEmpty = _approvedWithdrawList.isEmpty;
        _approvedWithdrawState = NetworkState.SUCCESS;
      } else {
        _approvedWithdrawState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _approvedWithdrawState = NetworkState.ERROR;
    }
    notifyListeners();
  }

  Future<void> pendingWithdrawTransactions({
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _pendingWithdrawList = [];
        _pendingWithdrawState = NetworkState.WAITING;
        _pendingWithdrawPage = 1;
      }
      if (isFilter) {
        _pendingWithdrawState = NetworkState.WAITING;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debitWithdraw&status=pending&${pendingWithdrawDateFrom != null ? 'created_at_from=$pendingWithdrawDateFrom&' : ''}${pendingWithdrawDateTo != null ? 'created_at_to=$pendingWithdrawDateTo&' : ''}page=$_pendingWithdrawPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _pendingWithdrawList.addAll(transaction.data ?? []);
        _pendingWithdrawLastPage = transaction.lastPage;
        _pendingWithdrawEmpty = _pendingWithdrawList.isEmpty;
        _pendingWithdrawState = NetworkState.SUCCESS;
      } else {
        _pendingWithdrawState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _pendingWithdrawState = NetworkState.ERROR;
    }
    notifyListeners();
  }

  Future<void> declinedWithdrawTransactions({
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _declinedWithdrawList = [];
        _declinedWithdrawState = NetworkState.WAITING;
        _declinedWithdrawPage = 1;
      }
      if (isFilter) {
        _declinedWithdrawState = NetworkState.WAITING;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debitWithdraw&status=declined&${declinedWithdrawDateFrom != null ? 'created_at_from=$declinedWithdrawDateFrom&' : ''}${declinedWithdrawDateTo != null ? 'created_at_to=$declinedWithdrawDateTo&' : ''}page=$declinedWithdrawPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _declinedWithdrawList.addAll(transaction.data ?? []);
        _declinedWithdrawLastPage = transaction.lastPage;
        _declinedWithdrawEmpty = _declinedWithdrawList.isEmpty;
        _declinedWithdrawState = NetworkState.SUCCESS;
      } else {
        _declinedWithdrawState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _declinedWithdrawState = NetworkState.ERROR;
    }
    notifyListeners();
  }

  Future<void> transferredWithdrawTransactions({
    required bool paging,
    required bool refreshing,
    required bool isFilter,
  }) async {
    try {
      if (!paging && !refreshing) {
        _transferredWithdrawList = [];
        _transferredWithdrawState = NetworkState.WAITING;
        _transferredWithdrawPage = 1;
      }
      if (isFilter) {
        _transferredWithdrawState = NetworkState.WAITING;
        notifyListeners();
      }
      Response r = await HttpHelper.instance.httpGet(
        'wallet/transactions?type=debitWithdraw&status=transferred&${transferredWithdrawDateFrom != null ? 'created_at_from=$transferredWithdrawDateFrom&' : ''}${transferredWithdrawDateTo != null ? 'created_at_to=$transferredWithdrawDateTo&' : ''}page=$_transferredWithdrawPage',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Transaction transaction = Transaction.fromJson(jsonDecode(r.body));
        _transferredWithdrawList.addAll(transaction.data ?? []);
        _transferredWithdrawLastPage = transaction.lastPage;
        _transferredWithdrawEmpty = _transferredWithdrawList.isEmpty;
        _transferredWithdrawState = NetworkState.SUCCESS;
      } else {
        _transferredWithdrawState = NetworkState.ERROR;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
      _transferredWithdrawState = NetworkState.ERROR;
    }
    notifyListeners();
  }

  Future<void> clearApprovedWithdrawList() async {
    approvedWithdrawDateFrom = null;
    approvedWithdrawDateTo = null;
    _approvedWithdrawList.clear();
    notifyListeners();
    _approvedWithdrawPage = 1;
    await approvedWithdrawTransactions(
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  Future<void> clearPendingWithdrawList() async {
    pendingWithdrawDateFrom = null;
    pendingWithdrawDateTo = null;
    _pendingWithdrawList.clear();
    notifyListeners();
    _pendingWithdrawPage = 1;
    await pendingWithdrawTransactions(
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  Future<void> clearDeclinedWithdrawList() async {
    declinedWithdrawDateFrom = null;
    declinedWithdrawDateTo = null;
    _declinedWithdrawList.clear();
    notifyListeners();
    _declinedWithdrawPage = 1;
    await declinedWithdrawTransactions(
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  Future<void> clearTransferredWithdrawList() async {
    transferredWithdrawDateFrom = null;
    transferredWithdrawDateTo = null;
    _transferredWithdrawList.clear();
    notifyListeners();
    _transferredWithdrawPage = 1;
    await transferredWithdrawTransactions(
      paging: false,
      refreshing: true,
      isFilter: false,
    );
  }

  void nextApprovedWithdrawPage() async {
    if (_approvedWithdrawPage < _approvedWithdrawLastPage!) {
      _approvedWithdrawPaging = true;
      notifyListeners();
      _approvedWithdrawPage++;
      await approvedWithdrawTransactions(
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _approvedWithdrawPaging = false;
      notifyListeners();
    }
  }

  void nextPendingWithdrawPage() async {
    if (_pendingWithdrawPage < _pendingWithdrawLastPage!) {
      _pendingWithdrawPaging = true;
      notifyListeners();
      _pendingWithdrawPage++;
      await pendingWithdrawTransactions(
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _pendingWithdrawPaging = false;
      notifyListeners();
    }
  }

  void nextDeclinedWithdrawPage() async {
    if (_declinedWithdrawPage < _declinedWithdrawLastPage!) {
      _declinedWithdrawPaging = true;
      notifyListeners();
      _declinedWithdrawPage++;
      await declinedWithdrawTransactions(
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _declinedWithdrawPaging = false;
      notifyListeners();
    }
  }

  void nextTransferredWithdrawPage() async {
    if (_transferredWithdrawPage < _transferredWithdrawLastPage!) {
      _transferredWithdrawPaging = true;
      notifyListeners();
      _transferredWithdrawPage++;
      await transferredWithdrawTransactions(
        paging: true,
        refreshing: false,
        isFilter: false,
      );
      _transferredWithdrawPaging = false;
      notifyListeners();
    }
  }

  NetworkState? get creditApprovedState => _creditApprovedState;

  NetworkState? get pendingBalanceState => _pendingBalanceState;

  String? get pendingBalance => _pendingBalance;

  NetworkState? get creditDeductionState => _creditDeductionState;

  int? get creditDeductionLastPage => _creditDeductionLastPage;

  int get creditDeductionPage => _creditDeductionPage;

  bool get creditDeductionPaging => _creditDeductionPaging;

  bool get creditDeductionListEmpty => _creditDeductionListEmpty;
}
