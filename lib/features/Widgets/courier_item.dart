import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/api_constants.dart';

import '../../core/Models/courier_offer.dart';
import '../../core/Providers/choose_captain_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core_new/widgets/custom_image.dart';

class CourierItem extends StatefulWidget {
  final CourierOffer courierOffer;
  @override
  final Key key;
  final VoidCallback onAcceptOffer;
  final VoidCallback onBetterOffer;

  const CourierItem({
    required this.key,
    required this.courierOffer,
    required this.onBetterOffer,
    required this.onAcceptOffer,
  }) : super(key: key);

  @override
  State<CourierItem> createState() => _CourierItemState();
}

class _CourierItemState extends State<CourierItem> {
  int? estimateTs, now;
  String? dateString;
  int? start;
  Duration? time;
  String? timeText;
  int? countDownInSecond;
  int? progressCountDownInSecond;
  Timer? _timer;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    // countDownInSecond = DateTime.parse(widget.courierOffer.expiresAt)
    //     .difference(DateTime.now())
    //     .inSeconds;
    timeText = _printDuration(DateTime.parse(widget.courierOffer.expiresAt!)
        .difference(DateTime.now()));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.parse(widget.courierOffer.expiresAt!)
              .difference(DateTime.now())
              .inSeconds ==
          0) {
        timer.cancel();
      } else {
        setState(() {
          timeText = _printDuration(
              DateTime.parse(widget.courierOffer.expiresAt!)
                  .difference(DateTime.now()));
        });
      }
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text(
                              timeText!,
                              style: TextStyle(
                                color: weevoPrimaryBlueColor,
                                fontSize: 26.0.sp,
                                fontWeight: FontWeight.w600,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              'باقي علي انتهاء العرض',
                              style: TextStyle(
                                color: weevoPrimaryBlueColor,
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.courierOffer.driver?.firstName} ${widget.courierOffer.driver?.lastName}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 5.0.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      widget.courierOffer.driver
                                                  ?.vehicleModel !=
                                              null
                                          ? Text(widget.courierOffer.driver!
                                              .vehicleModel!)
                                          : Container(),
                                      SizedBox(
                                        width: 8.0.w,
                                      ),
                                      widget.courierOffer.driver!
                                                  .deliveryMethod ==
                                              'truck'
                                          ? Image.asset(
                                              'assets/images/courier_van_delivery_method.png',
                                              height: 25.0.h,
                                              width: 25.0.w,
                                            )
                                          : widget.courierOffer.driver!
                                                      .deliveryMethod ==
                                                  'car'
                                              ? Image.asset(
                                                  'assets/images/courier_car_delivery_method.png',
                                                  height: 25.0.h,
                                                  width: 25.0.w,
                                                )
                                              : widget.courierOffer.driver!
                                                          .deliveryMethod ==
                                                      'motorbike'
                                                  ? Image.asset(
                                                      'assets/images/courier_motor_cycle_delivery_method.png',
                                                      height: 25.0.h,
                                                      width: 25.0.w,
                                                    )
                                                  : widget.courierOffer.driver!
                                                              .deliveryMethod ==
                                                          'bicycle'
                                                      ? Image.asset(
                                                          'assets/images/courier_bicycle_delivery_method.png',
                                                          height: 25.0.h,
                                                          width: 25.0.w,
                                                        )
                                                      : Container(),
                                    ],
                                  ),
                                  widget.courierOffer.driver!
                                              .cachedAverageRating !=
                                          null
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 8.0.w,
                                            ),
                                            Text(num.parse(widget
                                                    .courierOffer
                                                    .driver!
                                                    .cachedAverageRating!)
                                                .toStringAsFixed(2)),
                                            SizedBox(
                                              width: 4.0.w,
                                            ),
                                            const Icon(
                                              Icons.star_border,
                                              color: weevoStartColor,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        widget.courierOffer.driver!.photo != null &&
                                widget.courierOffer.driver!.photo!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CustomImage(
                                  height: 50.h,
                                  width: 50.h,
                                  imageUrl: widget.courierOffer.driver!.photo!
                                          .contains(ApiConstants.baseUrl)
                                      ? widget.courierOffer.driver!.photo
                                      : '${ApiConstants.baseUrl}${widget.courierOffer.driver!.photo}',
                                ),
                              )
                            : const CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/profile_picture.png',
                                ),
                                radius: 30.0,
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'تكلفة الشحن',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          '${double.parse(widget.courierOffer.offer!).toInt()}',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            color: weevoPrimaryBlueColor,
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          'جنية',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Consumer<ChooseCaptainProvider>(
                      builder: (context, data, child) => Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(12.0),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    weevoOffWhiteOrange),
                              ),
                              onPressed: widget.onAcceptOffer,
                              child: Text(
                                'قبول',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(12.0),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    weevoOffWhiteGrey),
                              ),
                              onPressed: widget.onBetterOffer,
                              child: Text(
                                'عرض أفضل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
