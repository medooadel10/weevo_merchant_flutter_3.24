import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Utilits/colors.dart';
import 'edit_text.dart';

class ProductQuantityEdit extends StatefulWidget {
  final int quantity;
  final Function onDone;

  const ProductQuantityEdit({
    super.key,
    required this.quantity,
    required this.onDone,
  });

  @override
  State<ProductQuantityEdit> createState() => _ProductQuantityEditState();
}

class _ProductQuantityEditState extends State<ProductQuantityEdit> {
  late TextEditingController _controller;
  late FocusNode _quantityNode;
  bool _isFocused = false;
  final GlobalKey<FormState> _keyState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _quantityNode = FocusNode();
    _quantityNode.addListener(() {
      setState(() {
        _isFocused = _quantityNode.hasFocus;
      });
    });
    _controller.text = widget.quantity.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    _quantityNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: Container(
        height: 250.0.h,
        width: 150.0.w,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
        child: Form(
          key: _keyState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تعديل كمية المنتج\nفي هذه الشحنة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0.sp,
                ),
              ),
              SizedBox(
                height: 8.0.h,
              ),
              EditText(
                readOnly: false,
                controller: _controller,
                focusNode: _quantityNode,
                align: TextAlign.center,
                type: TextInputType.number,
                labelText: 'أدخل الكمية',
                onChange: (String? v) {
                  isButtonPressed = false;
                  if (isError) {
                    _keyState.currentState!.validate();
                  }
                },
                onSave: (String? v) {},
                validator: (String? v) {
                  if (!isButtonPressed) {
                    return null;
                  }
                  isError = true;
                  if (v!.isEmpty) {
                    return 'ادخل الكمية';
                  }
                  isError = false;
                  return null;
                },
                isFocus: _isFocused,
                isPassword: false,
                isPhoneNumber: false,
                shouldDisappear: _controller.text.isNotEmpty && !_isFocused,
                upperTitle: true,
              ),
              SizedBox(
                height: 10.0.h,
              ),
              SizedBox(
                height: 50.0.h,
                child: ElevatedButton(
                  onPressed: () {
                    isButtonPressed = true;
                    if (_keyState.currentState!.validate()) {
                      widget.onDone(_controller.text);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'تأكيد',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
