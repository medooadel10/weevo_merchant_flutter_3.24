import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/Screens/map.dart';
import '../../features/Widgets/shipment_address_view.dart';
import '../Models/address.dart';
import '../Providers/auth_provider.dart';
import '../Providers/map_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../router/router.dart';

class BottomSheetLocationPicker extends StatefulWidget {
  static String id = 'LocationPicker';
  final String fromWhere;
  final Function(Address)? onLocationClick;

  const BottomSheetLocationPicker({
    super.key,
    required this.fromWhere,
    this.onLocationClick,
  });

  @override
  State<BottomSheetLocationPicker> createState() =>
      _BottomSheetLocationPickerState();
}

class _BottomSheetLocationPickerState extends State<BottomSheetLocationPicker> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mapProvider = Provider.of<MapProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
            ),
            itemCount: mapProvider.address?.length,
            itemBuilder: (context, i) => GestureDetector(
                onTap: () {
                  mapProvider.setCurrentAddressId(mapProvider.address![i].id!);
                  mapProvider.setFullAddress(mapProvider.address!
                      .where((i) => i.id == mapProvider.currentAddressId)
                      .first);
                  if (widget.fromWhere == from_shipment_map) {
                    if (widget.onLocationClick != null) {
                      widget.onLocationClick!(mapProvider.address![i]);
                    }
                  } else {
                    MagicRouter.pop();
                  }
                },
                child: ShipmentAddressView(
                  isPicked: mapProvider.currentAddressId != null
                      ? mapProvider.address?.indexOf(mapProvider.address!
                              .where((item) =>
                                  item.id == mapProvider.currentAddressId)
                              .first) ==
                          i
                      : authProvider.addressId != -1
                          ? mapProvider.address?.indexOf(mapProvider.address!
                                  .where((item) =>
                                      item.id == authProvider.addressId)
                                  .first) ==
                              i
                          : !mapProvider.addressIsEmpty!
                              ? mapProvider.address
                                      ?.indexOf(mapProvider.address!.last) ==
                                  i
                              : false,
                  address: mapProvider.address![i],
                )),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.fromWhere == from_home_map) {
                  mapProvider.setFrom(from_home_map);
                  MagicRouter.pop();
                  Navigator.pushNamed(context, MapScreen.id, arguments: false);
                } else {
                  mapProvider.setFrom(from_shipment_map);
                  MagicRouter.pop();
                  Navigator.pushNamed(context, MapScreen.id, arguments: false);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: weevoPrimaryBlueColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    const Text(
                      'أضافة عنوان جديد',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
