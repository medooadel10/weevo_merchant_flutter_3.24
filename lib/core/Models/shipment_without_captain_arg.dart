import 'bulk_shipment.dart';
import 'child_shipment.dart';

class ShipmentWithoutCaptainArg {
  final ChildShipment? child;
  final BulkShipment? bulk;
  final bool isOneShipment;

  ShipmentWithoutCaptainArg({
    this.child,
    this.bulk,
    required this.isOneShipment,
  });
}
