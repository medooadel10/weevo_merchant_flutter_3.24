import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Models/transaction_data.dart';
import 'credit_deduct_trailling_widget.dart';
import 'credit_leading_icon.dart';

class CreditDeductItem extends StatelessWidget {
  final TransactionData data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'غرامة رقم ${data.details?.id}',
        style: TextStyle(
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        data.details?.description ?? '',
        style: TextStyle(
          fontSize: 14.0.sp,
          color: Colors.black,
        ),
      ),
      leading: const CreditLeadingIcon(),
      trailing: CreditDeductTrailingWidget(
        data: data,
      ),
    );
  }

  const CreditDeductItem({
    super.key,
    required this.data,
  });
}
