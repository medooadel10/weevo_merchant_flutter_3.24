import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';

import '../../../../core_new/helpers/spacing.dart';
import '../../logic/add_shipment_cubit.dart';

class AddShipmentButtons extends StatelessWidget {
  const AddShipmentButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddShipmentCubit>();
    return BlocBuilder<AddShipmentCubit, AddShipmentState>(
      builder: (context, state) {
        return Column(
          children: [
            verticalSpace(10),
            WeevoButton(
              onTap: () {
                if (cubit.currentIndex == 0) {
                  if (cubit.formKeyFirst.currentState?.validate() ?? false) {
                    cubit.changeStepperIndex(cubit.currentIndex + 1);
                  }
                }
                if (cubit.currentIndex == 1) {
                  if (cubit.formKeySecond.currentState?.validate() ?? false) {
                    cubit.changeStepperIndex(cubit.currentIndex + 1);
                  }
                }
              },
              title: 'التالي',
              autoDelay: false,
              color: weevoPrimaryOrangeColor,
              isStable: true,
              isExpand: true,
            ),
            if (cubit.currentIndex != 0) ...[
              verticalSpace(10),
              WeevoButton(
                onTap: () {
                  cubit.changeStepperIndex(cubit.currentIndex - 1);
                },
                title: 'رجوع',
                autoDelay: false,
                color: weevoPrimaryOrangeColor,
                isStable: false,
                isExpand: true,
              ),
            ],
          ],
        );
      },
    );
  }
}
