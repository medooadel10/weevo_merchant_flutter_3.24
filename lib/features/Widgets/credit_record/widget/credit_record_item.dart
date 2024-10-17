import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/Models/transaction_data.dart';
import 'credit_leading_icon.dart';
import 'credit_trailling_widget.dart';

class CreditRecordItem extends StatelessWidget {
  final TransactionData data;
  final int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        index == 0
            ? 'طلب رقم ${data.details?.id}'
            : 'طلب رقم ${data.details?.id}',
        style: TextStyle(
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        DateFormat('dd/MM/yyyy hh:mm a', 'ar_EG')
            .format(DateTime.parse(data.dateTime!)),
        style: TextStyle(
          fontSize: 14.0.sp,
          color: Colors.grey,
        ),
      ),
      leading: const CreditLeadingIcon(),
      trailing: CreditTrailingWidget(
        data: data,
      ),
    );
  }

  const CreditRecordItem({
    super.key,
    required this.data,
    required this.index,
  });
}
