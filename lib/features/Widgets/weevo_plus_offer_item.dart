import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';

class WeevoPlusOfferItem extends StatelessWidget {
  final int s;

  const WeevoPlusOfferItem(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                width: 34.0,
                height: 34.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: weevoPrimaryBlueColor,
                ),
                child: Image.asset(
                  offerList[s].assetImage!,
                  height: 25,
                  width: 25,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                offerList[s].title!,
                style: const TextStyle(
                  fontSize: 22.0,
                  color: weevoPrimaryBlueColor,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7.h,
          ),
          Text(
            offerList[s].subtitle!,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            offerList[s].image!,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }
}
