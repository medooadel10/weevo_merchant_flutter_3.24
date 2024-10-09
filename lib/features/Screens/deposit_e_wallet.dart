import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Utilits/colors.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/weevo_button.dart';
import '../Widgets/weevo_plus_plan.dart';

class WithdrawEWallet extends StatefulWidget {
  const WithdrawEWallet({super.key});

  @override
  State<WithdrawEWallet> createState() => _WithdrawEWalletState();
}

class _WithdrawEWalletState extends State<WithdrawEWallet> {
  late TextEditingController _numberController;
  late FocusNode _numberNode;
  bool _numberFocused = false, _numberEmpty = true;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
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
              const WeevoPlusPlan(),
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
                onSave: (String? v) {},
                labelText: 'رقم المحفظة',
                isPassword: false,
                isPhoneNumber: true,
                upperTitle: true,
                onChange: (String? v) {
                  isButtonPressed = false;
                  if (isError) {
                    _formState.currentState!.validate();
                  }
                },
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
                onTap: () {
                  isButtonPressed = true;
                  if (_formState.currentState!.validate()) {
                    _formState.currentState!.save();
                  }
                  FocusScope.of(context).unfocus();
                },
                title: 'طلب سحب',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
