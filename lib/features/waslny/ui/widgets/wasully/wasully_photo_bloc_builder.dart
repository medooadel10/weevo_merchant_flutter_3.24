import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core/Storage/shared_preference.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/widgets/custom_image.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';
import 'wasully_photo_picker_bottom_sheet.dart';

class WasullyPhotoBlocBuilder extends StatelessWidget {
  const WasullyPhotoBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    WasullyCubit cubit = context.read();
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            showModalBottomSheet(
              context: navigator.currentContext!,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: cubit,
                  child: const WasullyPhotoPickerBlocConsumer(),
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0.w,
              vertical: 10.0.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey[400]!,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'إرفع صورة الطلب',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                horizontalSpace(10),
                Icon(
                  Icons.camera_alt,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<WasullyCubit, WasullyStates>(
          buildWhen: (previous, current) =>
              current is WasullyChangeImageState ||
              current is WasullyInitialState,
          builder: (context, state) {
            WasullyCubit cubit = context.read();

            if (state is WasullyChangeImageState && state.image != null) {
              return Container(
                height: 100.0.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: FileImage(state.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ).paddingSymmetric(
                vertical: 14.h,
              );
            } else if (cubit.wasullyModel != null &&
                cubit.wasullyModel!.image != null) {
              return CustomImage(
                imageUrl: cubit.wasullyModel?.image,
                width: double.infinity,
              ).paddingSymmetric(
                vertical: 14.h,
              );
            }
            return verticalSpace(14);
          },
        ),
      ],
    );
  }
}
