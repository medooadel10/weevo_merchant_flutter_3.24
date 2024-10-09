import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/Providers/wallet_provider.dart';
import '../../../core/Utilits/colors.dart';

class WithdrawDone extends StatelessWidget {
  const WithdrawDone({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/pay_wallet.png',
            height: 250.0,
            width: 300.0,
          ),
          SizedBox(
            height: 10.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تم طلب سحب ',
                style: TextStyle(
                  color: weevoDarkBlue,
                  fontSize: 25.0.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${walletProvider.withdrawalAmount}',
                style: TextStyle(
                  color: weevoPrimaryOrangeColor,
                  fontSize: 30.0.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' جنية',
                style: TextStyle(
                  color: weevoDarkBlue,
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            'سيتم تحويل مبلغ السحب خلال 24 ساعة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: weevoDarkBlue,
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
