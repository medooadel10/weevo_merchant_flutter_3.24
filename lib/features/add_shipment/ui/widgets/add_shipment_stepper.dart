import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';

import '../../data/entities/stepper_data.dart';
import '../../logic/add_shipment_cubit.dart';

class AddShipmentStepper extends StatelessWidget {
  const AddShipmentStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddShipmentCubit>();
    return BlocBuilder<AddShipmentCubit, AddShipmentState>(
      builder: (context, state) {
        return EasyStepper(
          activeStep: cubit.currentIndex,
          showScrollbar: true,
          disableScroll: false,
          stepShape: StepShape.circle,
          enableStepTapping: false,
          dashPattern: const [10, 5],
          padding: EdgeInsets.zero,
          lineStyle: const LineStyle(
            activeLineColor: weevoPrimaryOrangeColor,
            unreachedLineColor: Colors.grey,
          ),
          defaultStepBorderType: BorderType.dotted,
          internalPadding: 10,
          showLoadingAnimation: false,
          stepRadius: 35,
          showStepBorder: true,
          steps: List.generate(
            StepperData.list.length,
            (index) => _buildStepperItem(
              context,
              index,
              StepperData.list[index].title,
              StepperData.list[index].image,
            ),
          ),
        );
      },
    );
  }

  EasyStep _buildStepperItem(
    BuildContext context,
    int index,
    String title,
    String image,
  ) {
    int currentStep = context.read<AddShipmentCubit>().currentIndex;
    return EasyStep(
      enabled: index <= currentStep,
      customTitle: Text(
        title,
        style: TextStyle(
          fontSize: 12.0.sp,
          fontWeight: index <= currentStep ? FontWeight.bold : FontWeight.w400,
          color: index <= currentStep ? weevoPrimaryOrangeColor : Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
      customStep: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.read<AddShipmentCubit>().changeStepperIndex(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: index <= currentStep
                ? weevoPrimaryOrangeColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(
              35.0,
            ),
          ),
          child: Image.asset(
            'assets/images/$image.png',
            color: index <= currentStep ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
