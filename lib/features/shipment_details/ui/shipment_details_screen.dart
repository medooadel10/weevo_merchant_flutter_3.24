import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';
import 'package:weevo_merchant_upgrade/features/Screens/choose_courier.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../core/Models/shipment_notification.dart';
import '../../../core/Providers/auth_provider.dart';
import '../../../core/router/router.dart';
import 'widgets/shipment_details_body.dart';

class ShipmentDetailsScreen extends StatefulWidget {
  final int id;
  final bool navigateToOffers;
  const ShipmentDetailsScreen(
      {super.key, required this.id, this.navigateToOffers = false});

  @override
  State<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends State<ShipmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    await cubit.getShipmentDetails(widget.id);
    cubit.streamShipmentStatus(navigator.currentContext!);
    if (widget.navigateToOffers) {
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
            shippingCost: cubit.shipmentDetails!.expectedShippingCost ?? "0",
            totalShipmentCost: cubit.shipmentDetails!.amount,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        log('Status : ${context.read<ShipmentDetailsCubit>().shipmentDetails?.status}');
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: ShipmentDetailsBody(
              id: widget.id,
            ),
          ),
        );
      },
    );
  }
}
