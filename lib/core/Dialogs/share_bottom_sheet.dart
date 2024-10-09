import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/Widgets/edit_text.dart';
import '../Models/state.dart';
import '../Providers/add_shipment_provider.dart';

class StateBottomSheet extends StatefulWidget {
  final Function onPress;
  final List<States> states;

  const StateBottomSheet({
    super.key,
    required this.onPress,
    required this.states,
  });

  @override
  State<StateBottomSheet> createState() => _StateBottomSheetState();
}

class _StateBottomSheetState extends State<StateBottomSheet> {
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
                shipmentProvider.filterStates(widget.states, value ?? '');
              },
              labelText: 'ادخل اسم المدينة',
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
                    itemCount: shipmentProvider.statesFilterList.length,
                    itemBuilder: (context, i) => ListTile(
                      onTap: () =>
                          widget.onPress(shipmentProvider.statesFilterList[i]),
                      title:
                          Text(shipmentProvider.statesFilterList[i].name ?? ''),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.states.length,
                    itemBuilder: (context, i) => ListTile(
                      onTap: () => widget.onPress(widget.states[i]),
                      title: Text(widget.states[i].name ?? ''),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
