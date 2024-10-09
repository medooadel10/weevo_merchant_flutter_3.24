class Features {
  int? id;
  int? planId;
  String? slug;
  String? name;
  String? description;
  String? value;
  int? resettablePeriod;
  String? resettableInterval;
  int? sortOrder;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Features(
      {this.id,
      this.planId,
      this.slug,
      this.name,
      this.description,
      this.value,
      this.resettablePeriod,
      this.resettableInterval,
      this.sortOrder,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planId = json['plan_id'];
    slug = json['slug'];
    name = json['name'];
    description = json['description'];
    value = json['value'];
    resettablePeriod = json['resettable_period'];
    resettableInterval = json['resettable_interval'];
    sortOrder = json['sort_order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plan_id'] = planId;
    data['slug'] = slug;
    data['name'] = name;
    data['description'] = description;
    data['value'] = value;
    data['resettable_period'] = resettablePeriod;
    data['resettable_interval'] = resettableInterval;
    data['sort_order'] = sortOrder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
