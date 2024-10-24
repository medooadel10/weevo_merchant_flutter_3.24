import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/constants.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';
import 'package:weevo_merchant_upgrade/features/wasully_details/logic/cubit/wasully_details_cubit.dart';

import '../../../../core/Dialogs/loading_dialog.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/helpers/toasts.dart';
import '../../../shipments/ui/screens/shipments_screen.dart';
import '../../logic/cubit/wasully_details_state.dart';

class WasullyCancelBottomSheet extends StatelessWidget {
  const WasullyCancelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final WasullyDetailsCubit cubit = context.read();
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إختر سبب إلغاء الطلب',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpace(20),
            ListView.separated(
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  cubit.selectCancellationReason(index);
                },
                child: AnimatedContainer(
                  width: double.infinity,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: cubit.selectedCancellationReasonIndex == index
                        ? weevoPrimaryBlueColor
                        : null,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0.h,
                    horizontal: 12.0.w,
                  ),
                  child: Text(
                    AppConstants.cancellationReasons[index],
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: cubit.selectedCancellationReasonIndex == index
                          ? Colors.white
                          : Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              separatorBuilder: (context, index) {
                if (index == cubit.selectedCancellationReasonIndex) {
                  return const SizedBox();
                }
                return const Divider(
                  color: Colors.grey,
                );
              },
              itemCount: AppConstants.cancellationReasons.length,
              shrinkWrap: true,
            ),
            verticalSpace(10),
            WeevoButton(
              onTap: () {
                if (cubit.selectedCancellationReasonIndex == null) {
                  showToast('يرجى تحديد سبب الغاء الطلب');
                  return;
                }
                showDialog(
                  context: context,
                  builder: (context) =>
                      BlocListener<WasullyDetailsCubit, WasullyDetailsState>(
                    listener: (context, state) {
                      if (state is WasullyCancelSuccessState) {
                        context.pop();
                        showToast('تم الغاء الطلب بنجاح');
                        MagicRouter.navigateAndPop(const ShipmentsScreen(
                          filterIndex: 6,
                        ));
                      }
                      if (state is WasullyCancelErrorState) {
                        context.pop();
                        cubit.getWassullyDetails(cubit.wasullyModel!.id);
                        showToast('لا يمكنك إلغاء هذا الطلب', isError: true);
                      }
                    },
                    child: const LoadingDialog(),
                  ),
                );
                cubit.cancelWasully();
              },
              title: 'الغاء الطلب',
              color: weevoPrimaryOrangeColor,
              isStable: true,
              isExpand: true,
            ),
          ],
        );
      },
    ).paddingSymmetric(
      horizontal: 20.0.w,
      vertical: 20.0.h,
    );
  }
}
