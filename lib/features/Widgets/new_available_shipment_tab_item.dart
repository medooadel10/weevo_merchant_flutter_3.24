import 'package:flutter/material.dart';

import '../../core/Utilits/colors.dart';

class NewAvailableShipmentTabItem extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const NewAvailableShipmentTabItem({
    super.key,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: index == selectedIndex
                ? weevoPrimaryOrangeColor.withOpacity(0.1)
                : Colors.grey[100]),
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 6.0,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: index == selectedIndex ? Colors.black : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
