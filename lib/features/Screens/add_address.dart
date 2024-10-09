import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Dialogs/city_bottom_sheet.dart';
import '../../core/Dialogs/share_bottom_sheet.dart';
import '../../core/Models/address.dart';
import '../../core/Models/city.dart';
import '../../core/Models/state.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/map_provider.dart';
import '../../core/Providers/update_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/loading_widget.dart';
import '../Widgets/weevo_button.dart';
import 'map.dart';
import 'merchant_address.dart';

class AddAddress extends StatefulWidget {
  static const String id = "FillAddress";
  final bool isUpdated;
  final Address? address;

  const AddAddress({
    super.key,
    required this.isUpdated,
    required this.address,
  });

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late MapProvider _mapProvider;
  late AddShipmentProvider _shipmentProvider;

  String? _street,
      _state,
      _city,
      _building,
      _apartment,
      _floor,
      _landmark,
      _placeName;
  late TextEditingController _floorController,
      _apartmentController,
      _buildingController,
      _streetController,
      _marketPlaceController,
      _placeNameController,
      _stateController,
      _cityController;

  late FocusNode _floorNode,
      _apartmentNode,
      _buildingNode,
      _streetNode,
      _stateNode,
      _cityNode,
      _marketPlaceNode,
      _placeNameNode;
  final bool _placeNameFocused = false;
  bool _stateFocused = false;
  bool _cityFocused = false;
  bool _cityIsEmpty = false;
  bool _stateIsEmpty = false;
  bool _floorFocused = false;
  bool _buildingFocused = false;
  bool _apartmentFocused = false;
  bool _streetFocused = false;
  bool _marketPlaceFocused = false;
  bool _placeNameIsEmpty = true;
  bool _floorIsEmpty = true;
  bool _buildingIsEmpty = true;
  bool _apartmentIsEmpty = true;
  bool _streetIsEmpty = true;
  bool _marketPlaceIsEmpty = true;
  String? _lat, _long;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  List<States>? states;
  List<Cities>? cities;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _mapProvider = Provider.of<MapProvider>(context, listen: false);
    _shipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    _streetNode = FocusNode();
    _floorNode = FocusNode();
    _placeNameNode = FocusNode();
    _marketPlaceNode = FocusNode();
    _buildingNode = FocusNode();
    _apartmentNode = FocusNode();
    _stateNode = FocusNode();
    _cityNode = FocusNode();
    _streetController = TextEditingController();
    _floorController = TextEditingController();
    _marketPlaceController = TextEditingController();
    _buildingController = TextEditingController();
    _apartmentController = TextEditingController();
    _placeNameController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    states = _shipmentProvider.states;
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
    _streetController.addListener(() {
      setState(() {
        _streetIsEmpty = _streetController.text.isEmpty;
      });
    });
    _floorController.addListener(() {
      setState(() {
        _floorIsEmpty = _floorController.text.isEmpty;
      });
    });
    _marketPlaceController.addListener(() {
      setState(() {
        _marketPlaceIsEmpty = _marketPlaceController.text.isEmpty;
      });
    });
    _buildingController.addListener(() {
      setState(() {
        _buildingIsEmpty = _buildingController.text.isEmpty;
      });
    });
    _apartmentController.addListener(() {
      setState(() {
        _apartmentIsEmpty = _apartmentController.text.isEmpty;
      });
    });
    _placeNameController.addListener(() {
      setState(() {
        _placeNameIsEmpty = _placeNameController.text.isEmpty;
      });
    });
    _streetNode.addListener(() {
      setState(() {
        _streetFocused = _streetNode.hasFocus;
      });
    });

    _floorNode.addListener(() {
      setState(() {
        _floorFocused = _floorNode.hasFocus;
      });
    });
    _marketPlaceNode.addListener(() {
      setState(() {
        _marketPlaceFocused = _marketPlaceNode.hasFocus;
      });
    });
    _apartmentNode.addListener(() {
      setState(() {
        _apartmentFocused = _apartmentNode.hasFocus;
      });
    });
    _buildingNode.addListener(() {
      setState(() {
        _buildingFocused = _buildingNode.hasFocus;
      });
    });
    if (!widget.isUpdated) {
      _lat = _mapProvider.addressFill?.lat.toString();
      _long = _mapProvider.addressFill?.long.toString();
    }
    if (widget.isUpdated) {
      _streetController.text = widget.address?.street ?? "";
      _apartmentController.text = widget.address?.apartment ?? "";
      _floorController.text = widget.address?.floor ?? "";
      _buildingController.text = widget.address?.buildingNumber ?? "";
      _marketPlaceController.text = widget.address?.landmark ?? "";
      _placeNameController.text = widget.address?.name ?? "";
      _lat = widget.address?.lat;
      _long = widget.address?.lng;
      _city = widget.address?.city;
      _state = widget.address?.state;
      _cityController.text = widget.address?.city ?? "";
      _stateController.text = widget.address?.state ?? '';
    }
    _streetIsEmpty = _streetController.text.isEmpty;
    _buildingIsEmpty = _buildingController.text.isEmpty;
    _floorIsEmpty = _floorController.text.isEmpty;
    _apartmentIsEmpty = _apartmentController.text.isEmpty;
    _marketPlaceIsEmpty = _marketPlaceController.text.isEmpty;
    _placeNameIsEmpty = _placeNameController.text.isEmpty;
    _stateIsEmpty = _stateController.text.isEmpty;
    _cityIsEmpty = _cityController.text.isEmpty;
  }

  @override
  void dispose() {
    _streetNode.dispose();
    _floorNode.dispose();
    _marketPlaceNode.dispose();
    _placeNameNode.dispose();
    _buildingNode.dispose();
    _apartmentNode.dispose();
    _stateNode.dispose();
    _cityNode.dispose();
    _streetController.dispose();
    _floorController.dispose();
    _marketPlaceController.dispose();
    _placeNameController.dispose();
    _buildingController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapProvider mapProvider = Provider.of<MapProvider>(context);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final UpdateProfileProvider updateProvider =
        Provider.of<UpdateProfileProvider>(context);
    final AddShipmentProvider shipmentProvider =
        Provider.of<AddShipmentProvider>(context);
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          showDialog(
            context: navigator.currentContext!,
            builder: (context) => ActionDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              title: 'الخروج',
              content: 'هل تود الخروج',
              onApproveClick: () {
                if (mapProvider.from == from_address_map) {
                  MagicRouter.pop();
                  Navigator.pushReplacementNamed(context, MerchantAddress.id);
                } else {
                  MagicRouter.pop();
                  MagicRouter.pop();
                }
              },
              onCancelClick: () {
                MagicRouter.pop();
              },
              approveAction: 'نعم',
              cancelAction: 'لا',
            ),
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      title: 'الخروج',
                      content: 'هل تود الخروج',
                      onApproveClick: () {
                        MagicRouter.pop();
                        MagicRouter.pop();
                      },
                      onCancelClick: () {
                        MagicRouter.pop();
                      },
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                ),
              ),
              title: const Text(
                'اضافة عنوان جديد',
              )),
          body: LoadingWidget(
            isLoading: mapProvider.addressLoading,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: size.height * 0.23,
                      child: Stack(
                        children: [
                          Card(
                            color: Colors.grey,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                            margin: const EdgeInsets.all(
                              12.0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                              child: Image.asset(
                                'assets/images/map_simulation.png',
                                fit: BoxFit.fill,
                                height: size.height * 0.2,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, MapScreen.id,
                                    arguments: false);
                              },
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all<Size>(
                                  Size(size.width * 0.34, size.height * 0.08),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    weevoPrimaryOrangeColor),
                                padding:
                                    WidgetStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'تحديد الموقع',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Form(
                      key: formState,
                      child: Column(
                        children: [
                          EditText(
                            upperTitle: true,
                            isPassword: false,
                            isPhoneNumber: false,
                            readOnly: true,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                            labelText: 'المحافظة',
                            shouldDisappear: !_stateFocused && !_stateIsEmpty,
                            controller: _stateController,
                            onChange: (String? v) {
                              isButtonPressed = false;
                              if (isError) {
                                formState.currentState!.validate();
                              }
                            },
                            onSave: (String? v) {
                              _state = v;
                            },
                            focusNode: _stateNode,
                            onTap: () async {
                              log('${_shipmentProvider.states.length}');
                              shipmentProvider.statesFilterList.clear();
                              showModalBottomSheet(
                                context: navigator.currentContext!,
                                builder: (ctx) => StateBottomSheet(
                                  states: states!,
                                  onPress: (States state) {
                                    _city = null;
                                    _cityController.text = '';
                                    _state = state.name;
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
                            },
                            isFocus: _stateFocused,
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
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          EditText(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                            onChange: (String? v) {
                              isButtonPressed = false;
                              if (isError) {
                                formState.currentState!.validate();
                              }
                            },
                            onTap: () async {
                              shipmentProvider.citiesFilterList.clear();
                              cities = shipmentProvider.states
                                  .where((item) => item.name == _state)
                                  .toList()[0]
                                  .cities;
                              await showModalBottomSheet(
                                context: navigator.currentContext!,
                                builder: (ctx) => CityBottomSheet(
                                  cities: cities!,
                                  onPress: (Cities city) {
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
                            },
                            focusNode: _cityNode,
                            isFocus: _cityFocused,
                            upperTitle: true,
                            isPassword: false,
                            isPhoneNumber: false,
                            shouldDisappear: !_cityIsEmpty && !_cityFocused,
                            onSave: (String? v) {
                              _city = v;
                            },
                            readOnly: true,
                            controller: _cityController,
                            labelText: 'المنطقة',
                            validator: (String? value) {
                              if (!isButtonPressed) {
                                return null;
                              }
                              isError = true;
                              if (value!.isEmpty) {
                                return 'من فضلك اختر المنطقة';
                              } else if (_state == null) {
                                return 'من فضلك اختر المحافظة أولاً';
                              }
                              isError = false;
                              return null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          EditText(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                            readOnly: false,
                            controller: _streetController,
                            radius: 15.0,
                            upperTitle: true,
                            type: TextInputType.text,
                            onChange: (String? value) {
                              isButtonPressed = false;
                              if (isError) {
                                formState.currentState!.validate();
                              }
                              setState(() {
                                _streetIsEmpty = value!.isEmpty;
                              });
                            },
                            shouldDisappear: !_streetIsEmpty && !_streetFocused,
                            action: TextInputAction.done,
                            onFieldSubmit: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            isPhoneNumber: false,
                            isPassword: false,
                            isFocus: _streetFocused,
                            focusNode: _streetNode,
                            validator: (String? output) {
                              if (!isButtonPressed) {
                                return null;
                              }
                              isError = true;
                              if (output!.length < 6) {
                                return 'من فضلك ادخل اسم الشارع';
                              }
                              isError = false;
                              return null;
                            },
                            onSave: (String? saved) {
                              _street = saved;
                            },
                            labelText: 'الشارع',
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: EditText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0,
                                  readOnly: false,
                                  controller: _buildingController,
                                  upperTitle: true,
                                  radius: 15.0,
                                  onChange: (String? value) {
                                    isButtonPressed = false;
                                    if (isError) {
                                      formState.currentState!.validate();
                                    }
                                    setState(() {
                                      _buildingIsEmpty = value!.isEmpty;
                                    });
                                  },
                                  shouldDisappear:
                                      !_buildingIsEmpty && !_buildingFocused,
                                  action: TextInputAction.done,
                                  onFieldSubmit: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_floorNode);
                                  },
                                  isPhoneNumber: false,
                                  isPassword: false,
                                  isFocus: _buildingFocused,
                                  focusNode: _buildingNode,
                                  type: TextInputType.number,
                                  validator: (String? output) {
                                    if (!isButtonPressed) {
                                      return null;
                                    }
                                    isError = true;
                                    if (output!.isEmpty) {
                                      return 'من فضلك ادخل اسم العقار';
                                    }
                                    isError = false;
                                    return null;
                                  },
                                  onSave: (String? saved) {
                                    _building = saved;
                                  },
                                  labelText: 'العقار',
                                ),
                              ),
                              SizedBox(
                                width: size.height * 0.01,
                              ),
                              Expanded(
                                child: EditText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0,
                                  readOnly: false,
                                  controller: _floorController,
                                  upperTitle: true,
                                  radius: 15.0,
                                  onChange: (String? value) {
                                    isButtonPressed = false;
                                    if (isError) {
                                      formState.currentState!.validate();
                                    }
                                    setState(() {
                                      _floorIsEmpty = value!.isEmpty;
                                    });
                                  },
                                  shouldDisappear:
                                      !_floorIsEmpty && !_floorFocused,
                                  action: TextInputAction.done,
                                  onFieldSubmit: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_apartmentNode);
                                  },
                                  isPhoneNumber: false,
                                  isPassword: false,
                                  type: TextInputType.number,
                                  isFocus: _floorFocused,
                                  focusNode: _floorNode,
                                  validator: (String? output) {
                                    if (!isButtonPressed) {
                                      return null;
                                    }
                                    isError = true;
                                    if (output!.isEmpty) {
                                      return 'من فضلك ادخل الدور';
                                    }
                                    isError = false;
                                    return null;
                                  },
                                  onSave: (String? saved) {
                                    _floor = saved;
                                  },
                                  labelText: 'الدور',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: EditText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0,
                                  readOnly: false,
                                  radius: 15.0,
                                  controller: _apartmentController,
                                  upperTitle: true,
                                  type: TextInputType.number,
                                  onChange: (String? value) {
                                    isButtonPressed = false;
                                    if (isError) {
                                      formState.currentState!.validate();
                                    }
                                    setState(() {
                                      _apartmentIsEmpty = value!.isEmpty;
                                    });
                                  },
                                  shouldDisappear:
                                      !_apartmentFocused && !_apartmentIsEmpty,
                                  action: TextInputAction.done,
                                  onFieldSubmit: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_marketPlaceNode);
                                  },
                                  isPhoneNumber: false,
                                  isPassword: false,
                                  isFocus: _apartmentFocused,
                                  focusNode: _apartmentNode,
                                  validator: (String? output) {
                                    if (!isButtonPressed) {
                                      return null;
                                    }
                                    isError = true;
                                    if (output!.isEmpty) {
                                      return 'من فضلك ادخل رقم الشقة';
                                    }
                                    isError = false;
                                    return null;
                                  },
                                  onSave: (String? saved) {
                                    _apartment = saved;
                                  },
                                  labelText: 'شقة',
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.03,
                              ),
                              Expanded(
                                flex: 3,
                                child: EditText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0,
                                  readOnly: false,
                                  radius: 15.0,
                                  controller: _marketPlaceController,
                                  upperTitle: true,
                                  onChange: (String? value) {
                                    isButtonPressed = false;
                                    if (isError) {
                                      formState.currentState!.validate();
                                    }
                                    setState(() {
                                      _marketPlaceIsEmpty = value!.isEmpty;
                                    });
                                  },
                                  shouldDisappear: !_marketPlaceIsEmpty &&
                                      !_marketPlaceFocused,
                                  onFieldSubmit: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_placeNameNode);
                                  },
                                  action: TextInputAction.done,
                                  isPhoneNumber: false,
                                  isPassword: false,
                                  type: TextInputType.text,
                                  isFocus: _marketPlaceFocused,
                                  focusNode: _marketPlaceNode,
                                  validator: (String? output) {
                                    if (!isButtonPressed) {
                                      return null;
                                    }
                                    isError = true;
                                    if (output!.isEmpty) {
                                      return 'من فضلك ادخل العلامة المميزة';
                                    }
                                    isError = false;
                                    return null;
                                  },
                                  onSave: (String? saved) {
                                    _landmark = saved;
                                  },
                                  labelText: 'علامة مميزة',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          EditText(
                            readOnly: false,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                            radius: 15.0,
                            controller: _placeNameController,
                            upperTitle: true,
                            type: TextInputType.text,
                            onChange: (String? value) {
                              isButtonPressed = false;
                              if (isError) {
                                formState.currentState!.validate();
                              }
                              setState(() {
                                _placeNameIsEmpty = value!.isEmpty;
                              });
                            },
                            shouldDisappear:
                                !_placeNameFocused && !_placeNameIsEmpty,
                            action: TextInputAction.done,
                            onFieldSubmit: (_) {
                              _placeNameNode.unfocus();
                            },
                            isPhoneNumber: false,
                            isPassword: false,
                            isFocus: _placeNameFocused,
                            focusNode: _placeNameNode,
                            validator: (String? output) {
                              if (!isButtonPressed) {
                                return null;
                              }
                              isError = true;
                              if (output!.isEmpty) {
                                return 'من فضلك ادخل اسم المكان';
                              }
                              isError = false;
                              return null;
                            },
                            onSave: (String? saved) {
                              _placeName = saved;
                            },
                            labelText: 'اسم المكان',
                            hintColor: Colors.grey,
                            hintFontSize: 12.0,
                            hintText: 'مثال المنزل, المخزن, فرع المعادي',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    WeevoButton(
                      isStable: true,
                      color: weevoPrimaryOrangeColor,
                      weight: FontWeight.w700,
                      onTap: () async {
                        isButtonPressed = true;
                        if (formState.currentState!.validate()) {
                          formState.currentState!.save();
                          mapProvider.setAddressLoading(true);
                          if (widget.isUpdated) {
                            await mapProvider.updateAddress(
                              Address(
                                id: widget.address?.id,
                                name: _placeName,
                                street: _street,
                                landmark: _landmark,
                                floor: _floor,
                                apartment: _apartment,
                                state: _state,
                                buildingNumber: _building,
                                lat: _lat,
                                merchantId: int.parse(authProvider.id!),
                                lng: _long,
                                city: _city,
                              ),
                            );
                          } else {
                            await mapProvider.addAddress(
                              Address(
                                name: _placeName,
                                street: _street,
                                landmark: _landmark,
                                floor: _floor,
                                apartment: _apartment,
                                state: _state,
                                buildingNumber: _building,
                                merchantId: int.parse(authProvider.id!),
                                lat: _lat,
                                lng: _long,
                                city: _city,
                              ),
                            );
                          }
                          if (mapProvider.state == NetworkState.SUCCESS) {
                            await mapProvider.getAllAddress(
                              true,
                            );
                            await updateProvider.updateCurrentAddressId(
                              addressId: mapProvider.address!.last.id,
                              currentPassword: authProvider.password!,
                            );
                            await authProvider
                                .setAddressId(mapProvider.address!.last.id!);
                            mapProvider.setCurrentAddressId(
                                mapProvider.address!.last.id!);
                            mapProvider.setFullAddress(mapProvider.address!
                                .where(
                                    (i) => i.id == mapProvider.address!.last.id)
                                .first);
                            Navigator.pushReplacementNamed(
                              navigator.currentContext!,
                              MerchantAddress.id,
                            );
                          } else if (mapProvider.state == NetworkState.ERROR) {
                            showDialog(
                              context: navigator.currentContext!,
                              builder: (BuildContext context) => ActionDialog(
                                content: 'تأكد من الاتصال بشبكة الانترنت',
                                cancelAction: 'حسناً',
                                onCancelClick: () {
                                  MagicRouter.pop();
                                },
                              ),
                            );
                          } else if (mapProvider.state == NetworkState.LOGOUT) {
                            check(
                                auth: authProvider,
                                ctx: navigator.currentContext!,
                                state: mapProvider.state);
                          }
                          mapProvider.setAddressLoading(false);
                        }
                      },
                      title: widget.isUpdated ? 'تعديل العنوان' : 'حفظ العنوان',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
