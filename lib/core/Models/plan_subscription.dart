import 'plan_details.dart';

class PlanSubscription {
  String? name;
  int? planId;
  bool? active;
  int? subscriberId;
  String? subscriberType;
  String? slug;
  String? startsAt;
  String? endsAt;
  String? updatedAt;
  String? createdAt;
  int? id;
  int? cachedTransactionId;
  bool? onTrial;
  bool? ended;
  bool? canceled;
  String? description;
  Plan? plan;

  PlanSubscription(
      {this.name,
      this.planId,
      this.active,
      this.subscriberId,
      this.subscriberType,
      this.slug,
      this.startsAt,
      this.endsAt,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.cachedTransactionId,
      this.onTrial,
      this.ended,
      this.canceled,
      this.description,
      this.plan});

  PlanSubscription.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    planId = json['plan_id'];
    active = json['active'];
    subscriberId = json['subscriber_id'];
    subscriberType = json['subscriber_type'];
    slug = json['slug'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    cachedTransactionId = json['cached_transaction_id'];
    onTrial = json['on_trial'];
    ended = json['ended'];
    canceled = json['canceled'];
    description = json['description'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['plan_id'] = planId;
    data['active'] = active;
    data['subscriber_id'] = subscriberId;
    data['subscriber_type'] = subscriberType;
    data['slug'] = slug;
    data['starts_at'] = startsAt;
    data['ends_at'] = endsAt;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['cached_transaction_id'] = cachedTransactionId;
    data['on_trial'] = onTrial;
    data['ended'] = ended;
    data['canceled'] = canceled;
    data['description'] = description;
    if (plan != null) {
      data['plan'] = plan?.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'PlanSubscription{name: $name, planId: $planId, active: $active, subscriberId: $subscriberId, subscriberType: $subscriberType, slug: $slug, startsAt: $startsAt, endsAt: $endsAt, updatedAt: $updatedAt, createdAt: $createdAt, id: $id, cachedTransactionId: $cachedTransactionId, onTrial: $onTrial, ended: $ended, canceled: $canceled, description: $description, plan: $plan}';
  }
}
