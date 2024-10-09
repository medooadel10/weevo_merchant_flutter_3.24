import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Utilits/colors.dart';

class UserAccountTypeWidget extends StatelessWidget {
  final Function onItemClick;
  final int selectedItem;
  final String title;
  final int index;

  const UserAccountTypeWidget({
    super.key,
    required this.onItemClick,
    required this.selectedItem,
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.r)),
      tileColor:
          selectedItem == index ? const Color(0xFFD8F3FF) : Colors.grey[200],
      onTap: () => onItemClick(
        title,
        index,
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: selectedItem == index ? weevoPrimaryBlueColor : Colors.grey,
          fontSize: 16.0.sp,
          fontWeight: selectedItem == index ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
