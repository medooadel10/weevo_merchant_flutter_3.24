import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/helpers/toasts.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../Widgets/weevo_button.dart';
import '../../../shipments/ui/screens/shipments_screen.dart';

class ShipmentCancelDialog extends StatelessWidget {
  const ShipmentCancelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ShipmentDetailsCubit cubit = context.read();
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
              Text(
                'تأكيد الغاء الطلب ؟',
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              verticalSpace(12),
              BlocConsumer<ShipmentDetailsCubit, ShipmentDetailsState>(
                listener: (context, state) {
                  if (state is CancelShipmentSuccess) {
                    showToast('تم الغاء الطلب بنجاح');
                    // Cancel Dialog
                    MagicRouter.pop(); // Naviagte to shipments screen
                    MagicRouter.navigateAndPopUntilFirstPage(
                        const ShipmentsScreen(
                      filterIndex: 6,
                    ));
                  }
                  if (state is CancelShipmentError) {
                    MagicRouter.pop();
                    cubit.getShipmentDetails(cubit.shipmentDetails!.id);
                    showToast('لا يمكنك إلغاء هذا الطلب', isError: true);
                  }
                },
                builder: (context, state) {
                  if (state is CancelShipmentLoading) {
                    return const Center(
                      child: CustomLoadingIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      WeevoButton(
                        onTap: () {
                          cubit.cancelShipment();
                        },
                        title: 'الغاء الطلب',
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
