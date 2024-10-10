import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../../core/Storage/shared_preference.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/toasts.dart';
import '../../../../Widgets/weevo_button.dart';
import '../shipment_update_price_dialog.dart';

class ShipmentIncreasePriceBtn extends StatelessWidget {
  final Color? color;
  const ShipmentIncreasePriceBtn({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    return WeevoButton(
      onTap: () async {
        await cubit.getShipmentDetails(cubit.shipmentDetails!.id);
        if (cubit.shipmentDetails?.status != 'available') {
          showToast('لا يمكن رفع سعر الطلب بسبب تم قبول الطلب');
          return;
        }
        showDialog(
          context: navigator.currentContext!,
          builder: (_) {
            return BlocProvider.value(
              value: cubit,
              child: const ShipmentUpdatePriceDialog(),
            );
          },
        );
      },
      title: 'رفع سعر التوصيل',
      color: color ?? weevoPrimaryBlueColor,
      isStable: true,
    );
  }
}
