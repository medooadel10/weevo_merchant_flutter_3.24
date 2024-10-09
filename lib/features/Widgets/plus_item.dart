import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Models/plus_plan.dart';
import '../../core/Utilits/colors.dart';

class PlusItem extends StatelessWidget {
  final int? itemIndex;
  final int? selectedItem;
  final PlusPlan? plusPlan;
  final VoidCallback? onPressed;

  const PlusItem({
    super.key,
    this.itemIndex,
    this.selectedItem,
    this.plusPlan,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: selectedItem == itemIndex ? weevoTransGreen : Colors.white,
            borderRadius: BorderRadius.circular(21.0),
            border: Border.all(
              width: 1.5,
              color: selectedItem == itemIndex ? weevoDarkGreen : Colors.grey,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '${plusPlan!.price} ',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              height: 0.87,
                            ),
                            children: const [
                              TextSpan(text: 'جنية'),
                            ],
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          height: size.height * .01,
                        ),
                        RichText(
                          text: TextSpan(
                            text: '${plusPlan!.oldPrice} ',
                            style: TextStyle(
                                fontSize: 16.0.sp,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w400,
                                height: 0.87,
                                decoration: TextDecoration.lineThrough),
                            children: const [
                              TextSpan(text: 'جنية'),
                            ],
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        plusPlan!.slug!.split('-')[
                                    plusPlan!.slug!.split('-').length - 2] ==
                                '1'
                            ? Text(
                                'خطة ${plusPlan!.slug!.split('-')[plusPlan!.slug!.split('-').length - 2]} شهر',
                                style: TextStyle(
                                  fontSize: 15.0.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  height: 0.85,
                                ),
                                textAlign: TextAlign.right,
                              )
                            : Text(
                                'خطة ${plusPlan!.slug!.split('-')[plusPlan!.slug!.split('-').length - 2]} شهور',
                                style: TextStyle(
                                  fontSize: 15.0.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  height: 0.85,
                                ),
                                textAlign: TextAlign.right,
                              ),
                      ],
                    )
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
