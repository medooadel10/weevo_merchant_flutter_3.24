import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/wallet_provider.dart';
import '../../core/Utilits/colors.dart';

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
        children: [
          Image.asset(
            'assets/images/pay_wallet.png',
            fit: BoxFit.contain,
            height: 250.0,
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'تم طلب سحب',
            style: TextStyle(
              color: weevoDarkBlue,
              fontSize: 30.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                walletProvider.withdrawalAmount.toString(),
                style: const TextStyle(
                  color: weevoDarkBlue,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 2.0,
              ),
              const Text(
                'EGP',
                style: TextStyle(
                  color: weevoLightOrange,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Text(
            'سيتم أضافته لمحفظتك\nعندما تكمل عملية السحب',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: weevoDarkBlue,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
