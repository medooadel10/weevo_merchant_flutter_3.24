class CreditCardPlan {
  int? id;
  String? slug;
  String? name;
  String? description;
  bool? isActive;
  int? price;
  int? oldPrice;
  int? signupFee;
  String? currency;
  int? trialPeriod;
  String? trialInterval;
  int? invoicePeriod;
  String? invoiceInterval;
  int? gracePeriod;
  String? graceInterval;
  String? prorateDay;
  String? proratePeriod;
  String? prorateExtendDue;
  String? activeSubscribersLimit;
  int? sortOrder;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  CreditCardPlan(
      {this.id,
      this.slug,
      this.name,
      this.description,
      this.isActive,
      this.price,
      this.oldPrice,
      this.signupFee,
      this.currency,
      this.trialPeriod,
      this.trialInterval,
      this.invoicePeriod,
      this.invoiceInterval,
      this.gracePeriod,
      this.graceInterval,
      this.prorateDay,
      this.proratePeriod,
      this.prorateExtendDue,
      this.activeSubscribersLimit,
      this.sortOrder,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CreditCardPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
    price = json['price'];
    oldPrice = json['old_price'];
    signupFee = json['signup_fee'];
    currency = json['currency'];
    trialPeriod = json['trial_period'];
    trialInterval = json['trial_interval'];
    invoicePeriod = json['invoice_period'];
    invoiceInterval = json['invoice_interval'];
    gracePeriod = json['grace_period'];
    graceInterval = json['grace_interval'];
    prorateDay = json['prorate_day'];
    proratePeriod = json['prorate_period'];
    prorateExtendDue = json['prorate_extend_due'];
    activeSubscribersLimit = json['active_subscribers_limit'];
    sortOrder = json['sort_order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    data['description'] = description;
    data['is_active'] = isActive;
    data['price'] = price;
    data['old_price'] = oldPrice;
    data['signup_fee'] = signupFee;
    data['currency'] = currency;
    data['trial_period'] = trialPeriod;
    data['trial_interval'] = trialInterval;
    data['invoice_period'] = invoicePeriod;
    data['invoice_interval'] = invoiceInterval;
    data['grace_period'] = gracePeriod;
    data['grace_interval'] = graceInterval;
    data['prorate_day'] = prorateDay;
    data['prorate_period'] = proratePeriod;
    data['prorate_extend_due'] = prorateExtendDue;
    data['active_subscribers_limit'] = activeSubscribersLimit;
    data['sort_order'] = sortOrder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
