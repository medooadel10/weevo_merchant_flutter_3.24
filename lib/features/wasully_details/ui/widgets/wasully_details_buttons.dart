import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../data/models/shipment_status/base_shipment_status.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';

class WasullyDetailsButtons extends StatelessWidget {
  const WasullyDetailsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        final cubit = context.read<WasullyDetailsCubit>();
        if (state is WasullyDetailsLoadingState) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }
        return BaseShipmentStatus.shipmentStatusMap[cubit.wasullyModel!.status]!
            .buildShipmentDetailsButtons(context);
      },
    );
  }
}
