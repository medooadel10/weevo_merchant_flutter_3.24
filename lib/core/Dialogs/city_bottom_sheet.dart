import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/Widgets/edit_text.dart';
import '../Models/city.dart';
import '../Providers/add_shipment_provider.dart';

class CityBottomSheet extends StatefulWidget {
  final Function onPress;
  final List<Cities> cities;

  const CityBottomSheet({
    super.key,
    required this.onPress,
    required this.cities,
  });

  @override
  State<CityBottomSheet> createState() => _CityBottomSheetState();
}

class _CityBottomSheetState extends State<CityBottomSheet> {
  bool _searchFocused = false;
  late FocusNode _searchNode;

  @override
  void initState() {
    super.initState();
    _searchNode = FocusNode();
    _searchNode.addListener(() {
      _searchFocused = _searchNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: EditText(
              readOnly: false,
              suffix: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              validator: (String? value) {
                return null;
              },
              onSave: (String? value) {},
              onChange: (String? value) {
                shipmentProvider.filterCities(widget.cities, value ?? '');
              },
              labelText: 'ادخل اسم المنطقة',
              isFocus: _searchFocused,
              focusNode: _searchNode,
              radius: 12.0,
              isPassword: false,
              isPhoneNumber: false,
              shouldDisappear: false,
              upperTitle: false,
            ),
          ),
          Expanded(
            child: _searchFocused
                ? ListView.builder(
                    itemBuilder: (context, i) => ListTile(
                      onTap: () =>
                          widget.onPress(shipmentProvider.citiesFilterList[i]),
                      title:
                          Text(shipmentProvider.citiesFilterList[i].name ?? ''),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                    ),
                    itemCount: shipmentProvider.citiesFilterList.length,
                  )
                : ListView.builder(
                    itemBuilder: (context, i) => ListTile(
                      onTap: () => widget.onPress(widget.cities[i]),
                      title: Text(widget.cities[i].name ?? ''),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                    ),
                    itemCount: widget.cities.length,
                  ),
          ),
        ],
      ),
    );
  }
}
