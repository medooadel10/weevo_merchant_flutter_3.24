import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../../../core/Providers/wallet_provider.dart';
import '../../../core/Utilits/colors.dart';
import '../wallet_tab_item.dart';

class WalletCreditRecord extends StatefulWidget {
  const WalletCreditRecord({super.key});

  @override
  State<WalletCreditRecord> createState() => _WalletCreditRecordState();
}

class _WalletCreditRecordState extends State<WalletCreditRecord> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar_EG');
  }

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 25.0,
            left: 12.0,
            right: 12.0,
            bottom: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WalletTabItem(
                name: 'منتظرة',
                index: 0,
                selectedItem: walletProvider.creditMainIndex,
                onPress: () {
                  walletProvider.setCreditMainIndex(0);
                  walletProvider.resetCreditPendingFilter();
                },
                indicatorColor: weevoLightPurple,
              ),
              WalletTabItem(
                name: 'مقبولة',
                index: 1,
                onPress: () {
                  walletProvider.setCreditMainIndex(1);
                  walletProvider.resetCreditApprovedFilter();
                },
                selectedItem: walletProvider.creditMainIndex,
                indicatorColor: weevoLightPurple,
              ),
              WalletTabItem(
                name: 'مدفوعات',
                index: 2,
                onPress: () {
                  walletProvider.setCreditMainIndex(2);
                  walletProvider.resetCreditApprovedFilter();
                },
                selectedItem: walletProvider.creditMainIndex,
                indicatorColor: weevoLightPurple,
              ),
            ],
          ),
        ),
        Expanded(child: walletProvider.creditMainWidget),
      ],
    );
  }
}
