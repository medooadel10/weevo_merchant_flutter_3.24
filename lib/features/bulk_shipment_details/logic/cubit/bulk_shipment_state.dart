part of 'bulk_shipment_cubit.dart';

@freezed
class BulkShipmentState with _$BulkShipmentState {
  const factory BulkShipmentState.initial() = _Initial;

  const factory BulkShipmentState.loading() = Loading;

  const factory BulkShipmentState.success(BulkShipmentModel bulkShipmentModel) =
      Success;

  const factory BulkShipmentState.error(String error) = Error;
}
