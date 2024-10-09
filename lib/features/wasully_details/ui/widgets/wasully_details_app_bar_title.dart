import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';
import 'wasully_details_qr_code.dart';
import 'wasully_details_waiting_offers.dart';

class WasullyDetailsAppBarTitle extends StatelessWidget {
  final int? id;
  const WasullyDetailsAppBarTitle({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        final cubit = context.read<WasullyDetailsCubit>();
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
            if (cubit.wasullyModel != null &&
                cubit.wasullyModel?.status == 'available')
              const WasullyDetailsWaitingOffers(),
            if (cubit.wasullyModel != null &&
                cubit.wasullyModel?.status != 'available' &&
                cubit.wasullyModel?.status != 'cancelled' &&
                cubit.wasullyModel?.status != 'returned')
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
