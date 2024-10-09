import 'user.dart';

class UserData {
  User? user;
  String? accessToken;
  String? tokenType;
  String? expiresAt;

  UserData({
    this.user,
    this.accessToken,
    this.tokenType,
    this.expiresAt,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user?.toJson();
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    return data;
  }
}
