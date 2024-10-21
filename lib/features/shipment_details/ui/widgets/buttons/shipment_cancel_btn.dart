import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core/Dialogs/cancel_shipment_dialog.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/router/router.dart';
import '../../../../Widgets/weevo_button.dart';
import '../shipment_cancel_bottom_sheet.dart';

class ShipmentCancelBtn extends StatelessWidget {
  final Color? color;
  const ShipmentCancelBtn({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    return SizedBox(
      width: double.infinity,
      child: WeevoButton(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return BlocProvider.value(
                value: cubit,
                child: CancelShipmentDialog(
                  onOkPressed: () async {
                    cubit.selectCancellationReason(null);
                    context.pop();
                    showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      showDragHandle: true,
                      isScrollControlled: true,
                      isDismissible: true,
                      sheetAnimationStyle: AnimationStyle(
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 500),
                      ),
                      builder: (_) {
                        return BlocProvider.value(
                          value: cubit,
                          child: const ShipmentCancelReasonBottomSheet(),
                        );
                      },
                    );
                  },
                  onCancelPressed: () {
                    MagicRouter.pop();
                  },
                ),
              );
            },
          );
        },
        title: 'إلغاء الطلب',
        color: color ?? weevoPrimaryBlueColor,
        isStable: true,
      ),
    );
  }
}
