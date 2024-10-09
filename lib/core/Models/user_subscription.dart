class UserSubscription {
  int? id;
  String? subscriberType;
  int? subscriberId;
  int? planId;
  int? cachedTransactionId;
  String? slug;
  int? active;
  String? name;
  String? description;
  String? trialEndsAt;
  String? startsAt;
  String? endsAt;
  String? cancelsAt;
  String? canceledAt;
  String? timezone;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? onTrial;
  bool? ended;
  bool? canceled;

  UserSubscription(
      {this.id,
      this.subscriberType,
      this.subscriberId,
      this.planId,
      this.cachedTransactionId,
      this.slug,
      this.active,
      this.name,
      this.description,
      this.trialEndsAt,
      this.startsAt,
      this.endsAt,
      this.cancelsAt,
      this.canceledAt,
      this.timezone,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.onTrial,
      this.ended,
      this.canceled});

  UserSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriberType = json['subscriber_type'];
    subscriberId = json['subscriber_id'];
    planId = json['plan_id'];
    cachedTransactionId = json['cached_transaction_id'];
    slug = json['slug'];
    active = json['active'];
    name = json['name'];
    description = json['description'];
    trialEndsAt = json['trial_ends_at'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
    cancelsAt = json['cancels_at'];
    canceledAt = json['canceled_at'];
    timezone = json['timezone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    onTrial = json['on_trial'];
    ended = json['ended'];
    canceled = json['canceled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subscriber_type'] = subscriberType;
    data['subscriber_id'] = subscriberId;
    data['plan_id'] = planId;
    data['cached_transaction_id'] = cachedTransactionId;
    data['slug'] = slug;
    data['active'] = active;
    data['name'] = name;
    data['description'] = description;
    data['trial_ends_at'] = trialEndsAt;
    data['starts_at'] = startsAt;
    data['ends_at'] = endsAt;
    data['cancels_at'] = cancelsAt;
    data['canceled_at'] = canceledAt;
    data['timezone'] = timezone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['on_trial'] = onTrial;
    data['ended'] = ended;
    data['canceled'] = canceled;
    return data;
  }
}
