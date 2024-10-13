import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/features/Screens/choose_courier.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core/Models/shipment_notification.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/helpers/spacing.dart';

class ShipmentDetailsWaitingOffers extends StatelessWidget {
  const ShipmentDetailsWaitingOffers({super.key});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read();
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return GestureDetector(
      onTap: () {
        MagicRouter.navigateTo(
          ChooseCourier(
            shipmentNotification: ShipmentNotification(
              merchantName: authProvider.name,
              merchantImage: authProvider.photo,
              merchantFcmToken: authProvider.fcmToken,
              receivingState: cubit.shipmentDetails!.receivingStateModel.name,
              receivingCity: cubit.shipmentDetails!.receivingCityModel.name,
              deliveryCity: cubit.shipmentDetails!.deliveringCityModel.name,
              childrenShipment: 0,
              deliveryState: cubit.shipmentDetails!.deliveringStateModel.name,
              shipmentId: cubit.shipmentDetails!.id,
              shippingCost:
                  cubit.shipmentDetails!.agreedShippingCostAfterDiscount ??
                      cubit.shipmentDetails!.agreedShippingCost ??
                      cubit.shipmentDetails!.expectedShippingCost ??
                      "0",
              totalShipmentCost: cubit.shipmentDetails!.amount,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
          color: weevoPrimaryOrangeColor,
        ),
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Row(
          children: [
            const Text(
              'في انتظار العروض',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            horizontalSpace(4),
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
