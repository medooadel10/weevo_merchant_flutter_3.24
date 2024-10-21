import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Utilits/colors.dart';

class LoadingDialog extends StatelessWidget {
  final String? loadingContent;

  const LoadingDialog({
    super.key,
    this.loadingContent,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        child: Container(
          height: 80.0,
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              loadingContent != null
                  ? Text(loadingContent!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0.sp,
                      ))
                  : Text('برجاء الأنتظار',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0.sp,
                      )),
              const SpinKitDoubleBounce(
                size: 30,
                color: weevoPrimaryOrangeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
