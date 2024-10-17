import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../../core/Dialogs/action_dialog.dart';
import '../../../core/Dialogs/city_bottom_sheet.dart';
import '../../../core/Dialogs/share_bottom_sheet.dart';
import '../../../core/Models/city.dart';
import '../../../core/Models/state.dart';
import '../../../core/Providers/add_shipment_provider.dart';
import '../../../core/Storage/shared_preference.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../../../core/router/router.dart';
import '../../Widgets/edit_text.dart';
import '../map.dart';

class AddShipment2 extends StatefulWidget {
  const AddShipment2({super.key});

  @override
  State<AddShipment2> createState() => _AddShipment2State();
}

class _AddShipment2State extends State<AddShipment2> {
  late FocusNode _receiveLocationNode,
      _customerNameNode,
      _stateNode,
      _cityNode,
      _customerPhoneNumberNode,
      _anotherDetailsNode,
      _receiveLandmarkNode;
  late TextEditingController _receiveLocationController,
      _customerNameController,
      _stateController,
      _cityController,
      _receiveDateTimeController,
      _customerPhoneNumberController,
      _anotherDetailsController,
      _receiveLandmarkController;
  String? _clientAddress,
      _clientName,
      _clientPhoneNumber,
      _clientOtherDetails,
      _receiveLandmark;

  bool _receiveDateTimeEmpty = true;
  bool _cityIsEmpty = true;
  bool _stateIsEmpty = true;
  bool _receiveLocationFocused = false;
  bool _cityFocused = false;
  bool _stateFocused = false;
  bool _receiveLandmarkFocused = false;
  bool _customerNameFocused = false;
  bool _customerPhoneNumberFocused = false;
  bool _anotherDetailsFocused = false;
  bool _receiveLocationEmpty = true;
  bool _customerNameEmpty = true;
  bool _receiveLandmarkEmpty = true;
  bool _customerPhoneNumberEmpty = true;
  bool _anotherDetailsEmpty = true;
  final _formState = GlobalKey<FormState>();
  late AddShipmentProvider _shipmentProvider;
  List<States>? states;
  List<Cities>? cities;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _shipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);

    _receiveLocationController = TextEditingController();

    _customerNameController = TextEditingController();
    _customerPhoneNumberController = TextEditingController();
    _anotherDetailsController = TextEditingController();
    _receiveLandmarkController = TextEditingController();
    _stateController = TextEditingController();
    _cityController = TextEditingController();
    _receiveDateTimeController = TextEditingController();
    _receiveLocationNode = FocusNode();
    _receiveLandmarkNode = FocusNode();
    _stateNode = FocusNode();
    _cityNode = FocusNode();
    _customerNameNode = FocusNode();
    _customerPhoneNumberNode = FocusNode();
    _anotherDetailsNode = FocusNode();
    states = _shipmentProvider.states;
    _receiveDateTimeController.addListener(() {
      setState(() {
        _receiveDateTimeEmpty = _receiveDateTimeController.text.isEmpty;
      });
    });
    _receiveLandmarkController.addListener(() {
      setState(() {
        _receiveLandmarkEmpty = _receiveLandmarkController.text.isEmpty;
      });
    });
    _receiveLocationController.addListener(() {
      setState(() {
        _receiveLocationEmpty = _receiveLocationController.text.isEmpty;
      });
    });
    _customerNameController.addListener(() {
      setState(() {
        _customerNameEmpty = _customerNameController.text.isEmpty;
      });
    });
    _customerPhoneNumberController.addListener(() {
      setState(() {
        _customerPhoneNumberEmpty = _customerPhoneNumberController.text.isEmpty;
      });
    });
    _anotherDetailsController.addListener(() {
      setState(() {
        _anotherDetailsEmpty = _anotherDetailsController.text.isEmpty;
      });
    });
    _stateController.addListener(() {
      setState(() {
        _stateIsEmpty = _stateController.text.isEmpty;
      });
    });
    _cityController.addListener(() {
      setState(() {
        _cityIsEmpty = _cityController.text.isEmpty;
      });
    });
    _receiveLocationNode.addListener(() {
      setState(() {
        _receiveLocationFocused = _receiveLocationNode.hasFocus;
      });
    });
    _customerNameNode.addListener(() {
      setState(() {
        _customerNameFocused = _customerNameNode.hasFocus;
      });
    });
    _customerPhoneNumberNode.addListener(() {
      setState(() {
        _customerPhoneNumberFocused = _customerPhoneNumberNode.hasFocus;
      });
    });
    _receiveLandmarkNode.addListener(() {
      setState(() {
        _receiveLandmarkFocused = _receiveLandmarkNode.hasFocus;
      });
    });
    _anotherDetailsNode.addListener(() {
      setState(() {
        _anotherDetailsFocused = _anotherDetailsNode.hasFocus;
      });
    });
    _stateNode.addListener(() {
      setState(() {
        _stateFocused = _stateNode.hasFocus;
      });
    });
    _cityNode.addListener(() {
      setState(() {
        _cityFocused = _cityNode.hasFocus;
      });
    });
    _receiveLocationController.text = _shipmentProvider.clientAddress ?? '';
    _customerNameController.text = _shipmentProvider.clientName ?? '';
    _customerPhoneNumberController.text =
        _shipmentProvider.clientPhoneNumber ?? '';
    _anotherDetailsController.text = _shipmentProvider.otherDetails ?? '';
    _receiveLandmarkController.text = _shipmentProvider.landmark ?? '';
    _stateController.text = _shipmentProvider.stateName ?? '';
    _cityController.text = _shipmentProvider.cityName ?? '';
    _receiveDateTimeController.text =
        _shipmentProvider.realReceiveDateTime != null
            ? intl.DateFormat('hh:mm a - E dd MMM y', 'ar-EG')
                .format(DateTime.parse(_shipmentProvider.realReceiveDateTime!))
            : '';
    _receiveLocationEmpty = _receiveLocationController.text.isEmpty;
    _receiveLandmarkEmpty = _receiveLandmarkController.text.isEmpty;
    _customerNameEmpty = _customerNameController.text.isEmpty;
    _customerPhoneNumberEmpty = _customerPhoneNumberController.text.isEmpty;
    _anotherDetailsEmpty = _anotherDetailsController.text.isEmpty;
    _stateIsEmpty = _stateController.text.isEmpty;
    _cityIsEmpty = _cityController.text.isEmpty;
    _receiveDateTimeEmpty = _receiveDateTimeController.text.isEmpty;
  }

  @override
  void dispose() {
    _receiveLocationNode.dispose();
    _customerNameNode.dispose();
    _customerPhoneNumberNode.dispose();
    _anotherDetailsNode.dispose();
    _receiveLandmarkNode.dispose();
    _stateNode.dispose();
    _cityNode.dispose();
    _receiveLocationController.dispose();
    _receiveLandmarkController.dispose();
    _customerNameController.dispose();
    _customerPhoneNumberController.dispose();
    _anotherDetailsController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _receiveDateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    return Form(
      key: _formState,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        child: Column(
          children: [
            EditText(
              readOnly: true,
              controller: _stateController,
              onSave: (_) {},
              focusNode: _stateNode,
              isFocus: _stateFocused,
              labelText: 'المحافظة',
              onChange: (String? v) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
              },
              upperTitle: true,
              shouldDisappear: !_stateFocused && !_stateIsEmpty,
              isPassword: false,
              isPhoneNumber: false,
              prefix: const Icon(
                Icons.location_on,
                color: Colors.black54,
              ),
              suffix: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.grey,
              ),
              validator: (String? value) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (value!.isEmpty) {
                  return 'من فضلك اختر المحافظة';
                }
                isError = false;
                return null;
              },
              onTap: () async {
                if (shipmentProvider.shipmentMessage != addOneMore) {
                  shipmentProvider.statesFilterList.clear();
                  showModalBottomSheet(
                    context: navigator.currentContext!,
                    builder: (ctx) => StateBottomSheet(
                      states: states!,
                      onPress: (States? state) {
                        if (state != null) {
                          shipmentProvider.setCityName(null);
                          _cityController.text = '';
                        }
                        shipmentProvider.setStateName(state!.name!);
                        _stateController.text = state.name!;
                        Navigator.pop(ctx);
                      },
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          20.0,
                        ),
                        topRight: Radius.circular(
                          20.0,
                        ),
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (ctx) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      content: 'يجب أن تكون الطلبات في محافظة واحدة',
                      cancelAction: 'حسناً',
                      onCancelClick: () {
                        Navigator.pop(ctx);
                      },
                    ),
                  );
                }
                _stateNode.unfocus();
              },
            ),
            EditText(
              readOnly: true,
              controller: _cityController,
              onSave: (_) {},
              focusNode: _cityNode,
              prefix: const Icon(
                Icons.location_on,
                color: Colors.black54,
              ),
              onChange: (String? v) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
              },
              suffix: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.grey,
              ),
              isFocus: _cityFocused,
              labelText: 'المنطقة',
              upperTitle: true,
              shouldDisappear: !_cityFocused && !_cityIsEmpty,
              isPassword: false,
              isPhoneNumber: false,
              validator: (String? value) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (value!.isEmpty) {
                  return 'من فضلك اختر المنطقة';
                } else if (shipmentProvider.stateName == null) {
                  return 'من فضلك اختر المحافظة أولاً';
                }
                isError = false;
                return null;
              },
              onTap: () async {
                shipmentProvider.citiesFilterList.clear();
                if (shipmentProvider.stateName != null) {
                  cities = shipmentProvider.states
                      .where((item) => item.name == shipmentProvider.stateName)
                      .toList()[0]
                      .cities;
                  showModalBottomSheet(
                    context: navigator.currentContext!,
                    builder: (ctx) => CityBottomSheet(
                      cities: cities!,
                      onPress: (Cities city) {
                        shipmentProvider.setCityName(city.name);
                        _cityController.text = city.name!;
                        Navigator.pop(ctx);
                      },
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          20.0,
                        ),
                        topRight: Radius.circular(
                          20.0,
                        ),
                      ),
                    ),
                  );
                } else {
                  showDialog(
                      context: navigator.currentContext!,
                      builder: (ctx) => ActionDialog(
                            content: 'عليك اختيار المحافظة اولاً',
                            approveAction: 'حسناً',
                            onApproveClick: () {
                              Navigator.pop(ctx);
                            },
                          ));
                }
                _cityNode.unfocus();
              },
            ),
            EditText(
              readOnly: false,
              controller: _receiveLocationController,
              upperTitle: true,
              onChange: (String? value) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
                if (value!.isEmpty || value.length == 1) {
                  setState(() {
                    _receiveLocationEmpty = value.isEmpty;
                  });
                }
              },
              shouldDisappear:
                  !_receiveLocationFocused && !_receiveLocationEmpty,
              action: TextInputAction.done,
              onFieldSubmit: (String? s) {
                FocusScope.of(context).unfocus();
              },
              isPhoneNumber: false,
              isPassword: false,
              isFocus: _receiveLocationFocused,
              focusNode: _receiveLocationNode,
              validator: (String? output) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (output!.length < 4) {
                  return 'من فضلك ادخل موقع التسليم';
                }
                isError = false;
                return null;
              },
              onSave: (String? saved) {
                _clientAddress = saved;
              },
              labelText: 'موقع التسليم بالتفصيل',
              prefix: const Icon(
                Icons.location_pin,
                color: Colors.black54,
              ),
            ),
            EditText(
              readOnly: true,
              controller: shipmentProvider.receiveLocationAddressNameController,
              upperTitle: true,
              onTap: () {
                if (shipmentProvider.cityName != null &&
                    shipmentProvider.stateName != null) {
                  Navigator.pushNamed(navigator.currentContext!, MapScreen.id,
                      arguments: true);
                } else {
                  showDialog(
                      context: navigator.currentContext!,
                      builder: (_) => ActionDialog(
                            content: 'عليك اختيار المنطقة اولاً',
                            onApproveClick: () {
                              MagicRouter.pop();
                            },
                            approveAction: 'حسناً',
                          ));
                }
              },
              action: TextInputAction.done,
              isPhoneNumber: false,
              isPassword: false,
              labelText: 'موقع التسليم بالخريطة',
              validator: (String? output) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (output!.isEmpty) {
                  return 'من فضلك اضف العنوان من الخريطة';
                }
                isError = false;
                return null;
              },
              prefix: const Icon(
                Icons.location_pin,
                color: Colors.black54,
              ),
            ),
            EditText(
              readOnly: false,
              controller: _receiveLandmarkController,
              upperTitle: true,
              onChange: (String? value) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
                if (value!.isEmpty || value.length == 1) {
                  setState(() {
                    _receiveLandmarkEmpty = value.isEmpty;
                  });
                }
              },
              shouldDisappear:
                  !_receiveLandmarkFocused && !_receiveLandmarkEmpty,
              action: TextInputAction.done,
              onFieldSubmit: (String? s) {
                FocusScope.of(context).unfocus();
              },
              isPhoneNumber: false,
              isPassword: false,
              isFocus: _receiveLandmarkFocused,
              focusNode: _receiveLandmarkNode,
              validator: (String? output) => null,
              onSave: (String? saved) {
                _receiveLandmark = saved;
              },
              labelText: 'علامة مميزة',
              prefix: const Icon(
                Icons.location_pin,
                color: Colors.black54,
              ),
            ),
            EditText(
              readOnly: true,
              controller: _receiveDateTimeController,
              upperTitle: true,
              shouldDisappear: !_receiveDateTimeEmpty && true,
              isPhoneNumber: false,
              isPassword: false,
              isFocus: false,
              onTap: () async {
                TimeOfDay? tod;
                DateTime? dt;
                dt = await showDatePicker(
                  context: navigator.currentContext!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2050),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        dialogTheme: DialogTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                        colorScheme: const ColorScheme.light(
                          primary: weevoPrimaryOrangeColor,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: weevoPrimaryOrangeColor,
                        ),
                        dialogBackgroundColor: Colors.white,
                      ),
                      child: child ?? Container(),
                    );
                  },
                );
                if (dt != null) {
                  tod = await showTimePicker(
                    context: navigator.currentContext!,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          timePickerTheme: TimePickerThemeData(
                            dialBackgroundColor: weevoOrangeLighter,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                25.0,
                              ),
                            ),
                          ),
                          colorScheme: const ColorScheme.light(
                            primary: weevoPrimaryOrangeColor,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: weevoPrimaryOrangeColor,
                          ),
                          dialogBackgroundColor: Colors.white,
                        ),
                        child: child ?? Container(),
                      );
                    },
                  );
                }
                if (dt != null && tod != null) {
                  final pickupDateTime =
                      DateTime.parse(shipmentProvider.realDeliveryDateTime!);
                  log('pickupDateTime -> $pickupDateTime');
                  if (DateTime(dt.year, dt.month, dt.day, tod.hour, tod.minute)
                      .isBefore(pickupDateTime)) {
                    showDialog(
                        context: navigator.currentContext!,
                        builder: (cx) => ActionDialog(
                              content:
                                  'يجب ان يكون وقت التسليم بعد وقت الاستلام',
                              onApproveClick: () {
                                Navigator.pop(cx);
                                shipmentProvider.setRealReceiveDateTime(null);
                                _receiveDateTimeController.text = '';
                              },
                              approveAction: 'حسناً',
                            ));
                  } else {
                    // else if(!((tod.hour - pickupDateTime.hour) >= 2)){
                    //   showDialog(
                    //       navigator.currentContext!,
                    //       builder: (cx) => ActionDialog(
                    //         content:
                    //         'يجب ان يكون وقت التسليم بعد وقت الاستلام بساعتين',
                    //         onApproveClick: () {
                    //           Navigator.pop(cx);
                    //           shipmentProvider
                    //               .setRealReceiveDateTime(null);
                    //           _receiveDateTimeController.text =
                    //           '';
                    //         },
                    //         approveAction: 'حسناً',
                    //       ));
                    // }
                    // else if (tod.hour >= 11 && tod.hour <= 22) {
                    final dateTime = DateTime(
                        dt.year, dt.month, dt.day, tod.hour, tod.minute);
                    shipmentProvider
                        .setRealReceiveDateTime(dateTime.toIso8601String());
                    _receiveDateTimeController.text =
                        intl.DateFormat('hh:mm a - E dd MMM y', 'ar-EG')
                            .format(dateTime);
                  }
                  // }
                  // else {
                  //   showDialog(
                  //       navigator.currentContext!,
                  //       builder: (cx) => ActionDialog(
                  //             content:
                  //                 'وقت تسليم الطلب يجب ان يكون من 11 صباحاً حتي 10 مساءاً',
                  //             onApproveClick: () {
                  //               Navigator.pop(cx);
                  //             },
                  //             approveAction: 'حسناً',
                  //             onCancelClick: () {
                  //               Navigator.pop(cx);
                  //               final dateTime = DateTime(
                  //                   dt.year, dt.month, (dt.day + 1), 11, 00);
                  //               shipmentProvider.setRealReceiveDateTime(
                  //                   dateTime.toIso8601String());
                  //               _receiveDateTimeController.text =
                  //                   intl.DateFormat(
                  //                           'hh:mm a - E dd MMM y', 'ar-EG')
                  //                       .format(dateTime);
                  //             },
                  //             cancelAction: 'تسليم الطلب اليوم التالي',
                  //           ));
                  // }
                }
              },
              focusNode: null,
              validator: (String? output) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (output!.isEmpty) {
                  return 'من فضلك أدخل تاريخ التسليم';
                } else if (DateTime.parse(
                        shipmentProvider.realDeliveryDateTime!)
                    .isAfter(DateTime.parse(
                        shipmentProvider.realReceiveDateTime!))) {
                  return 'يجب ان يكون تاريخ التسليم للعميل بعد تاريخ التسليم للكابتن';
                }
                isError = false;
                return null;
              },
              onSave: (_) {},
              labelText: 'تاريخ تسليم الطلب',
              prefix: const Icon(
                Icons.update,
                color: Colors.black54,
              ),
            ),
            EditText(
              readOnly: false,
              controller: _customerNameController,
              upperTitle: true,
              onChange: (String? value) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
                if (value!.isEmpty || value.length == 1) {
                  setState(() {
                    _customerNameEmpty = value.isEmpty;
                  });
                }
              },
              shouldDisappear: !_customerNameEmpty && !_customerNameFocused,
              action: TextInputAction.done,
              onFieldSubmit: (String? s) {
                FocusScope.of(context).unfocus();
              },
              prefix: const Icon(
                Icons.account_box_outlined,
                color: Colors.black54,
              ),
              isPhoneNumber: false,
              type: TextInputType.text,
              isPassword: false,
              isFocus: _customerNameFocused,
              focusNode: _customerNameNode,
              validator: (String? output) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (output!.isEmpty) {
                  return nameValidatorMessage;
                }
                isError = false;
                return null;
              },
              onSave: (String? saved) {
                _clientName = saved;
              },
              labelText: 'أسم العميل',
            ),
            EditText(
              readOnly: false,
              controller: _customerPhoneNumberController,
              prefix: const Icon(
                Icons.phone,
                color: Colors.black54,
              ),
              upperTitle: true,
              onChange: (String? value) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
                if (value!.isEmpty || value.length == 1) {
                  setState(() {
                    _customerPhoneNumberEmpty = value.isEmpty;
                  });
                }
              },
              shouldDisappear:
                  !_customerPhoneNumberEmpty && !_customerPhoneNumberFocused,
              action: TextInputAction.done,
              onFieldSubmit: (String? s) {
                FocusScope.of(context).unfocus();
              },
              isPhoneNumber: true,
              type: TextInputType.phone,
              isPassword: false,
              isFocus: _customerPhoneNumberFocused,
              focusNode: _customerPhoneNumberNode,
              validator: (String? output) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (output!.length < 11 || !validateUserPhone(output)) {
                  return phoneValidatorMessage;
                }
                isError = false;
                return null;
              },
              onSave: (String? saved) {
                _clientPhoneNumber = saved;
              },
              labelText: 'رقم هاتف العميل',
            ),
            EditText(
              readOnly: false,
              controller: _anotherDetailsController,
              prefix: const Icon(
                Icons.sticky_note_2,
                color: Colors.black54,
              ),
              upperTitle: true,
              onChange: (String? value) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
                if (value!.isEmpty || value.length == 1) {
                  setState(() {
                    _anotherDetailsEmpty = value.isEmpty;
                  });
                }
              },
              shouldDisappear: !_anotherDetailsEmpty && !_anotherDetailsFocused,
              onFieldSubmit: (String? value) {
                _anotherDetailsNode.unfocus();
              },
              action: TextInputAction.done,
              isPhoneNumber: false,
              type: TextInputType.text,
              isPassword: false,
              isFocus: _anotherDetailsFocused,
              focusNode: _anotherDetailsNode,
              validator: (String? output) => null,
              onSave: (String? saved) {
                _clientOtherDetails = saved;
              },
              labelText: 'تفاصيل اخري',
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            TextButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(
                    size.width,
                    size.height * 0.07,
                  ),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  weevoPrimaryBlueColor,
                ),
              ),
              onPressed: () {
                isButtonPressed = true;
                if (shipmentProvider.test) {
                  shipmentProvider.setIndex(2);
                } else {
                  if (_formState.currentState!.validate()) {
                    _formState.currentState!.save();
                    shipmentProvider.setClientAddress(_clientAddress);
                    shipmentProvider.setClientName(_clientName);
                    shipmentProvider.setClientPhoneNumber(_clientPhoneNumber);
                    if (_clientOtherDetails!.isNotEmpty) {
                      shipmentProvider.setOtherDetails(_clientOtherDetails);
                    }
                    if (_receiveLandmark!.isNotEmpty) {
                      shipmentProvider.setLandmarkName(_receiveLandmark);
                    }
                    shipmentProvider.setIndex(2);
                  }
                }
              },
              child: const Text(
                'التالي',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
