import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/content_dialog.dart';
import '../../core/Dialogs/loading.dart';
import '../../core/Models/plan_subscription.dart';
import '../../core/Models/transaction_webview_model.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/weevo_plus_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core_new/router/router.dart';
import '../Widgets/weevo_button.dart';
import 'home.dart';
import 'transaction_webview.dart';

class CreditCardPayment extends StatelessWidget {
  final PlanSubscription planSubscription;
  final int selectedValue;

  const CreditCardPayment({
    super.key,
    required this.planSubscription,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final WeevoPlusProvider weevoPlusProvider =
        Provider.of<WeevoPlusProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  planSubscription.plan!.slug!.split('-')[
                              planSubscription.plan!.slug!.split('-').length -
                                  2] ==
                          '1'
                      ? Text(
                          'خطة ${planSubscription.plan!.slug!.split('-')[planSubscription.plan!.slug!.split('-').length - 2]} شهر',
                          style: TextStyle(
                            fontSize: 15.0.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            height: 0.85,
                          ),
                          textAlign: TextAlign.right,
                        )
                      : Text(
                          'خطة ${planSubscription.plan!.slug!.split('-')[planSubscription.plan!.slug!.split('-').length - 2]} شهور',
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
                            '${planSubscription.plan!.price} ',
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
          WeevoButton(
            isStable: true,
            color: weevoPrimaryOrangeColor,
            weight: FontWeight.w700,
            onTap: () async {
              showDialog(
                  context: navigator.currentContext!,
                  barrierDismissible: false,
                  builder: (context) => const Loading());
              await weevoPlusProvider.payUsingCreditCard(
                transactionId: planSubscription.cachedTransactionId!,
              );
              if (weevoPlusProvider.state == NetworkState.SUCCESS) {
                if (weevoPlusProvider.creditCard!.checkoutUrl != null) {
                  MagicRouter.pop();
                  dynamic value = await Navigator.pushNamed(
                      navigator.currentContext!, TransactionWebView.id,
                      arguments: TransactionWebViewModel(
                          url: weevoPlusProvider.creditCard!.checkoutUrl!,
                          selectedValue: selectedValue));
                  if (value != null && value == true) {
                    log('${weevoPlusProvider.creditCard!.transaction!.subscription!.planId}');
                    showDialog(
                        context: navigator.currentContext!,
                        barrierDismissible: false,
                        builder: (context) => const Loading());
                    await Preferences.instance.setWeevoPlusPlanId(
                        weevoPlusProvider
                            .creditCard!.transaction!.subscription!.planId
                            .toString());
                    await Preferences.instance.setWeevoPlusEndDate(
                        weevoPlusProvider
                            .creditCard!.transaction!.subscription!.endsAt!);
                    MagicRouter.pop();
                    showDialog(
                        context: navigator.currentContext!,
                        barrierDismissible: false,
                        builder: (context) => ContentDialog(
                              content: 'تم الأشتراك بنجاح',
                              callback: () {
                                MagicRouter.pop();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, Home.id, (route) => false);
                              },
                            ));
                  } else {
                    showDialog(
                      context: navigator.currentContext!,
                      barrierDismissible: false,
                      builder: (context) => ContentDialog(
                        content: 'حدث خطأ حاول مرة اخري',
                        callback: () {
                          MagicRouter.pop();
                        },
                      ),
                    );
                  }
                }
              } else if (weevoPlusProvider.state == NetworkState.LOGOUT) {
                check(
                    auth: authProvider,
                    ctx: navigator.currentContext!,
                    state: weevoPlusProvider.state!);
              } else {
                MagicRouter.pop();
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => ContentDialog(
                    content: 'حدث خطأ برحاء المحاولة مرة اخري',
                    callback: () {
                      MagicRouter.pop();
                    },
                  ),
                );
              }
            },
            title: 'ادفع',
          ),
        ],
      ),
    );
  }
}
