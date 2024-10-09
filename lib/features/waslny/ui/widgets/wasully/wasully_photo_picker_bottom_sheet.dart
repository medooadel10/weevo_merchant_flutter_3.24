import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';

class WasullyPhotoPickerBlocConsumer extends StatelessWidget {
  const WasullyPhotoPickerBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    final WasullyCubit cubit = context.read();
    return BlocListener<WasullyCubit, WasullyStates>(
      listener: (context, state) {
        if (state is WasullyChangeImageState) {
          context.pop();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: weevoDarkGrey,
              size: 30,
            ),
            onPressed: () => context.pop(),
          ),
          GestureDetector(
            onTap: () => cubit.pickImage(true),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(
                  Icons.camera_alt,
                ),
                horizontalSpace(10.0),
                Text(
                  'الكاميرا',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0.sp,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(10.0),
          GestureDetector(
            onTap: () => cubit.pickImage(false),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(
                  Icons.photo_library,
                ),
                horizontalSpace(10.0),
                Text(
                  'المعرض',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ).paddingSymmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),
    );
  }
}
