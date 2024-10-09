import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Models/weevo_plus_payment.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/weevo_plus_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import 'credit_card_payment.dart';
import 'e_wallet_payment.dart';
import 'meza_payment.dart';

class EndPayment extends StatefulWidget {
  static const String id = 'End_Payment';
  final WeevoPlusPaymentObject value;

  const EndPayment({
    super.key,
    required this.value,
  });

  @override
  State<EndPayment> createState() => _EndPaymentState();
}

class _EndPaymentState extends State<EndPayment> {
  late WeevoPlusProvider _weevoPlusProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _weevoPlusProvider = Provider.of<WeevoPlusProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _weevoPlusProvider.planSubscription(planId: widget.value.plusPlan.id!);
    check(auth: _authProvider, state: _weevoPlusProvider.state!, ctx: context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: Consumer<WeevoPlusProvider>(
          builder: (ctx, data, child) => data.state == NetworkState.WAITING
              ? const Center(
                  child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
                ))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: widget.value.selectedValue == 0
                            ? MezaPayment(
                                planSubscription: data.planSub!,
                                selectedValue: widget.value.selectedValue)
                            : widget.value.selectedValue == 1
                                ? EWAlletPayment(
                                    planSubscription: data.planSub!,
                                    selectedValue: widget.value.selectedValue)
                                : CreditCardPayment(
                                    planSubscription: data.planSub!,
                                    selectedValue: widget.value.selectedValue),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
