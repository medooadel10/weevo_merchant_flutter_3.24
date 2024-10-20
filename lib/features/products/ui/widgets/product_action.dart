import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProductAction extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  const ProductAction({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0.r),
          border: Border.all(
            color: Colors.grey[500]!,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 5.0.w,
          vertical: 5.0.h,
        ),
        child: SvgPicture.asset(
          icon,
        ),
      ),
    );
  }
}
