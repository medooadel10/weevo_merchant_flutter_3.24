import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../../core/Models/shipment_notification.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../wasully_shipping_offers/ui/screens/wasully_shipping_offers_screen.dart';
import '../../logic/cubit/wasully_details_cubit.dart';

class WasullyDetailsWaitingOffers extends StatelessWidget {
  const WasullyDetailsWaitingOffers({super.key});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read();
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return GestureDetector(
      onTap: () {
        MagicRouter.navigateTo(
          WasullyShippingOffersScreen(
            id: cubit.wasullyModel!.id,
            shipmentNotification: ShipmentNotification(
              merchantName: authProvider.name,
              merchantImage: authProvider.photo,
              merchantFcmToken: authProvider.fcmToken,
              receivingState: cubit.wasullyModel!.receivingStateModel?.name,
              receivingCity: cubit.wasullyModel!.receivingCityModel?.name,
              deliveryCity: cubit.wasullyModel!.deliveringCityModel?.name,
              childrenShipment: 0,
              deliveryState: cubit.wasullyModel!.deliveringStateModel?.name,
              shipmentId: cubit.wasullyModel!.id,
              shippingCost: cubit.wasullyModel!.price,
              totalShipmentCost: cubit.wasullyModel!.amount,
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
