import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';

class WasullyWhoPaid extends StatelessWidget {
  const WasullyWhoPaid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyCubit, WasullyStates>(
      buildWhen: (previous, current) =>
          current is WasullyInitialState ||
          current is WasullyChangeWhoPaidState,
      builder: (context, state) {
        WasullyCubit cubit = context.read();
        return Container(
          padding: EdgeInsets.only(
            left: 12.0.w,
            right: 12.0.w,
            top: 8.0.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'من سيدفع رسوم التوصيل؟',
                style: TextStyle(
                  color: weevoDarkGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              verticalSpace(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (state is! WasullyCreateWasullyLoadingState) {
                        cubit.changeWhoPayDeliveryPrice(0);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        const Text(
                          ' أنا',
                          style: TextStyle(
                            color: weevoDarkGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Radio(
                          value: 0,
                          groupValue: cubit.whoPayDeliveryPrice,
                          fillColor:
                              WidgetStateProperty.all(weevoPrimaryOrangeColor),
                          activeColor: weevoPrimaryOrangeColor,
                          onChanged: (value) {
                            cubit.changeWhoPayDeliveryPrice(value!);
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => cubit.changeWhoPayDeliveryPrice(1),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        const Text(
                          'المستلم',
                          style: TextStyle(
                            color: weevoDarkGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Radio(
                          value: 1,
                          groupValue: cubit.whoPayDeliveryPrice,
                          fillColor:
                              WidgetStateProperty.all(weevoPrimaryOrangeColor),
                          activeColor: weevoPrimaryOrangeColor,
                          onChanged: (value) {
                            cubit.changeWhoPayDeliveryPrice(value!);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
