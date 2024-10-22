import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            spreadRadius: 1.0,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: child,
    );
  }
}
