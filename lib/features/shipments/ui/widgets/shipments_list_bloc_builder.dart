import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core_new/data/models/shipment_status/base_shipment_status.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../data/models/shipment_model.dart';
import '../../logic/cubit/shipments_cubit.dart';
import '../../logic/cubit/shipments_states.dart';
import 'shipment_tile.dart';
import 'shipments_loading.dart';

class ShipmentsListBlocBuilder extends StatelessWidget {
  const ShipmentsListBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentsCubit, ShipmentsStates>(
      buildWhen: (previous, current) =>
          current is ShipmentsLoadingState ||
          current is ShipmentsSuccessState ||
          current is ShipmentsErrorState ||
          current is ShipmentsPagingLoadingState,
      builder: (context, state) {
        final cubit = context.read<ShipmentsCubit>();
        if (state is ShipmentsLoadingState || state is ShipmentsErrorState) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0.w,
              vertical: 10.0.h,
            ),
            child: const ShipmentsLoading(),
          );
        }
        if (cubit.shipments?.isEmpty ?? true) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: 50.0.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/shipment_details_icon.png',
                  height: 80.0.h,
                  fit: BoxFit.fill,
                ),
                verticalSpace(10),
                Text(
                  'لا يوجد لديك طلبات ${BaseShipmentStatus.shipmentStatusList[cubit.currentFilterIndex].statusAr}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0.w,
            vertical: 10.0.h,
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ShipmentModel shipment = cubit.shipments![index];
                    return ShipmentTile(
                      shipment: shipment,
                    );
                  },
                  separatorBuilder: (context, index) => verticalSpace(14),
                  itemCount: cubit.shipments!.length,
                ),
                if (state is ShipmentsPagingLoadingState) ...[
                  verticalSpace(14),
                  const ShipmentsLoading(
                    itemCount: 3,
                  ),
                ],
                verticalSpace(14),
              ],
            ),
          ),
        );
      },
    );
  }
}
