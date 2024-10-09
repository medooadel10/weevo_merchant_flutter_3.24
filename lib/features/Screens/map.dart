import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Models/fill_address_arg.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/map_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/edit_text.dart';
import 'add_address.dart';
import 'merchant_address.dart';

class MapScreen extends StatefulWidget {
  static const String id = "MapScreen";
  final bool fromShipment;

  @override
  State<MapScreen> createState() => _MapScreenState();

  const MapScreen({
    super.key,
    this.fromShipment = false,
  });
}

class _MapScreenState extends State<MapScreen> {
  bool _isFirstTime = true;
  GoogleMapController? _controller;
  String? name;
  late TextEditingController _addressNameController;
  late FocusNode _mapSearchNode;
  bool _mapSearchFocused = false;

  @override
  void initState() {
    super.initState();
    Provider.of<MapProvider>(context, listen: false).initResetCurrentAddress();
    _addressNameController = TextEditingController();
    _mapSearchNode = FocusNode();
    _mapSearchNode.addListener(() {
      setState(() => _mapSearchFocused = _mapSearchNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _addressNameController.dispose();
    _mapSearchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locationData = Provider.of<MapProvider>(context);
    var shipmentProvider = Provider.of<AddShipmentProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if (widget.fromShipment) {
            MagicRouter.pop();
          } else {
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
                  if (locationData.from == from_home_map) {
                    MagicRouter.pop();
                    MagicRouter.pop();
                  } else {
                    MagicRouter.pop();
                    Navigator.pushReplacementNamed(context, MerchantAddress.id);
                  }
                },
                onCancelClick: () {
                  MagicRouter.pop();
                },
                approveAction: 'نعم',
                cancelAction: 'لا',
              ),
            );
          }
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(MapProvider.myLat ?? 0, MapProvider.myLong ?? 0),
                    zoom: 14.0,
                  ),
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  onMapCreated: (control) {
                    log('google map');
                    _controller = control;
                    locationData.getMyLocation(_controller!);
                  },
                  onCameraIdle: () {
                    locationData.setAddressLoading(false);
                    if (!_isFirstTime) {
                      locationData.getFullAddress();
                    }
                  },
                  onCameraMove: (newPosition) {
                    _isFirstTime = false;
                    locationData.setAddressLoading(true);
                    locationData.updateLocation(
                      controller: _controller!,
                      lat: newPosition.target.latitude,
                      long: newPosition.target.longitude,
                      state: MapState.movingCamera,
                    );
                  },
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        right: 8.0,
                        left: 8.0,
                      ),
                      child: Form(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              height: size.height * .07,
                              width: size.width * .14,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 20.0,
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  if (widget.fromShipment) {
                                    MagicRouter.pop();
                                  } else {
                                    showDialog(
                                      context: navigator.currentContext!,
                                      builder: (context) => ActionDialog(
                                        title: 'الخروج',
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                        ),
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
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: EditText(
                                  readOnly: false,
                                  controller: _addressNameController,
                                  onSave: (String? value) {},
                                  onChange: (String? value) {
                                    locationData.getPredictionList(value!);
                                  },
                                  filled: true,
                                  labelText: 'الموقع',
                                  fillColor: Colors.white,
                                  isFocus: _mapSearchFocused,
                                  focusNode: _mapSearchNode,
                                  prefix: locationData.loadingSearchList
                                      ? Container(
                                          padding: const EdgeInsets.all(
                                            12.0,
                                          ),
                                          height: size.height * 0.02,
                                          width: size.height * 0.02,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                  isPassword: false,
                                  isPhoneNumber: false,
                                  shouldDisappear: false,
                                  upperTitle: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    locationData.searchList.isNotEmpty
                        ? Container(
                            color: Colors.white.withOpacity(0.8),
                            height: size.height * 0.3,
                            child: ListView.builder(
                              itemBuilder: (context, i) => ListTile(
                                onTap: () {
                                  locationData.updateLocation(
                                    controller: _controller!,
                                    lat: locationData.searchList[i].lat!,
                                    long: locationData.searchList[i].lang!,
                                    state: MapState.fromSearch,
                                  );
                                  _addressNameController.clear();
                                  _mapSearchNode.unfocus();
                                },
                                title: Text(
                                  locationData.searchList[i].name!,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  locationData.searchList[i].formattedAddress!,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                leading: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.black,
                                ),
                              ),
                              itemCount: locationData.searchList.length,
                            ),
                          )
                        : Container()
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 20.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                locationData.getMyLocation(_controller!);
                              },
                              child: const CircleAvatar(
                                backgroundColor: weevoPrimaryBlueColor,
                                child: Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.all(
                          12.0,
                        ),
                        child: !locationData.addressLoading &&
                                locationData.currentAddress.isNotEmpty
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          locationData.currentAddress,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.03,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (widget.fromShipment) {
                                              if (MapProvider.myLong != null &&
                                                  MapProvider.myLat != null) {
                                                shipmentProvider
                                                        .receiveLocationAddressNameController
                                                        .text =
                                                    locationData.currentAddress;
                                                shipmentProvider
                                                        .receiveLocationLangController
                                                        .text =
                                                    MapProvider.myLong
                                                        .toString();
                                                shipmentProvider
                                                        .receiveLocationLatController
                                                        .text =
                                                    MapProvider.myLat
                                                        .toString();
                                                log('receiveLocationLatController -> ${shipmentProvider.receiveLocationLatController.text}');
                                                log('receiveLocationLangController -> ${shipmentProvider.receiveLocationLangController.text}');
                                                MagicRouter.pop();
                                                shipmentProvider
                                                    .getPriceFromLocation();
                                              } else {
                                                showDialog(
                                                    context: navigator
                                                        .currentContext!,
                                                    builder: (_) =>
                                                        ActionDialog(
                                                          content:
                                                              'من فضلك اختر عنوان التوصيل',
                                                          approveAction:
                                                              'حسناً',
                                                          onApproveClick: () {
                                                            Navigator.pop(navigator
                                                                .currentContext!);
                                                          },
                                                        ));
                                              }
                                            } else {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                AddAddress.id,
                                                arguments: FillAddressArg(
                                                  isUpdated: false,
                                                ),
                                              );
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    weevoPrimaryBlueColor),
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            padding: WidgetStateProperty.all<
                                                EdgeInsetsGeometry>(
                                              const EdgeInsets.all(
                                                12.0,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'تأكيد',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 50.0,
                    ),
                    child: Image.asset(
                      'assets/images/marker.png',
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
