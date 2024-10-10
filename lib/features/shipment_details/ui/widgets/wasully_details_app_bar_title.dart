import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/helpers/spacing.dart';
import 'shipment_details_qr_code.dart';
import 'shipment_details_waiting_offers.dart';

class ShipmentDetailsAppBarTitle extends StatelessWidget {
  final int? id;
  const ShipmentDetailsAppBarTitle({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ShipmentDetailsCubit>();
        return Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'طلب وصلي رقم $id',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: weevoPrimaryOrangeColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            horizontalSpace(5),
            if (cubit.shipmentDetails != null &&
                cubit.shipmentDetails?.status == 'available')
              const ShipmentDetailsWaitingOffers(),
            if (cubit.shipmentDetails != null &&
                cubit.shipmentDetails?.status != 'available' &&
                cubit.shipmentDetails?.status != 'cancelled' &&
                cubit.shipmentDetails?.status != 'returned')
              WasullyDetailsQrCode(
                courierNationalId: cubit.courierNationalId,
                merchantNationalId: cubit.merchantNationalId,
                locationId: cubit.locationId,
                status: cubit.status,
              ),
          ],
        );
      },
    );
  }
}
