import 'reg_subscription.dart';
import 'reg_user.dart';

class CreateUser {
  RegUser? user;
  String? accessToken;
  String? tokenType;
  String? expiresAt;
  RegSubscription? subscription;

  CreateUser(
      {this.user,
      this.accessToken,
      this.tokenType,
      this.expiresAt,
      this.subscription});

  CreateUser.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? RegUser.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
    subscription = json['subscription'] != null
        ? RegSubscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user?.toJson();
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    data['subscription'] = subscription?.toJson();
    return data;
  }
}
