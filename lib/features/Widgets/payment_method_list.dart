import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Models/payment_method.dart';
import '../../core/Utilits/colors.dart';

class PaymentMethodList extends StatelessWidget {
  final Function onItemClick;
  final List<Payment> paymentMethods;
  final int selectedItem;

  const PaymentMethodList({
    super.key,
    required this.onItemClick,
    required this.paymentMethods,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'قول لنا عاوز تستلم فلوس طلبك ازاي ؟',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: paymentMethods
                .map((item) => Expanded(
                      child: GestureDetector(
                        onTap: () => onItemClick(
                          item.paymentMethodTitle,
                          paymentMethods.indexOf(item),
                        ),
                        child: Card(
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          margin: const EdgeInsets.all(
                            20.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border:
                                  selectedItem == paymentMethods.indexOf(item)
                                      ? Border.all(
                                          color: weevoPrimaryOrangeColor,
                                          width: 2,
                                        )
                                      : null,
                              borderRadius: BorderRadius.circular(
                                12.0.r,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  item.paymentMethodIcon,
                                  width: 80.0.w,
                                  height: 80.0.h,
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  item.paymentMethodTitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
