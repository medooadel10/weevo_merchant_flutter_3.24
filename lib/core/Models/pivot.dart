class Pivot {
  int? shipmentId;
  int? productId;

  Pivot({this.shipmentId, this.productId});

  Pivot.fromJson(Map<String, dynamic> json) {
    shipmentId = json['shipment_id'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shipment_id'] = shipmentId;
    data['product_id'] = productId;
    return data;
  }
}
