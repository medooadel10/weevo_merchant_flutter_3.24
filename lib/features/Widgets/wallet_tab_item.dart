import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletTabItem extends StatelessWidget {
  final int selectedItem;
  final int index;
  final VoidCallback onPress;
  final String name;
  final Color indicatorColor;

  const WalletTabItem({
    super.key,
    required this.selectedItem,
    required this.index,
    required this.onPress,
    required this.name,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedItem == index
                ? CircleAvatar(
                    radius: 5,
                    backgroundColor: indicatorColor,
                  )
                : Container(),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selectedItem == index ? Colors.black : Colors.grey,
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
