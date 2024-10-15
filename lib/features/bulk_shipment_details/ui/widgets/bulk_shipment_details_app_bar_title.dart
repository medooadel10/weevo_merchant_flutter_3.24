import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/logic/cubit/bulk_shipment_cubit.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/helpers/spacing.dart';
import 'bulk_shipment_details_qr_code.dart';
import 'bulk_shipment_details_waiting_offers.dart';

class BulkShipmentDetailsAppBarTitle extends StatelessWidget {
  final int? id;
  const BulkShipmentDetailsAppBarTitle({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulkShipmentCubit, BulkShipmentState>(
      builder: (context, state) {
        final cubit = context.read<BulkShipmentCubit>();
        return Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'طلبات رقم $id',
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
            if (cubit.bulkShipmentModel != null &&
                cubit.bulkShipmentModel?.status == 'available')
              const BulkShipmentDetailsWaitingOffers(),
            if (cubit.bulkShipmentModel != null &&
                cubit.bulkShipmentModel?.status != 'available' &&
                cubit.bulkShipmentModel?.status != 'cancelled' &&
                cubit.bulkShipmentModel?.status != 'returned')
              BulkShipmentDetailsQrCode(
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
