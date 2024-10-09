import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../features/Widgets/edit_text.dart';
import '../Providers/display_shipment_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';

class ShipmentRaiseDialog extends StatefulWidget {
  final int shipmentId;
  final String currentValue;

  const ShipmentRaiseDialog({
    super.key,
    required this.currentValue,
    required this.shipmentId,
  });

  @override
  State<ShipmentRaiseDialog> createState() => _ShipmentRaiseDialogState();
}

class _ShipmentRaiseDialogState extends State<ShipmentRaiseDialog> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  TextEditingController shipmentRaise = TextEditingController();

  @override
  void initState() {
    super.initState();
    shipmentRaise.text = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    final DisplayShipmentProvider displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formState,
                child: EditText(
                  controller: shipmentRaise,
                  readOnly: false,
                  type: TextInputType.number,
                  filled: false,
                  radius: 12.0.r,
                  labelColor: Colors.grey,
                  labelFontSize: 15.0.sp,
                  action: TextInputAction.done,
                  isPhoneNumber: false,
                  isPassword: false,
                  validator: (String? v) => v!.isEmpty
                      ? 'من فضلك أدخل السعر بطريقة صحيحة'
                      : num.parse(v) <= num.parse(widget.currentValue).toInt()
                          ? 'من فضلك أدخل سعر أفضل'
                          : null,
                  labelText: 'سعر التوصيل الجديد',
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () async {
                  if (_formState.currentState!.validate()) {
                    Navigator.pop(navigator.currentContext!);
                    displayShipmentProvider.updateOneShipment(
                        shipmentId: widget.shipmentId,
                        newShippingCost: shipmentRaise.text);
                  }
                },
                child: const Text(
                  'تأكيد',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(navigator.currentContext!);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
