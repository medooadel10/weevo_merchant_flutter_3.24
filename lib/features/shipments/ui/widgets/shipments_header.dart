import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_shimmer.dart';
import 'package:weevo_merchant_upgrade/features/shipments/logic/cubit/shipments_cubit.dart';
import 'package:weevo_merchant_upgrade/features/shipments/logic/cubit/shipments_states.dart';

class ShipmentsHeader extends StatelessWidget {
  const ShipmentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentsCubit, ShipmentsStates>(
      buildWhen: (previous, current) =>
          current is ShipmentsLoadingState ||
          current is ShipmentsErrorState ||
          current is ShipmentsSuccessState,
      builder: (context, state) {
        final cubit = context.read<ShipmentsCubit>();
        if (state is ShipmentsSuccessState) {
          return Text(
            '${cubit.responseBody?.total} طلب',
            style: TextStyle(
              fontSize: 14.0.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        return _buildLoading();
      },
    ).paddingSymmetric(
      horizontal: 16.0.w,
      vertical: 10.0.h,
    );
  }

  Widget _buildLoading() {
    return CustomShimmer(
      height: 10.0.h,
      width: 80.0.w,
    );
  }
}
