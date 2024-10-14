import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Utilits/colors.dart';
import 'edit_text.dart';

class ProductPriceEdit extends StatefulWidget {
  final double price;
  final Function(String) onDone;

  const ProductPriceEdit({
    super.key,
    required this.price,
    required this.onDone,
  });

  @override
  State<ProductPriceEdit> createState() => _ProductPriceEditState();
}

class _ProductPriceEditState extends State<ProductPriceEdit> {
  late TextEditingController _controller;
  late FocusNode _priceNode;
  bool _isFocused = false;
  final GlobalKey<FormState> _keyState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _priceNode = FocusNode();
    _priceNode.addListener(() {
      setState(() {
        _isFocused = _priceNode.hasFocus;
      });
    });
    _controller.text = widget.price.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    _priceNode.dispose();
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
                'تعديل سعر المنتج\nفي هذه الشحنة',
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
                focusNode: _priceNode,
                align: TextAlign.center,
                type: TextInputType.number,
                labelText: 'أدخل السعر',
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
                    return 'ادخل السعر';
                  } else if (num.parse(v).toInt() < 10) {
                    return 'يجب الا يقل سعر المنتج عن ١٠ جنية';
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
