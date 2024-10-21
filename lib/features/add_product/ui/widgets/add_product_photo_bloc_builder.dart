import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/features/add_product/logic/cubit/add_product_cubit.dart';

import '../../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_bottom_sheet.dart';

class AddProductPhotoBlocBuilder extends StatelessWidget {
  const AddProductPhotoBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    AddProductCubit cubit = context.read();
    return Column(
      children: [
        BlocBuilder<AddProductCubit, AddProductState>(
          builder: (context, state) {
            return Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      showDragHandle: true,
                      sheetAnimationStyle: AnimationStyle(
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 500),
                      ),
                      builder: (context) {
                        return CustomBottomSheet(
                          items: [
                            BottomSheetItem(
                              icon: Icons.camera_alt,
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
                        );
                      },
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
                        color: cubit.image != null
                            ? weevoDarkGreen
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'صورة المنتج',
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: cubit.image != null
                                      ? weevoDarkGreen
                                      : Colors.grey[600],
                                ),
                              ),
                              if (cubit.image != null) ...[
                                horizontalSpace(10),
                                Icon(
                                  Icons.check,
                                  color: weevoDarkGreen,
                                  size: 16.0.sp,
                                ),
                              ],
                            ],
                          ),
                        ),
                        horizontalSpace(10),
                        Icon(
                          Icons.camera_alt,
                          color: cubit.image != null
                              ? weevoDarkGreen
                              : Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                if (cubit.image != null)
                  Container(
                    height: 100.0.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: FileImage(cubit.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
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
