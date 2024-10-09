import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';

class WasullyDeliveryPrice extends StatelessWidget {
  const WasullyDeliveryPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyCubit, WasullyStates>(
      buildWhen: (previous, current) =>
          current is WasullyCalculateDeliveryPriceSuccessState ||
          current is WasullyCalculateDeliveryPriceErrorState ||
          current is WasullyCalculateDeliveryPriceLoadingState,
      builder: (context, state) {
        if (state is WasullyCalculateDeliveryPriceSuccessState) {
          return Text(
            'سعر التوصيل المتوقع هو ${state.deliveryPriceModel.price} جنيه مصري',
            style: TextStyle(
              color: weevoPrimaryOrangeColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (state is WasullyCalculateDeliveryPriceErrorState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.error,
                style: TextStyle(
                  color: weevoPrimaryOrangeColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!state.error.contains('التوصيل')) ...[
                horizontalSpace(5.0),
                GestureDetector(
                  onTap: () {
                    context.read<WasullyCubit>().getDeliveryPrice(context);
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: weevoPrimaryOrangeColor,
                    size: 20.0,
                  ),
                ),
              ],
            ],
          );
        }

        if (state is WasullyCalculateDeliveryPriceLoadingState) {
          return Center(
            child: LinearProgressIndicator(
              color: weevoPrimaryOrangeColor,
              minHeight: 2.0.h,
            ),
          );
        }
        return Container();
      },
    );
  }
}
