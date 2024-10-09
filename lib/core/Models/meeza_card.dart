import 'meeza_upg.dart';

class MeezaCard {
  String? message;
  String? status;
  MeezaUpgResponse? upgResponse;

  MeezaCard({this.message, this.status, this.upgResponse});

  MeezaCard.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    upgResponse = json['upgResponse'] != null
        ? MeezaUpgResponse.fromJson(json['upgResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (upgResponse != null) {
      data['upgResponse'] = upgResponse?.toJson();
    }
    return data;
  }
}
