import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return Row(
          children: [
            const Text(
              'من سيدفع رسوم التوصيل؟',
              style: TextStyle(
                color: weevoDarkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: Row(
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () => cubit.changeWhoPayDeliveryPrice(1),
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
                            fillColor: WidgetStateProperty.all(
                                weevoPrimaryOrangeColor),
                            activeColor: weevoPrimaryOrangeColor,
                            onChanged: (value) {
                              cubit.changeWhoPayDeliveryPrice(value!);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
