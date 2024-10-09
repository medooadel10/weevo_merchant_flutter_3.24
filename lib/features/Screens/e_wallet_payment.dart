import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/content_dialog.dart';
import '../../core/Dialogs/msg_dialog.dart';
import '../../core/Models/plan_subscription.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/weevo_plus_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core_new/router/router.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/weevo_button.dart';
import 'home.dart';

class EWAlletPayment extends StatefulWidget {
  final PlanSubscription planSubscription;
  final int selectedValue;

  @override
  State<EWAlletPayment> createState() => _EWAlletPaymentState();

  const EWAlletPayment(
      {super.key, required this.planSubscription, required this.selectedValue});
}

class _EWAlletPaymentState extends State<EWAlletPayment> {
  late TextEditingController _numberController;
  late FocusNode _numberNode;
  bool _numberFocused = false, _numberEmpty = true;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? _mobileNumber;
  Timer? _t;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    _numberNode = FocusNode();
    _numberNode.addListener(() {
      setState(() {
        _numberFocused = _numberNode.hasFocus;
      });
    });
    _numberController.addListener(() {
      setState(() {
        _numberEmpty = _numberController.text.isEmpty;
      });
    });
    _numberEmpty = _numberController.text.isEmpty;
  }

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
      child: Form(
        key: _formState,
        child: SingleChildScrollView(
          child: Column(
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
                      widget.planSubscription.plan!.slug!.split('-')[widget
                                      .planSubscription.plan!.slug!
                                      .split('-')
                                      .length -
                                  2] ==
                              '1'
                          ? Text(
                              'خطة ${widget.planSubscription.plan!.slug!.split('-')[widget.planSubscription.plan!.slug!.split('-').length - 2]} شهر',
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                height: 0.85,
                              ),
                              textAlign: TextAlign.right,
                            )
                          : Text(
                              'خطة ${widget.planSubscription.plan!.slug!.split('-')[widget.planSubscription.plan!.slug!.split('-').length - 2]} شهور',
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
                                '${widget.planSubscription.plan!.price} ',
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
              SizedBox(
                height: 60.0.h,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: weevoMizaColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'محفظة الكترونية',
                          style: TextStyle(
                            color: weevoMizaColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'برجاء ادخال رقم المحفظة الالكترونية',
                          style: TextStyle(
                            color: weevoTransGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/mizapay.png',
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              EditText(
                readOnly: false,
                controller: _numberController,
                focusNode: _numberNode,
                isFocus: _numberFocused,
                type: TextInputType.number,
                onSave: (String? v) {
                  _mobileNumber = v;
                },
                onChange: (String? v) {
                  isButtonPressed = false;
                  if (isError) {
                    _formState.currentState!.validate();
                  }
                },
                labelText: 'رقم المحفظة',
                isPassword: false,
                isPhoneNumber: true,
                upperTitle: true,
                validator: (String? v) {
                  if (!isButtonPressed) {
                    return null;
                  }
                  isError = true;
                  if (v!.isEmpty || v.length < 11) {
                    return 'من فضلك أدخل الرقم بطريقة صحيحة';
                  }
                  isError = false;
                  return null;
                },
                shouldDisappear: !_numberEmpty && !_numberFocused,
              ),
              SizedBox(
                height: 60.0.h,
              ),
              WeevoButton(
                isStable: true,
                color: weevoPrimaryOrangeColor,
                weight: FontWeight.w700,
                onTap: () async {
                  isButtonPressed = true;
                  FocusScope.of(context).unfocus();
                  if (_formState.currentState!.validate()) {
                    _formState.currentState!.save();
                    showDialog(
                        context: navigator.currentContext!,
                        barrierDismissible: false,
                        builder: (context) => const MsgDialog(
                              content:
                                  'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
                            ));
                    await weevoPlusProvider.payUsingEwallet(
                      mobileNumber: _mobileNumber!,
                      transactionId:
                          widget.planSubscription.cachedTransactionId!,
                    );
                    if (weevoPlusProvider.state == NetworkState.SUCCESS) {
                      _t = Timer.periodic(const Duration(seconds: 1),
                          (timer) async {
                        await weevoPlusProvider.checkPaymentStatus(
                            systemReferenceNumber: weevoPlusProvider
                                .eWallet!.transaction!.details!.upgSystemRef!,
                            transactionId: weevoPlusProvider
                                .eWallet!.transaction!.details!.transactionId!);
                        if (weevoPlusProvider.state == NetworkState.SUCCESS) {
                          if (weevoPlusProvider.paymentStatus!.status ==
                              'completed') {
                            _t?.cancel();
                            _t = null;

                            await Preferences.instance.setWeevoPlusPlanId(
                                weevoPlusProvider.creditCard!.transaction!
                                    .subscription!.planId
                                    .toString());
                            await Preferences.instance.setWeevoPlusEndDate(
                                weevoPlusProvider.creditCard!.transaction!
                                    .subscription!.endsAt!);
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
                          }
                        }
                      });
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
                  }
                },
                title: 'ادفع',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
