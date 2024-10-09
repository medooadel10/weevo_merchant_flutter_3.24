import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Models/transaction_data.dart';
import '../../../../core/Utilits/colors.dart';

class CreditTrailingWidget extends StatelessWidget {
  final TransactionData data;

  const CreditTrailingWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${data.amount}',
              style: TextStyle(
                fontSize: 14.0.sp,
                color: weevoLightBlackGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              'جنيه',
              style: TextStyle(
                fontSize: 11.0.sp,
                color: weevoLightBlackGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
