class MerchantCriticalUpdate {
  String? message;
  bool? shouldUpdate;

  MerchantCriticalUpdate({
    this.message,
    this.shouldUpdate,
  });

  factory MerchantCriticalUpdate.fromJson(Map<String, dynamic> map) =>
      MerchantCriticalUpdate(
          message: map['message'], shouldUpdate: map['should_update']);

  Map<String, dynamic> tojson() => {
        'message': message,
        'should_update': shouldUpdate,
      };
}
