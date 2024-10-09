import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/Models/shipment_tracking_model.dart';
import '../../../../../core/Providers/auth_provider.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../../core/router/router.dart';
import '../../../../../core_new/helpers/toasts.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../wasully_handle_shipment/ui/screens/wasully_handle_shipment_screen.dart';
import '../../../data/models/wasully_model.dart';
import '../../../logic/cubit/wasully_details_cubit.dart';

class WasullyTrackShipmentBtn extends StatelessWidget {
  const WasullyTrackShipmentBtn({super.key});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    WasullyModel? data = cubit.wasullyModel;
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      child: WeevoButton(
        isStable: true,
        color: weevoPrimaryOrangeColor,
        onTap: () async {
          await context
              .read<WasullyDetailsCubit>()
              .getWassullyDetails(data!.id);
          if (cubit.wasullyModel?.status == 'cancelled' ||
              cubit.wasullyModel?.status == 'delivered' ||
              cubit.wasullyModel?.status == 'returned' ||
              cubit.wasullyModel?.status == 'available') {
            showToast('الطلب ليست موجودة بعد للتتبع');
            return;
          }
          DocumentSnapshot courierToken = await FirebaseFirestore.instance
              .collection('courier_users')
              .doc(data.courierId.toString())
              .get();
          String courierNationalId = courierToken['national_id'];
          DocumentSnapshot merchantToken = await FirebaseFirestore.instance
              .collection('merchant_users')
              .doc(data.merchantId.toString())
              .get();
          String merchantNationalId = merchantToken['national_id'];
          MagicRouter.navigateTo(
            WasullyHandleShipmentScreen(
              model: ShipmentTrackingModel(
                courierNationalId: courierNationalId,
                merchantNationalId: merchantNationalId,
                shipmentId: data.id,
                deliveringState: data.deliveringState.toString(),
                deliveringCity: data.deliveringCity.toString(),
                receivingState: data.receivingState.toString(),
                receivingCity: data.receivingCity.toString(),
                deliveringLat: data.deliveringLat,
                clientPhone: data.clientPhone,
                hasChildren: 0,
                status: data.status,
                deliveringLng: data.deliveringLng,
                receivingLng: data.receivingLng,
                receivingLat: data.receivingLat,
                merchantId: data.merchantId,
                merchantImage: authProvider.photo,
                merchantPhone: authProvider.phone,
                merchantName: authProvider.name,
                courierId: data.courierId,
                paymentMethod: data.paymentMethod,
                courierImage: data.courier?.photo,
                courierName: data.courier?.name,
                courierPhone: data.courier?.phone,
                deliveringStreet: data.deliveringStreet,
                receivingStreet: data.receivingStreet,
                wasullyModel: data,
              ),
            ),
          );
        },
        title: 'تتبع الطلب',
      ),
    );
  }
}
