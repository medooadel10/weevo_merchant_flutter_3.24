import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/content_dialog.dart';
import '../../core/Dialogs/loading_dialog.dart';
import '../../core/Models/plan_subscription.dart';
import '../../core/Models/transaction_webview_model.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/weevo_plus_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/credit_card_formatter.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/weevo_button.dart';
import 'home.dart';
import 'transaction_webview.dart';

class MezaPayment extends StatefulWidget {
  final PlanSubscription planSubscription;
  final int selectedValue;

  const MezaPayment({
    super.key,
    required this.planSubscription,
    required this.selectedValue,
  });

  @override
  State<MezaPayment> createState() => _MezaPaymentState();
}

class _MezaPaymentState extends State<MezaPayment> {
  late TextEditingController _cardNumberController,
      _cardExpiryDateController,
      _cardCVVController;
  late FocusNode _cardNumberNode, _cardExpiryDateNode, _cardCVVNode;
  bool _cardNumberFocused = false,
      _cardExpiryDateFocused = false,
      _cardCVVFocused = false,
      _cardNumberEmpty = true,
      _cardExpiryDateEmpty = true,
      _cardCVVEmpty = true;
  String? _cardNumber, _cvv, _expirationDate;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _cardExpiryDateController = TextEditingController();
    _cardCVVController = TextEditingController();
    _cardNumberNode = FocusNode();
    _cardExpiryDateNode = FocusNode();
    _cardCVVNode = FocusNode();
    _cardNumberNode.addListener(() {
      setState(() {
        _cardNumberFocused = _cardNumberNode.hasFocus;
      });
    });
    _cardCVVNode.addListener(() {
      setState(() {
        _cardCVVFocused = _cardCVVNode.hasFocus;
      });
    });
    _cardExpiryDateNode.addListener(() {
      setState(() {
        _cardExpiryDateFocused = _cardExpiryDateNode.hasFocus;
      });
    });
    _cardNumberController.addListener(() {
      setState(() {
        _cardNumberEmpty = _cardNumberController.text.isEmpty;
      });
    });
    _cardExpiryDateController.addListener(() {
      setState(() {
        _cardExpiryDateEmpty = _cardExpiryDateController.text.isEmpty;
      });
    });
    _cardCVVController.addListener(() {
      setState(() {
        _cardCVVEmpty = _cardCVVController.text.isEmpty;
      });
    });
    _cardNumberEmpty = _cardNumberController.text.isEmpty;
    _cardExpiryDateEmpty = _cardExpiryDateController.text.isEmpty;
    _cardCVVEmpty = _cardCVVController.text.isEmpty;
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
              EditText(
                suffix: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Image.asset(
                      'assets/images/miza_card.jpeg',
                      height: 60.0.h,
                      width: 60.0.w,
                    )),
                readOnly: false,
                type: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CreditCardInputFormatter(),
                ],
                controller: _cardNumberController,
                focusNode: _cardNumberNode,
                onFieldSubmit: (_) {
                  _cardNumberNode.unfocus();
                },
                isFocus: _cardNumberFocused,
                onSave: (String? v) {
                  _cardNumber = v;
                },
                onChange: (String? v) {
                  isButtonPressed = false;
                  if (isError) {
                    _formState.currentState!.validate();
                  }
                },
                labelText: 'رقم بطاقة ميزة',
                hintColor: Colors.grey,
                hintText: 'XXXX-XXXX-XXXX-XXXX',
                isPassword: false,
                isPhoneNumber: false,
                upperTitle: true,
                validator: (String? v) {
                  if (!isButtonPressed) {
                    return null;
                  }
                  isError = true;
                  if (v!.isEmpty || v.length < 19) {
                    return 'أدخل رقم البطاقة بطريقة صحيحة';
                  }
                  isError = false;
                  return null;
                },
                shouldDisappear: !_cardNumberEmpty && !_cardNumberFocused,
              ),
              Row(
                children: [
                  Expanded(
                    child: EditText(
                      readOnly: false,
                      type: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      controller: _cardExpiryDateController,
                      focusNode: _cardExpiryDateNode,
                      onChange: (String? v) {
                        isButtonPressed = false;
                        if (isError) {
                          _formState.currentState!.validate();
                        }
                      },
                      onFieldSubmit: (_) {
                        _cardExpiryDateNode.unfocus();
                      },
                      isFocus: _cardExpiryDateFocused,
                      onSave: (String? v) {
                        _expirationDate = v;
                      },
                      labelText: 'تاريخ الانتهاء',
                      hintColor: Colors.grey,
                      hintText: '26/01',
                      isPassword: false,
                      isPhoneNumber: false,
                      upperTitle: true,
                      validator: (String? v) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (v!.isEmpty || v.length < 5) {
                          return 'أدخل التاريخ';
                        }
                        isError = false;
                        return null;
                      },
                      shouldDisappear:
                          !_cardExpiryDateEmpty && !_cardExpiryDateFocused,
                    ),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Expanded(
                    child: EditText(
                      readOnly: false,
                      type: TextInputType.number,
                      controller: _cardCVVController,
                      focusNode: _cardCVVNode,
                      isFocus: _cardCVVFocused,
                      onFieldSubmit: (_) {
                        _cardCVVNode.unfocus();
                      },
                      onSave: (String? v) {
                        _cvv = v;
                      },
                      onChange: (String? v) {
                        isButtonPressed = false;
                        if (isError) {
                          _formState.currentState!.validate();
                        }
                      },
                      labelText: 'الرمز السري cvv',
                      isPassword: true,
                      maxLength: 3,
                      isPhoneNumber: false,
                      upperTitle: true,
                      validator: (String? v) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (v!.isEmpty || v.length < 3) {
                          return 'أدخل الرمز السري';
                        }
                        isError = false;
                        return null;
                      },
                      shouldDisappear: !_cardCVVEmpty && !_cardCVVFocused,
                    ),
                  ),
                ],
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
                        builder: (context) => const LoadingDialog());
                    await weevoPlusProvider.payUsingMeezaCard(
                      pan: _cardNumber!.split('-').join(),
                      expirationDate: _expirationDate!.split('/').join(),
                      cvv: _cvv!,
                      transactionId:
                          widget.planSubscription.cachedTransactionId!,
                    );
                    if (weevoPlusProvider.state == NetworkState.SUCCESS) {
                      if (weevoPlusProvider
                              .meezaCard!.upgResponse!.threeDSUrl !=
                          null) {
                        MagicRouter.pop();
                        dynamic value = await Navigator.pushNamed(
                            navigator.currentContext!, TransactionWebView.id,
                            arguments: TransactionWebViewModel(
                                url: weevoPlusProvider
                                    .meezaCard!.upgResponse!.threeDSUrl!,
                                selectedValue: widget.selectedValue));
                        if (value != null) {
                          showDialog(
                              context: navigator.currentContext!,
                              barrierDismissible: false,
                              builder: (context) => const LoadingDialog());
                          await weevoPlusProvider.checkPaymentStatus(
                              systemReferenceNumber: value,
                              transactionId:
                                  widget.planSubscription.cachedTransactionId!);
                          if (weevoPlusProvider.state == NetworkState.SUCCESS) {
                            if (weevoPlusProvider.paymentStatus?.status ==
                                'completed') {
                              await Preferences.instance.setWeevoPlusPlanId(
                                  weevoPlusProvider.paymentStatus!.transaction!
                                      .subscription!.planId
                                      .toString());
                              await Preferences.instance.setWeevoPlusEndDate(
                                  weevoPlusProvider.paymentStatus!.transaction!
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
                                              context,
                                              Home.id,
                                              (route) => false);
                                        },
                                      ));
                            }
                          } else {
                            showDialog(
                              context: navigator.currentContext!,
                              barrierDismissible: false,
                              builder: (context) => ContentDialog(
                                content: 'حدث حطأ حاول مرة اخري',
                                callback: () {
                                  MagicRouter.pop();
                                },
                              ),
                            );
                          }
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
