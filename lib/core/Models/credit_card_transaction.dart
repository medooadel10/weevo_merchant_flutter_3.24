import 'credit_card_subscription.dart';

class CreditCardTransaction {
  int? id;
  String? amount;
  String? subscriptionId;
  String? mpgSessionVersion;
  String? mpgSessionId;
  String? mpgSuccessIndicator;
  String? upgTransactionRef;
  String? upgSystemRef;
  String? paymentMethod;
  int? isPaid;
  String? paidAt;
  String? notes;
  String? createdAt;
  String? updatedAt;
  CreditCardSubscription? subscription;

  CreditCardTransaction(
      {this.id,
      this.amount,
      this.subscriptionId,
      this.mpgSessionVersion,
      this.mpgSessionId,
      this.mpgSuccessIndicator,
      this.upgTransactionRef,
      this.upgSystemRef,
      this.paymentMethod,
      this.isPaid,
      this.paidAt,
      this.notes,
      this.createdAt,
      this.updatedAt,
      this.subscription});

  CreditCardTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    subscriptionId = json['subscription_id'];
    mpgSessionVersion = json['mpg_session_version'];
    mpgSessionId = json['mpg_session_id'];
    mpgSuccessIndicator = json['mpg_success_indicator'];
    upgTransactionRef = json['upg_transaction_ref'];
    upgSystemRef = json['upg_system_ref'];
    paymentMethod = json['payment_method'];
    isPaid = json['is_paid'];
    paidAt = json['paid_at'];
    notes = json['notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subscription = json['subscription'] != String
        ? CreditCardSubscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['subscription_id'] = subscriptionId;
    data['mpg_session_version'] = mpgSessionVersion;
    data['mpg_session_id'] = mpgSessionId;
    data['mpg_success_indicator'] = mpgSuccessIndicator;
    data['upg_transaction_ref'] = upgTransactionRef;
    data['upg_system_ref'] = upgSystemRef;
    data['payment_method'] = paymentMethod;
    data['is_paid'] = isPaid;
    data['paid_at'] = paidAt;
    data['notes'] = notes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (subscription != null) {
      data['subscription'] = subscription?.toJson();
    }
    return data;
  }
}
