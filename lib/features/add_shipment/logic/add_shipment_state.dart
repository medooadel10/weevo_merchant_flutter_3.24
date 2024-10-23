part of 'add_shipment_cubit.dart';

@freezed
class AddShipmentState with _$AddShipmentState {
  const factory AddShipmentState.initial() = _Initial;

  const factory AddShipmentState.changeStepperIndex(int index) =
      ChangeStepperIndex;
}
