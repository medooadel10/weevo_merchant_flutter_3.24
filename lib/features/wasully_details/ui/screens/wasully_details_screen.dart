import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';

import '../../../../core/Models/shipment_notification.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/router/router.dart';
import '../../../wasully_shipping_offers/ui/screens/wasully_shipping_offers_screen.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';
import '../widgets/wasully_details_body.dart';

class WasullyDetailsScreen extends StatefulWidget {
  final int id;
  final bool navigateToOffers;
  const WasullyDetailsScreen(
      {super.key, required this.id, this.navigateToOffers = false});

  @override
  State<WasullyDetailsScreen> createState() => _WasullyDetailsScreenState();
}

class _WasullyDetailsScreenState extends State<WasullyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    await cubit.getWassullyDetails(widget.id);
    cubit.streamShipmentStatus(navigator.currentContext!);
    if (widget.navigateToOffers) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: WasullyDetailsBody(
              id: widget.id,
            ),
          ),
        );
      },
    );
  }
}
