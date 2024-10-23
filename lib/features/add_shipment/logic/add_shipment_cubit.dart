import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_shipment_cubit.freezed.dart';
part 'add_shipment_state.dart';

class AddShipmentCubit extends Cubit<AddShipmentState> {
  AddShipmentCubit() : super(const AddShipmentState.initial());

  int currentIndex = 0;

  void changeStepperIndex(int index) {
    currentIndex = index;
    emit(AddShipmentState.changeStepperIndex(index));
  }
}
