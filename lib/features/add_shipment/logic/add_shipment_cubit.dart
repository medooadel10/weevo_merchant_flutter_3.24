import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../../core/Models/address.dart';
import '../../../core/Models/address_fill.dart';
import '../../../core/Models/city.dart';
import '../../../core/Models/state.dart';
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

  void changeRecieverDateTime(DateTime dateTime) {
    receiverDateTime = dateTime.toIso8601String();
    receiverDateTimeController.text =
        intl.DateFormat('hh:mm a - E dd MMM y', 'ar-EG').format(dateTime);
  }

  final formKeySecond = GlobalKey<FormState>();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final fullDeliveryAddressController = TextEditingController();
  final deliveyAdressController = TextEditingController();
  final deliveryDateTimeController = TextEditingController();
  final clientNameController = TextEditingController();
  final clientPhoneController = TextEditingController();
  final notesController = TextEditingController();
  String? deliveryDateTime;
  States? currentState;
  AddressFill? deliveryAddressFill;

  void changeState(States state) {
    if (currentState != state) {
      currentCity = null;
      cityController.text = '';
    }
    currentState = state;
    stateController.text = state.name ?? '';
    emit(AddShipmentState.changeState(state));
  }

  Cities? currentCity;
  void changeCity(Cities city) {
    currentCity = city;
    cityController.text = city.name ?? '';
    emit(AddShipmentState.changeCity(city));
  }

  void changeDeliveryDateTime(DateTime dateTime) {
    deliveryDateTime = dateTime.toIso8601String();
    deliveryDateTimeController.text =
        intl.DateFormat('hh:mm a - E dd MMM y', 'ar-EG').format(dateTime);
  }

  void changeDeliveryAddressFill(AddressFill? addressFill) {
    deliveryAddressFill = addressFill;
    deliveyAdressController.text =
        '${addressFill?.administrativeArea} - ${addressFill?.subAdministrativeArea}';
  }
}
