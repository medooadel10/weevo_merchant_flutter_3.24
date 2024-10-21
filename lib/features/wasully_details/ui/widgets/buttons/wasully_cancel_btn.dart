import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core/router/router.dart';

import '../../../../../core/Dialogs/cancel_shipment_dialog.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../logic/cubit/wasully_details_cubit.dart';
import '../wasully_cancel_bottom_sheet.dart';

class WasullyCancelBtn extends StatelessWidget {
  final Color? color;
  const WasullyCancelBtn({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
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
                  onOkPressed: () {
                    MagicRouter.pop();
                    cubit.selectCancellationReason(null);
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
                          child: const WasullyCancelReasonBottomSheet(),
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
