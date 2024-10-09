import 'payment_status_transaction.dart';

class PaymentStatus {
  String? message;
  String? status;
  PaymentStatusTransaction? transaction;

  PaymentStatus({this.message, this.status, this.transaction});

  PaymentStatus.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    transaction = json['transaction'] != null
        ? PaymentStatusTransaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (transaction != null) {
      data['transaction'] = transaction?.toJson();
    }
    return data;
  }
}
