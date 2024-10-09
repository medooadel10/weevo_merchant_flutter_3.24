import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../wasully_details/data/models/shipment_status/base_shipment_status.dart';
import '../../logic/cubit/shipments_cubit.dart';
import '../../logic/cubit/shipments_states.dart';
import 'shipment_filter_item.dart';

class ShipmentFilterListBlocBuilder extends StatelessWidget {
  const ShipmentFilterListBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentsCubit, ShipmentsStates>(
      builder: (context, state) {
        ShipmentsCubit cubit = context.read<ShipmentsCubit>();
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10.0.w,
            runSpacing: 10.0.h,
            children: List.generate(
              BaseShipmentStatus.shipmentStatusList.length,
              (i) => GestureDetector(
                onTap: () => cubit.filterAndGetShipments(i),
                child: ShipmentFilterItem(
                  data: BaseShipmentStatus.shipmentStatusList[i],
                  isSelected: cubit.currentFilterIndex == i,
                  isLoading: state is ShipmentsLoadingState,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
