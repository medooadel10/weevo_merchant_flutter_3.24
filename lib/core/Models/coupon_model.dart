class CouponModel {
  int? id;
  String? couponName;
  String? couponType;
  String? couponCode;
  int? couponMaxUses;
  String? couponStartDate;
  String? couponEndDate;
  String? couponDiscountType;
  String? couponDiscountValue;
  int? couponStatus;
  int? couponUserType;
  List<String>? couponUserId;

  CouponModel(
      {this.id,
      this.couponName,
      this.couponType,
      this.couponCode,
      this.couponMaxUses,
      this.couponStartDate,
      this.couponEndDate,
      this.couponDiscountType,
      this.couponDiscountValue,
      this.couponStatus,
      this.couponUserType,
      this.couponUserId});

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponName = json['coupon_name'];
    couponType = json['coupon_type'];
    couponCode = json['coupon_code'];
    couponMaxUses = json['coupon_max_uses'];
    couponStartDate = json['coupon_start_date'];
    couponEndDate = json['coupon_end_date'];
    couponDiscountType = json['coupon_discount_type'];
    couponDiscountValue = json['coupon_discount_value'];
    couponStatus = json['coupon_status'];
    couponUserType = json['coupon_user_type'];
    couponUserId = json['coupon_user_id'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['coupon_name'] = couponName;
    data['coupon_type'] = couponType;
    data['coupon_code'] = couponCode;
    data['coupon_max_uses'] = couponMaxUses;
    data['coupon_start_date'] = couponStartDate;
    data['coupon_end_date'] = couponEndDate;
    data['coupon_discount_type'] = couponDiscountType;
    data['coupon_discount_value'] = couponDiscountValue;
    data['coupon_status'] = couponStatus;
    data['coupon_user_type'] = couponUserType;
    data['coupon_user_id'] = couponUserId;
    return data;
  }
}
