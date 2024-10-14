import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Providers/add_shipment_provider.dart';
import 'package:weevo_merchant_upgrade/core_new/router/router.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/shipment_details_model.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/toasts.dart';
import '../../../../Screens/add_shipment.dart';
import '../../../../Widgets/weevo_button.dart';

class ShipmentUpdateShipmentBtn extends StatelessWidget {
  final Color? color;
  const ShipmentUpdateShipmentBtn({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    final data = cubit.shipmentDetails!;
    final shipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      child: WeevoButton(
        onTap: () async {
          await cubit.getShipmentDetails(cubit.shipmentDetails!.id);
          if (data.status == 'merchant-accepted-shipping-offer' ||
              data.status == 'on-the-way-to-get-shipment-from-merchant' ||
              data.status == 'courier-applied-to-shipment' ||
              data.status == 'on-delivery') {
            showToast('لا يمكن تعديل الطلب بسبب تم قبول الطلب');
            return;
          }
          if (data.status == 'delivered') {
            showToast('لا يمكن تعديل الطلب بسبب تم إستلام الطلب');
            return;
          }
          if (data.status == 'returned') {
            showToast('لا يمكن تعديل الطلب بسبب تم استرجاع الطلب');
            return;
          }
          log('cubit.shipmentDetails -> ${cubit.shipmentDetails!.toJson()}');
          shipmentProvider.setIsUpdatedFromServer(true);
          shipmentProvider.setDataFromServer(
            model: cubit.shipmentDetails!,
          );
          MagicRouter.navigateTo(
            const AddShipment(),
          ).then((value) {
            if (value is ShipmentDetailsModel) {
              cubit.getShipmentDetails(cubit.shipmentDetails!.id);
            }
          });
        },
        color: color ?? weevoPrimaryOrangeColor,
        isStable: true,
        title: 'تعديل الطلب',
      ),
    );
  }
}
