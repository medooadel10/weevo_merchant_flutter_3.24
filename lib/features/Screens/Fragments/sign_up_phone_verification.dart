import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../core/Dialogs/action_dialog.dart';
import '../../../core/Providers/auth_provider.dart';
import '../../../core/Storage/shared_preference.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core_new/router/router.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/weevo_button.dart';

class SignUpPhoneVerification extends StatefulWidget {
  static const String id = 'sign_up_phone_verification';

  const SignUpPhoneVerification({super.key});

  @override
  State<SignUpPhoneVerification> createState() =>
      _SignUpPhoneVerificationState();
}

class _SignUpPhoneVerificationState extends State<SignUpPhoneVerification> {
  String _code = '', _currentCode = '';
  late TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    listenToSms();
  }

  void listenToSms() async {
    SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    _pinController.dispose();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    return LoadingWidget(
      isLoading: authProvider.isLoading,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(navigator.currentContext!);
          return false;
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(navigator.currentContext!);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                ),
              ),
              title: const Text(
                'تأكيد رقم الهاتف',
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'من فضلك ادخل الكود المكون من 6 ارقام',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        authProvider.userPhone ?? '',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  PinFieldAutoFill(
                    controller: _pinController,
                    decoration: UnderlineDecoration(
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      colorBuilder:
                          FixedColorBuilder(Colors.black.withOpacity(0.3)),
                    ),
                    currentCode: _currentCode,
                    onCodeSubmitted: (code) {
                      log('code submitted -> $code');
                    },
                    onCodeChanged: (code) {
                      _currentCode = code!;
                      if (code.length == 6) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "يمكنك أعادة الأرسال في غضون",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const TextSpan(
                            text: " ",
                          ),
                          TextSpan(
                            text: authProvider
                                .format(Duration(seconds: authProvider.start)),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      )),
                  authProvider.wait
                      ? Container()
                      : SizedBox(
                          height: 20.h,
                        ),
                  authProvider.wait
                      ? Container()
                      : WeevoButton(
                          isStable: true,
                          color: weevoPrimaryOrangeColor,
                          title: 'أعادة أرسال الكود',
                          onTap: () async {
                            await authProvider.resendOtp();
                          },
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                  WeevoButton(
                    isStable: true,
                    color: weevoPrimaryOrangeColor,
                    title: 'استمرار',
                    onTap: () async {
                      _code = _pinController.text;
                      if (_pinController.text.length == 6) {
                        _pinController.clear();
                        await authProvider.checkOtp(otp: _code);
                      } else {
                        _pinController.clear();
                        showDialog(
                            context: navigator.currentContext!,
                            barrierDismissible: false,
                            builder: (context) => ActionDialog(
                                  content:
                                      'من فضلك أدخل الكود المكون من 6 أرقام',
                                  approveAction: 'حسناً',
                                  onApproveClick: () {
                                    MagicRouter.pop();
                                  },
                                ));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}