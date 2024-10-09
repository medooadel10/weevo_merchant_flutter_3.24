import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/Providers/forget_password_provider.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../../Widgets/edit_text.dart';
import '../../Widgets/weevo_button.dart';

class ResetPassword0 extends StatefulWidget {
  const ResetPassword0({super.key});

  @override
  State<ResetPassword0> createState() => _ResetPassword0State();
}

class _ResetPassword0State extends State<ResetPassword0> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final forget = ForgetPasswordProvider.get(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'أستعادة كلمة السر',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: Form(
              key: formState,
              child: Column(
                children: [
                  EditText(
                    readOnly: false,
                    controller: forget.phoneNumberController,
                    upperTitle: true,
                    action: TextInputAction.done,
                    shouldDisappear: false,
                    onChange: (String? value) {
                      isButtonPressed = false;
                      if (isError) {
                        formState.currentState!.validate();
                      }
                    },
                    isPhoneNumber: true,
                    type: TextInputType.phone,
                    isPassword: false,
                    validator: (String? output) {
                      if (!isButtonPressed) {
                        return null;
                      }
                      isError = true;
                      if (output!.length < 11) {
                        return phoneValidatorMessage;
                      }
                      isError = false;
                      return null;
                    },
                    labelText: 'أدخل رقم الهاتف',
                  ),
                ],
              ),
            ),
          ),
          WeevoButton(
            isStable: true,
            color: weevoPrimaryOrangeColor,
            onTap: () async {
              if (formState.currentState!.validate()) {
                forget.sendOtp();
              }
            },
            title: 'أستعادة كلمة المرور',
          ),
        ],
      ),
    );
  }
}
