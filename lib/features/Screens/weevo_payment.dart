import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Models/pay_type.dart';
import '../../core/Models/plus_plan.dart';
import '../../core/Models/weevo_plus_payment.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/weevo_button.dart';
import 'end_payment.dart';

class WeevoPlusPayment extends StatefulWidget {
  static const String id = 'Weevo_Plus_Payment';
  final PlusPlan plusPlan;

  const WeevoPlusPayment({
    super.key,
    required this.plusPlan,
  });

  @override
  State<WeevoPlusPayment> createState() => _WeevoPlusPaymentState();
}

class _WeevoPlusPaymentState extends State<WeevoPlusPayment> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/logoplus.png',
            height: 125,
            width: 125,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () {
              MagicRouter.pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21.0),
                  border: Border.all(
                    width: 1.5,
                    color: weevoButterColor,
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.plusPlan.slug!.split('-')[
                                  widget.plusPlan.slug!.split('-').length -
                                      2] ==
                              '1'
                          ? Text(
                              'خطة ${widget.plusPlan.slug!.split('-')[widget.plusPlan.slug!.split('-').length - 2]} شهر',
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                height: 0.85,
                              ),
                              textAlign: TextAlign.right,
                            )
                          : Text(
                              'خطة ${widget.plusPlan.slug!.split('-')[widget.plusPlan.slug!.split('-').length - 2]} شهور',
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                height: 0.85,
                              ),
                              textAlign: TextAlign.right,
                            ),
                      Container(
                          padding: const EdgeInsets.all(
                            16.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: weevoButterColor,
                            boxShadow: [
                              BoxShadow(
                                color: weevoPrimaryOrangeColor.withOpacity(0.1),
                                offset: const Offset(0, 0),
                                blurRadius: 12.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${widget.plusPlan.price} ',
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  height: 0.87,
                                ),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                'جنية',
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  height: 0.87,
                                ),
                              ),
                            ],
                          )),
                    ]),
              ),
              Column(
                children: payTypes
                    .map(
                      (PayType e) => Card(
                        elevation: 1.0,
                        shadowColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                          activeColor: weevoButterColor,
                          value: payTypes.indexOf(e),
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                          title: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(e.title),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Image.asset(
                                    e.icon,
                                    height: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              WeevoButton(
                onTap: () {
                  Navigator.pushNamed(context, EndPayment.id,
                      arguments: WeevoPlusPaymentObject(
                        plusPlan: widget.plusPlan,
                        selectedValue: selectedValue!,
                      ));
                },
                title: 'ادفع',
                color: weevoPrimaryOrangeColor,
                isStable: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
