import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../logic/wasully_map_cubit/wasully_map_cubit.dart';
import '../../../logic/wasully_map_cubit/wasully_map_states.dart';

class WasullyMapCurrentLocation extends StatelessWidget {
  const WasullyMapCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyMapCubit, WasullyMapStates>(
      builder: (context, state) {
        WasullyMapCubit cubit = context.read();
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              right: 20.0.w,
            ),
            child: GestureDetector(
              onTap: () {
                cubit.getCurrentUserLocation(cubit.mapController!);
              },
              child: const CircleAvatar(
                backgroundColor: weevoPrimaryBlueColor,
                child: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    ).paddingSymmetric(
      horizontal: 20.0.w,
      vertical: 20.0.h,
    );
  }
}
