import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../core/Models/shipment_notification.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_image.dart';
import '../../data/models/courier_response_body.dart';
import 'shipping_offer_buttons.dart';

class ShippingOfferTile extends StatefulWidget {
  final ShippingOfferResponseBody courier;
  final ShipmentNotification shipmentNotification;
  const ShippingOfferTile(
      {super.key, required this.courier, required this.shipmentNotification});

  @override
  State<ShippingOfferTile> createState() => _ShippingOfferTileState();
}

class _ShippingOfferTileState extends State<ShippingOfferTile> {
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
    _timer?.cancel();

    super.dispose();
  }

  void startTimer() {
    // countDownInSecond = DateTime.parse(widget.courierOffer.expiresAt)
    //     .difference(DateTime.now())
    //     .inSeconds;
    timeText = _printDuration(
        DateTime.parse(widget.courier.expiresAt).difference(DateTime.now()));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.parse(widget.courier.expiresAt)
              .difference(DateTime.now())
              .inSeconds ==
          0) {
        timer.cancel();
      } else {
        setState(() {
          timeText = _printDuration(DateTime.parse(widget.courier.expiresAt)
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
      child: Column(
        children: [
          Row(
            children: [
              CustomImage(
                imageUrl: widget.courier.driver.photo,
                radius: 100,
                height: 60.0.h,
                width: 60.0.w,
              ),
              horizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.courier.driver.firstName} ${widget.courier.driver.lastName}',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        widget.courier.driver.deliveryMethod == 'truck'
                            ? Image.asset(
                                'assets/images/courier_van_delivery_method.png',
                                height: 25.0.h,
                                width: 25.0.w,
                              )
                            : widget.courier.driver.deliveryMethod == 'car'
                                ? Image.asset(
                                    'assets/images/courier_car_delivery_method.png',
                                    height: 25.0.h,
                                    width: 25.0.w,
                                  )
                                : widget.courier.driver.deliveryMethod ==
                                        'motorbike'
                                    ? Image.asset(
                                        'assets/images/courier_motor_cycle_delivery_method.png',
                                        height: 25.0.h,
                                        width: 25.0.w,
                                      )
                                    : widget.courier.driver.deliveryMethod ==
                                            'bicycle'
                                        ? Image.asset(
                                            'assets/images/courier_bicycle_delivery_method.png',
                                            height: 25.0.h,
                                            width: 25.0.w,
                                          )
                                        : Container(),
                        Expanded(
                          child:
                              widget.courier.driver.cachedAverageRating != null
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 8.0.w,
                                        ),
                                        Text(num.parse(widget.courier.driver
                                                    .cachedAverageRating ??
                                                '4.5')
                                            .toStringAsFixed(2)),
                                        SizedBox(
                                          width: 4.0.w,
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: weevoStartColor,
                                        ),
                                      ],
                                    )
                                  : Container(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              horizontalSpace(20),
              Column(
                children: [
                  Text(
                    timeText ?? '',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w700,
                      color: weevoPrimaryBlueColor,
                    ),
                  ),
                  verticalSpace(2),
                  Text(
                    'باقي على انتهاء العرض',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      color: weevoPrimaryBlueColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تكلفة الشحن',
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              horizontalSpace(3),
              Text(
                widget.courier.offer,
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w600,
                  color: weevoPrimaryBlueColor,
                ),
              ),
              horizontalSpace(3),
              Text(
                'جنية',
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          ShippingOfferButtons(
            data: widget.courier,
            shipmentNotification: widget.shipmentNotification,
          ),
        ],
      ).paddingSymmetric(
        vertical: 10.0.h,
        horizontal: 20.0.w,
      ),
    );
  }
}
