import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../data/entities/stepper_data.dart';
import '../logic/add_shipment_cubit.dart';
import 'widgets/add_shipment_buttons.dart';
import 'widgets/add_shipment_stepper.dart';

class AddShipmentScreen extends StatelessWidget {
  const AddShipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddShipmentCubit()..init(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'اضافة طلب',
          ),
        ),
        body: BlocBuilder<AddShipmentCubit, AddShipmentState>(
          builder: (context, state) {
            AddShipmentCubit cubit = context.read<AddShipmentCubit>();
            return SafeArea(
              child: Column(
                children: [
                  Column(
                    children: [
                      const AddShipmentStepper(),
                      Text(
                        StepperData.list[cubit.currentIndex].description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ).paddingSymmetric(
                        horizontal: 20.w,
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          StepperData.list[cubit.currentIndex].body
                              .paddingSymmetric(
                            vertical: 10.h,
                          ),
                        ],
                      ),
                    ).paddingSymmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                  ),
                  const AddShipmentButtons().paddingOnly(
                    left: 20.w,
                    right: 20.w,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
