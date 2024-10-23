import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';

import '../../../core/Models/address.dart';
import '../../../core/Providers/map_provider.dart';

part 'add_shipment_cubit.freezed.dart';
part 'add_shipment_state.dart';

class AddShipmentCubit extends Cubit<AddShipmentState> {
  AddShipmentCubit() : super(const AddShipmentState.initial());

  int currentIndex = 0;

  void changeStepperIndex(int index) {
    currentIndex = index;
    emit(AddShipmentState.changeStepperIndex(index));
  }

  int receiveAddressSelectedIndex = 0;

  Address? receiverAddress;
  String? receiverDateTime;
  final formKeyFirst = GlobalKey<FormState>();
  final receiverAddressController = TextEditingController();
  final receiverDateTimeController = TextEditingController();
  void init(context) {
    getAddress(context);
  }

  void getAddress(context) async {
    receiverAddress =
        Provider.of<MapProvider>(context, listen: false).fullAddress;
    receiverAddressController.text = receiverAddress?.name ?? '';
  }

  void changeRecieverAddress(Address address) {
    receiverAddress = address;
    receiverAddressController.text = receiverAddress?.name ?? '';
  }

  void changeRecieverDateTime(String dateTime) {
    receiverDateTime = dateTime;
  }
}
