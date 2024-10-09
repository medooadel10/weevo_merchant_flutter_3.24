import 'weevo_plus_active_subscriptions.dart';

class WeevoPlusValidation {
  bool? hasActiveSubscription;
  List<WeevoPlusActiveSubscriptions>? activeSubscriptions;

  WeevoPlusValidation({this.hasActiveSubscription, this.activeSubscriptions});

  WeevoPlusValidation.fromJson(Map<String, dynamic> json) {
    hasActiveSubscription = json['has_active_subscription'];
    if (json['active_subscriptions'] != null) {
      activeSubscriptions = [];
      json['active_subscriptions'].forEach((v) {
        activeSubscriptions?.add(WeevoPlusActiveSubscriptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['has_active_subscription'] = hasActiveSubscription;
    if (activeSubscriptions != null) {
      data['active_subscriptions'] =
          activeSubscriptions?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
