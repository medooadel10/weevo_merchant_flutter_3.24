import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Dialogs/bottom_sheet_location_picker.dart';

import '../../../core/Dialogs/action_dialog.dart';
import '../../../core/Models/address.dart';
import '../../../core/Providers/add_shipment_provider.dart';
import '../../../core/Providers/map_provider.dart';
import '../../../core/Storage/shared_preference.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../../Widgets/edit_text.dart';
import '../map.dart';

class AddShipment1 extends StatefulWidget {
  const AddShipment1({super.key});
  @override
  State<AddShipment1> createState() => _AddShipment1State();
}

class _AddShipment1State extends State<AddShipment1> {
  late MapProvider _mapProvider;
  late AddShipmentProvider _addShipmentProvider;
  late FocusNode _addressNode;
  late TextEditingController _shipDateTimeController, _addressController;
  bool _shipDateTimeEmpty = true, _addressEmpty = true, _addressFocused = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _mapProvider = Provider.of<MapProvider>(context, listen: false);
    _addShipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    _addShipmentProvider.couponCodeController.clear();
    _addShipmentProvider.checkCoupons();
    _addShipmentProvider.receiveLocationAddressNameController.clear();
    _addShipmentProvider.receiveLocationLatController.clear();
    _addShipmentProvider.receiveLocationLangController.clear();
    _addressNode = FocusNode();
    _addressController = TextEditingController();
    _shipDateTimeController = TextEditingController();
    _addressController.addListener(() {
      setState(() {
        _addressEmpty = _addressController.text.isEmpty;
      });
    });
    _shipDateTimeController.addListener(() {
      setState(() {
        _shipDateTimeEmpty = _shipDateTimeController.text.isEmpty;
      });
    });
    _addressNode.addListener(() {
      setState(() {
        _addressFocused = _addressNode.hasFocus;
      });
    });
    _addressController.text = _mapProvider.fullAddress?.name ?? '';
    _shipDateTimeController.text = _addShipmentProvider.realDeliveryDateTime !=
            null
        ? intl.DateFormat('hh:mm a - E dd MMM y', 'ar-EG')
            .format(DateTime.parse(_addShipmentProvider.realDeliveryDateTime!))
        : '';
    _shipDateTimeEmpty = _shipDateTimeController.text.isEmpty;
    _addressEmpty = _addressController.text.isEmpty;
  }

  @override
  void dispose() {
    _addressNode.dispose();
    _shipDateTimeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    final MapProvider mapProvider = Provider.of<MapProvider>(context);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 30.0,
      ),
      child: Form(
        key: _formState,
        child: Column(
          children: [
            EditText(
              controller: _addressController,
              onChange: (String? v) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
              },
              validator: (String? value) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (value!.isEmpty) {
                  return 'من فضلك اختر العنوان';
                }
                isError = false;
                return null;
              },
              readOnly: true,
              onSave: (String? value) {},
              onTap: () async {
                if (shipmentProvider.shipmentMessage != addOneMore) {
                  if (mapProvider.address!.isEmpty) {
                    mapProvider.setFrom(from_shipment_map);
                    Navigator.pushNamed(context, MapScreen.id,
                        arguments: false);
                  } else {
                    await showModalBottomSheet(
                        context: navigator.currentContext!,
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
                        builder: (ctx) {
                          FocusScope.of(context).requestFocus(_addressNode);
                          return BottomSheetLocationPicker(
                            onLocationClick: (Address a) {
                              shipmentProvider.setMerchantAddress(a);
                              _addressController.text = a.name!;
                              Navigator.pop(ctx);
                            },
                            fromWhere: from_shipment_map,
                          );
                        });
                    _addressNode.unfocus();
                  }
                } else {
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (ctx) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      content: 'يجب ان يكون مكان الأستلام واحد للطلبات',
                      cancelAction: 'حسناً',
                      onCancelClick: () {
                        Navigator.pop(ctx);
                      },
                    ),
                  );
                }
              },
              labelText: 'العنوان',
              isFocus: _addressFocused,
              focusNode: _addressNode,
              isPassword: false,
              prefix: Icon(
                Icons.keyboard_arrow_down_outlined,
                color:
                    _addressFocused ? weevoPrimaryOrangeColor : Colors.black54,
              ),
              suffix: Icon(
                Icons.location_on_outlined,
                color:
                    _addressFocused ? weevoPrimaryOrangeColor : Colors.black54,
              ),
              isPhoneNumber: false,
              shouldDisappear: !_addressEmpty && !_addressFocused,
              upperTitle: true,
            ),
            EditText(
              prefix: Icon(
                Icons.keyboard_arrow_down_outlined,
                color:
                    _addressFocused ? weevoPrimaryOrangeColor : Colors.black54,
              ),
              suffix: Icon(
                Icons.update,
                color:
                    _addressFocused ? weevoPrimaryOrangeColor : Colors.black54,
              ),
              controller: _shipDateTimeController,
              validator: (String? value) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (value!.isEmpty) {
                  return 'اختر تاريخ استلام الطلب';
                }
                isError = false;
                return null;
              },
              readOnly: true,
              onChange: (String? v) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
              },
              onTap: () async {
                if (shipmentProvider.shipmentMessage != addOneMore) {
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
                    // if (tod.hour >= 10 && tod.hour <= 20) {
                    final dateTime = DateTime(
                        dt.year, dt.month, dt.day, tod.hour, tod.minute);
                    shipmentProvider
                        .setRealDeliveryDateTime(dateTime.toIso8601String());
                    _shipDateTimeController.text =
                        intl.DateFormat('hh:mm a - E dd MMM y', 'ar-EG')
                            .format(dateTime);
                    // }
                    // else {
                    //   showDialog(
                    //       navigator.currentContext!,
                    //       builder: (cx) => ActionDialog(
                    //             content:
                    //                 'وقت استلام الطلب يجب ان يكون من 10 صباحاً حتي 8 مساءاً',
                    //             onApproveClick: () {
                    //               Navigator.pop(cx);
                    //             },
                    //             approveAction: 'حسناً',
                    //             onCancelClick: () {
                    //               Navigator.pop(cx);
                    //               final dateTime = DateTime(
                    //                   dt.year, dt.month, (dt.day + 1), 10, 00);
                    //               shipmentProvider.setRealDeliveryDateTime(
                    //                   dateTime.toIso8601String());
                    //               _shipDateTimeController.text =
                    //                   intl.DateFormat(
                    //                           'hh:mm a - E dd MMM y', 'ar-EG')
                    //                       .format(dateTime);
                    //             },
                    //             cancelAction: 'استلام الطلب اليوم التالي',
                    //           ));
                    // }
                  }
                } else {
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (ctx) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      content: 'يجب ان يكون تاريخ الأستلام واحد للطلبات',
                      cancelAction: 'حسناً',
                      onCancelClick: () {
                        Navigator.pop(ctx);
                      },
                    ),
                  );
                }
                FocusScope.of(navigator.currentContext!).unfocus();
              },
              onSave: (String? value) {},
              labelText: 'تاريخ استلام الطلب',
              isFocus: false,
              focusNode: null,
              isPassword: false,
              isPhoneNumber: false,
              shouldDisappear: true && !_shipDateTimeEmpty,
              upperTitle: true,
            ),
            SizedBox(
              height: size.height * .05,
            ),
            TextButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(size.width, size.height * 0.07),
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
                if (_formState.currentState!.validate()) {
                  shipmentProvider
                      .setMerchantAddress(_mapProvider.fullAddress!);
                  shipmentProvider.setIndex(1);
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
