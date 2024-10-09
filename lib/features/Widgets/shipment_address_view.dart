import 'package:flutter/material.dart';

import '../../core/Models/address.dart';
import '../../core/Utilits/colors.dart';

class ShipmentAddressView extends StatelessWidget {
  final Address address;
  final bool isPicked;

  const ShipmentAddressView({
    super.key,
    required this.address,
    required this.isPicked,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      elevation: 1.0,
      shadowColor: weevoGreyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  address.name ?? '',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.end,
                ),
                SizedBox(
                  height: size.height * 0.001,
                ),
                Text(
                  address.state ?? '',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.001,
                ),
                Text(
                  '${address.buildingNumber} ${address.street} - الدور ${address.floor} - شقة ${address.apartment} \nعلامة مميزة: ${address.landmark}',
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: CircleAvatar(
              radius: 12.0,
              backgroundColor:
                  isPicked ? weevoPrimaryOrangeColor : weevoDarkGreyColor,
              child: isPicked
                  ? const Icon(
                      Icons.done,
                      color: Colors.white,
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
