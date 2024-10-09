import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class WeevoPlusPaymentDialog extends StatelessWidget {
  final String msg;
  final VoidCallback onPress;

  const WeevoPlusPaymentDialog({
    super.key,
    required this.msg,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              msg,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.0.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onPress,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('حسناً'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
