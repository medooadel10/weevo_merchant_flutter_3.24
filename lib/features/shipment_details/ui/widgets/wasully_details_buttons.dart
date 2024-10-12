import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core_new/data/models/shipment_status/base_shipment_status.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';

class WasullyDetailsButtons extends StatelessWidget {
  const WasullyDetailsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ShipmentDetailsCubit>();

        return state.maybeWhen(
            loading: () => const CustomLoadingIndicator(),
            orElse: () => BaseShipmentStatus
                .shipmentStatusMap[cubit.shipmentDetails!.status]!
                .buildShipmentDetailsButtons(context));
      },
    );
  }
}
