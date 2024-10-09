import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class ShipmentToPublicDialog extends StatelessWidget {
  const ShipmentToPublicDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/bicycle_guy_1500px_resized.png',
                  height: 200.0,
                  width: 200.0,
                ),
                const Positioned(
                    left: 20.0,
                    top: 30.0,
                    child: CircleAvatar(
                      radius: 12.0,
                      backgroundColor: weevoPrimaryOrangeColor,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'تم أضافة شحنتك في ويفو',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'المناديب هتقدم عليها في اقرب وقت',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
