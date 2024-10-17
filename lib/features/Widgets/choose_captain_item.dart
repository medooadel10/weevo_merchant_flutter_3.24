import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/router/router.dart';
import 'weevo_button.dart';

class ChooseCaptainItem extends StatelessWidget {
  const ChooseCaptainItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shadowColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 12.0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/delivery-truck.png',
                              height: 40.0,
                              width: 40.0,
                            ),
                            const SizedBox(
                              height: 6.0,
                            ),
                            const Row(
                              children: [
                                Text(
                                  'SUZUKI',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black),
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  'M50',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'يقرب منك بحاولي 10 دقائق',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Image.asset(
                                  'assets/images/car_far_away.png',
                                  height: 22.0,
                                  width: 22.0,
                                ),
                              ],
                            ),
                            const Text(
                              'أحمد محمد عبدالله',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RatingBar.builder(
                                  initialRating: double.parse('3'),
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: weevoLightYellow,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                const SizedBox(width: 8.0),
                                const Text(
                                  '3.0',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  WeevoButton(
                    onTap: () {
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (context) => Dialog(
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
                                Image.asset(
                                  'assets/images/bike_man_confirmation.png',
                                  height: 200.0,
                                  width: 200.0,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const Text(
                                  'ننصحك بتنزيل الطلب\nفي صفحة المناديب',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                            weevoLightPurpleColor,
                                          ),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                12.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          MagicRouter.pop();
                                        },
                                        child: const Text(
                                          'ذكرني لاحقاً',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0.w,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                            weevoPrimaryOrangeColor,
                                          ),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                              12.0,
                                            )),
                                          ),
                                        ),
                                        onPressed: () {
                                          MagicRouter.pop();
                                        },
                                        child: const Text(
                                          'موافق',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    radius: 12.0,
                    title: 'اختيار الكابتن',
                    color: weevoPrimaryOrangeColor,
                    isStable: true,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
                child: Image.asset(
                  'assets/images/weevo_captain_1.png',
                  height: 130.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
