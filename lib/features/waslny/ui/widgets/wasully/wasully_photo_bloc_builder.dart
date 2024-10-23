import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_bottom_sheet.dart';

import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/widgets/custom_image.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';

class WasullyPhotoBlocBuilder extends StatelessWidget {
  const WasullyPhotoBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<WasullyCubit, WasullyStates>(
          buildWhen: (previous, current) =>
              current is WasullyChangeImageState ||
              current is WasullyInitialState,
          builder: (context, state) {
            WasullyCubit cubit = context.read();
            return Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    CustomBottomSheet.show(
                      context,
                      items: [
                        BottomSheetItem(
                          icon: Icons.camera_alt_outlined,
                          title: 'الكاميرا',
                          onTap: () {
                            cubit.pickImage(true);
                          },
                        ),
                        BottomSheetItem(
                          icon: Icons.photo_library_outlined,
                          title: 'المعرض',
                          onTap: () {
                            cubit.pickImage(false);
                          },
                        ),
                      ],
                      title: 'إختيار صورة',
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0.w,
                      vertical: 10.0.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: cubit.wasullyModel?.image != null ||
                                cubit.image != null
                            ? weevoPrimaryBlueColor
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'إرفع صورة الطلب',
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: cubit.wasullyModel?.image != null ||
                                          cubit.image != null
                                      ? weevoPrimaryBlueColor
                                      : Colors.grey[600],
                                ),
                              ),
                              if (cubit.wasullyModel?.image != null ||
                                  cubit.image != null) ...[
                                horizontalSpace(10),
                                const Icon(
                                  Icons.check,
                                  color: weevoPrimaryBlueColor,
                                ),
                              ],
                            ],
                          ),
                        ),
                        horizontalSpace(10),
                        Icon(
                          Icons.camera_alt,
                          color: cubit.wasullyModel?.image != null ||
                                  cubit.image != null
                              ? weevoPrimaryBlueColor
                              : Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is WasullyChangeImageState && state.image != null)
                  Container(
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
                  )
                else if (cubit.wasullyModel != null &&
                    cubit.wasullyModel!.image != null)
                  CustomImage(
                    imageUrl: cubit.wasullyModel?.image,
                    width: double.infinity,
                  ).paddingSymmetric(
                    vertical: 14.h,
                  )
                else
                  verticalSpace(14),
              ],
            );
          },
        ),
      ],
    );
  }
}
