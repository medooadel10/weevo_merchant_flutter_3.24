import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/helpers/toasts.dart';
import '../../../../core_new/router/router.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../Widgets/edit_text.dart';
import '../../../Widgets/weevo_button.dart';

class ShipmentUpdatePriceDialog extends StatelessWidget {
  const ShipmentUpdatePriceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ShipmentDetailsCubit cubit = context.read();
    cubit.shippingCostContoller.text =
        cubit.shipmentDetails!.agreedShippingCostAfterDiscount?.toString() ??
            cubit.shipmentDetails!.agreedShippingCost?.toString() ??
            cubit.shipmentDetails!.expectedShippingCost?.toString() ??
            '';
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0.w,
            vertical: 20.0.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: cubit.priceForm,
                child: EditText(
                  controller: cubit.shippingCostContoller,
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
                      : num.parse(v) <=
                              num.parse(cubit.shipmentDetails!
                                          .agreedShippingCostAfterDiscount
                                          ?.toString() ??
                                      cubit.shipmentDetails!.agreedShippingCost
                                          ?.toString() ??
                                      cubit
                                          .shipmentDetails!.expectedShippingCost
                                          ?.toString() ??
                                      '0')
                                  .toInt()
                          ? 'من فضلك أدخل سعر أفضل'
                          : null,
                  labelText: 'سعر التوصيل الجديد',
                ),
              ),
              verticalSpace(12),
              BlocConsumer<ShipmentDetailsCubit, ShipmentDetailsState>(
                listener: (context, state) {
                  if (state is UpdatePriceSuccess) {
                    showToast('تم تحديث سعر بنجاح');
                    MagicRouter.pop();
                  }
                  if (state is UpdatePriceError) {
                    showToast(state.error, isError: true);
                  }
                },
                builder: (context, state) {
                  if (state is UpdatePriceLoading) {
                    return const Center(
                      child: CustomLoadingIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      WeevoButton(
                        onTap: () {
                          cubit.updateShippingCost();
                        },
                        title: 'تأكيد',
                        color: weevoPrimaryOrangeColor,
                        isStable: true,
                        isExpand: true,
                      ),
                      verticalSpace(8),
                      WeevoButton(
                        onTap: () {
                          MagicRouter.pop();
                        },
                        title: 'الغاء',
                        color: weevoRedColor,
                        isStable: true,
                        isExpand: true,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
