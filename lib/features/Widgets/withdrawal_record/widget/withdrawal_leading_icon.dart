import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Utilits/colors.dart';

class WithdrawalLeadingIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          14.0.r,
        ),
        color: weevoSilver2,
      ),
      child: Image.asset(
        'assets/images/wallet_small_icon.png',
        height: 25.0.h,
        width: 25.0.w,
      ),
    );
  }

  const WithdrawalLeadingIcon({super.key});
}
