class AcceptMerchantOffer {
  final int shipmentId;
  final int childrenShipment;

  AcceptMerchantOffer({
    required this.shipmentId,
    required this.childrenShipment,
  });

  factory AcceptMerchantOffer.fromMap(Map<String, dynamic> map) =>
      AcceptMerchantOffer(
          shipmentId: int.tryParse(map['shipment_id'] ?? '0') ?? 0,
          childrenShipment: int.tryParse(map['children_shipment'] ?? '0') ?? 0);

  Map<String, dynamic> toMap() => {
        'shipment_id': shipmentId.toString(),
        'children_shipment': childrenShipment.toString(),
      };
}
