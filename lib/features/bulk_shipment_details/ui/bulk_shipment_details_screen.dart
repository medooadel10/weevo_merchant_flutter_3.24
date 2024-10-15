import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Providers/auth_provider.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/logic/cubit/bulk_shipment_cubit.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/ui/widgets/bulk_shipment_details_body.dart';

import '../../../core/Models/shipment_notification.dart';
import '../../../core/Storage/shared_preference.dart';
import '../../../core/router/router.dart';
import '../../Screens/choose_courier.dart';

class BulkShipmentDetailsScreen extends StatefulWidget {
  final int shipmentId;
  final bool navigateToOffers;

  const BulkShipmentDetailsScreen(
      {super.key, required this.shipmentId, this.navigateToOffers = false});

  @override
  State<BulkShipmentDetailsScreen> createState() =>
      _BulkShipmentDetailsScreenState();
}

class _BulkShipmentDetailsScreenState extends State<BulkShipmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    BulkShipmentCubit cubit = context.read<BulkShipmentCubit>();
    await cubit.getBulkShipmentDetails(widget.shipmentId);
    cubit.streamShipmentStatus(navigator.currentContext!);

    if (widget.navigateToOffers) {
      MagicRouter.navigateTo(
        ChooseCourier(
          shipmentNotification: ShipmentNotification(
            merchantName: authProvider.name,
            merchantImage: authProvider.photo,
            merchantFcmToken: authProvider.fcmToken,
            receivingState: cubit.bulkShipmentModel!.receivingStateModel?.name,
            receivingCity: cubit.bulkShipmentModel!.receivingCityModel?.name,
            deliveryCity: cubit.bulkShipmentModel!.deliveringCityModel?.name,
            childrenShipment: 0,
            deliveryState: cubit.bulkShipmentModel!.deliveringStateModel?.name,
            shipmentId: cubit.bulkShipmentModel!.id,
            shippingCost: cubit.bulkShipmentModel!.expectedShippingCost ?? "0",
            totalShipmentCost: cubit.bulkShipmentModel!.amount,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulkShipmentCubit, BulkShipmentState>(
      builder: (context, state) {
        log('Status : ${context.read<BulkShipmentCubit>().bulkShipmentModel?.status}');
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: BulkShipmentDetailsBody(
              id: widget.shipmentId,
            ),
          ),
        );
      },
    );
  }
}
