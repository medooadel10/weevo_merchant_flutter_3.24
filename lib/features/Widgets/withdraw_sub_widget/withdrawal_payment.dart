import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/Dialogs/action_dialog.dart';
import '../../../core/Providers/wallet_provider.dart';
import '../../../core/Storage/shared_preference.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/router/router.dart';
import '../cash_out_widget.dart';
import '../loading_widget.dart';
import '../weevo_button.dart';

class WithdrawPayment extends StatelessWidget {
  const WithdrawPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return LoadingWidget(
      isLoading: walletProvider.loading,
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'اختر طريقة السحب',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey[500],
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: CashOutWidget(),
            ),
            SizedBox(
              height: size.height * .01,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WeevoButton(
                isStable: true,
                color: weevoPrimaryOrangeColor,
                weight: FontWeight.w700,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (walletProvider.accountTypeIndex == 0) {
                    walletProvider.setWithdrawIndex(2);
                  } else if (walletProvider.accountTypeIndex == 1) {
                    walletProvider.setWithdrawIndex(3);
                  } else if (walletProvider.accountTypeIndex == 2) {
                    walletProvider.setWithdrawIndex(4);
                  } else {
                    showDialog(
                      context: navigator.currentContext!,
                      builder: (context) => ActionDialog(
                        content: 'عليك اختيار نوع الحساب',
                        onCancelClick: () {
                          MagicRouter.pop();
                        },
                        cancelAction: 'حسناً',
                      ),
                    );
                  }
                },
                title: 'طلب السحب',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
