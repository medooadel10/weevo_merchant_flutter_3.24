class RegSubscription {
  String? name;
  bool? active;
  int? planId;
  String? trialEndsAt;
  String? startsAt;
  String? endsAt;
  int? subscriberId;
  String? subscriberType;
  String? slug;
  String? updatedAt;
  String? createdAt;
  int? id;
  bool? onTrial;
  bool? ended;
  bool? canceled;
  String? description;

  RegSubscription(
      {this.name,
      this.active,
      this.planId,
      this.trialEndsAt,
      this.startsAt,
      this.endsAt,
      this.subscriberId,
      this.subscriberType,
      this.slug,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.onTrial,
      this.ended,
      this.canceled,
      this.description});

  RegSubscription.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    active = json['active'];
    planId = json['plan_id'];
    trialEndsAt = json['trial_ends_at'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
    subscriberId = json['subscriber_id'];
    subscriberType = json['subscriber_type'];
    slug = json['slug'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    onTrial = json['on_trial'];
    ended = json['ended'];
    canceled = json['canceled'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['active'] = active;
    data['plan_id'] = planId;
    data['trial_ends_at'] = trialEndsAt;
    data['starts_at'] = startsAt;
    data['ends_at'] = endsAt;
    data['subscriber_id'] = subscriberId;
    data['subscriber_type'] = subscriberType;
    data['slug'] = slug;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['on_trial'] = onTrial;
    data['ended'] = ended;
    data['canceled'] = canceled;
    data['description'] = description;
    return data;
  }
}
