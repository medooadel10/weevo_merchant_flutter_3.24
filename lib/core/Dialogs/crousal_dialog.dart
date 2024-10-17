import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../features/Widgets/video_item.dart';
import '../../features/Widgets/weevo_button.dart';
import '../Providers/auth_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';

class CarouselDialog extends StatefulWidget {
  const CarouselDialog({super.key});

  @override
  State<CarouselDialog> createState() => _CarouselDialogState();
}

class _CarouselDialogState extends State<CarouselDialog> {
  final Preferences _pref = Preferences.instance;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'كيف تستخدم ويفو',
                  style: TextStyle(
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.w600,
                      color: weevoPrimaryOrangeColor),
                ),
                SizedBox(
                  height: 12.h,
                ),
                CarouselSlider(
                  items: List.generate(
                    authProvider.groupBanner != null
                        ? authProvider.groupBanner![2].banners!.length
                        : 0,
                    (int i) => VideoItem(
                      i: i,
                    ),
                  ),
                  options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 1.5,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      viewportFraction: 1,
                      onPageChanged:
                          (int i, CarouselPageChangedReason reason) {}),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                    height: 40.h,
                    child: WeevoButton(
                      onTap: () {
                        Navigator.pop(navigator.currentContext!);
                        _pref.setFirstTime(1);
                      },
                      title: 'حسناً',
                      color: weevoPrimaryOrangeColor,
                      isStable: true,
                      weight: FontWeight.w100,
                    )),
                SizedBox(
                  height: 10.h,
                ),
              ],
            )),
      ),
    );
  }
}
