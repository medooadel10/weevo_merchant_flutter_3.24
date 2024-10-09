import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/router/router.dart';
import 'weevo_plus_screen.dart';

class WeevoPlusPlanSubscription extends StatelessWidget {
  static const String id = 'Weevo_Plus_Plan_Subscription';

  const WeevoPlusPlanSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              MagicRouter.pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
          title: Image.asset(
            'assets/images/weevo_plus_app_title.png',
            height: 80.0.h,
            width: 80.0.h,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 6.0,
            vertical: 6.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: const Color(0xffFFEFE7),
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
                                  : Preferences.instance.getWeevoPlusPlanId ==
                                          '3'
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
                            value: DateTime.parse(Preferences
                                        .instance.getWeevoPlusEndDate)
                                    .difference(DateTime.now())
                                    .inDays /
                                30,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            'تنتهي في ${intl.DateFormat('dd/MM/yyyy').format(DateTime.parse(Preferences.instance.getWeevoPlusEndDate))}',
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
              SizedBox(
                height: 10.0.h,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: const Color(0xffFFEFE7),
                ),
                height: 200.h,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        3,
                        (i) => Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: weevoPrimaryOrangeColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            i == 0
                                ? const Text(
                                    'عدد اوردرات غير محدود',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : i == 1
                                    ? const Text(
                                        'وصل شحنتك لعدد أكبر من الكباتن',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : const Text(
                                        'شحنتك دايما مميزة',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, WeevoPlus.id,
                              arguments: true);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xffFC8449)),
                          minimumSize:
                              WidgetStateProperty.all<Size>(Size(170.w, 45.h)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0))),
                        ),
                        child: const Text(
                          'اعرف اكثر',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                      )
                    ]),
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
