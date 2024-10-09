import 'package:flutter/material.dart';

import '../../core/Utilits/colors.dart';
import 'edit_text.dart';
import 'weevo_button.dart';

class WalletAccountFieldsWidget extends StatefulWidget {
  final Function dataHolder;
  final bool isUpdated;
  final String walletNumber;

  const WalletAccountFieldsWidget({
    super.key,
    required this.dataHolder,
    required this.isUpdated,
    required this.walletNumber,
  });

  @override
  State<WalletAccountFieldsWidget> createState() =>
      _WalletAccountFieldsWidgetState();
}

class _WalletAccountFieldsWidgetState extends State<WalletAccountFieldsWidget> {
  bool walletNumberFocused = false;
  bool walletNumberEmpty = true;
  late TextEditingController walletNumberController;
  late FocusNode walletNumberNode;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? walletNumber;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    walletNumberController = TextEditingController();
    walletNumberNode = FocusNode();
    walletNumberController.addListener(() {
      setState(() {
        walletNumberEmpty = walletNumberController.text.isEmpty;
      });
    });
    walletNumberNode.addListener(() {
      setState(() {
        walletNumberFocused = walletNumberNode.hasFocus;
      });
    });
    if (widget.isUpdated) {
      walletNumberController.text = widget.walletNumber;
    }
    walletNumberEmpty = walletNumberController.text.isEmpty;
  }

  @override
  void dispose() {
    walletNumberController.dispose();
    walletNumberNode.dispose();
    super.dispose();
  }

  void submitFn() {
    isButtonPressed = true;
    final formState = _formState.currentState;
    if (formState!.validate()) {
      formState.save();
      widget.dataHolder(walletNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditText(
            validator: (String? v) {
              if (!isButtonPressed) {
                return null;
              }
              isError = true;
              if (v!.isEmpty) {
                return 'أدخل رقم المحفظة';
              }
              isError = false;
              return null;
            },
            onChange: (String? v) {
              isButtonPressed = false;
              if (isError) {
                _formState.currentState!.validate();
              }
            },
            readOnly: false,
            controller: walletNumberController,
            type: TextInputType.phone,
            onSave: (String? v) {
              walletNumber = v;
            },
            labelText: 'رقم المحفظة',
            isFocus: walletNumberFocused,
            focusNode: walletNumberNode,
            isPassword: false,
            isPhoneNumber: true,
            shouldDisappear: !walletNumberEmpty && !walletNumberFocused,
            upperTitle: true,
          ),
          const SizedBox(
            height: 10.0,
          ),
          WeevoButton(
            isStable: true,
            title: 'حفظ',
            color: weevoPrimaryOrangeColor,
            onTap: submitFn,
          ),
        ],
      ),
    );
  }
}
