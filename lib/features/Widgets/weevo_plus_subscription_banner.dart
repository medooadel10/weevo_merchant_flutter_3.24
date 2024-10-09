import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/Storage/shared_preference.dart';
import '../Screens/weevo_plus_plan_subscription.dart';

class WeevoPlusSubscriptionBanner extends StatelessWidget {
  const WeevoPlusSubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            WeevoPlusPlanSubscription.id,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color(0xffFFEEE6),
          ),
          height: 90.h,
          width: size.width,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                ),
                child: Image.asset(
                  'assets/images/weevo_subscription_plus_plan.png',
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Preferences.instance.getWeevoPlusPlanId == '1'
                        ? const Text(
                            'انت علي خطة 1 شهر',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Preferences.instance.getWeevoPlusPlanId == '2'
                            ? const Text(
                                'انت علي خطة 3 شهور',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Preferences.instance.getWeevoPlusPlanId == '3'
                                ? const Text(
                                    'انت علي خطة 6 شهور',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : const Text(
                                    'انت علي خطة 12 شهور',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                    SizedBox(
                      height: 6.h,
                    ),
                    LinearProgressIndicator(
                      backgroundColor: const Color(0xffF5D3C1),
                      color: const Color(0xffED7230),
                      value: DateTime.parse(
                                  Preferences.instance.getWeevoPlusEndDate)
                              .difference(DateTime.now())
                              .inDays /
                          30,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'تنتهي في ${DateFormat('dd/MM/yyyy').format(DateTime.parse(Preferences.instance.getWeevoPlusEndDate))}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
