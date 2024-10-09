import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/helpers/toasts.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../Widgets/weevo_button.dart';
import '../../../shipments/ui/screens/shipments_screen.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';

class WasullyCancelDialog extends StatelessWidget {
  const WasullyCancelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final WasullyDetailsCubit cubit = context.read();
    cubit.priceController.text = cubit.wasullyModel!.price.toString();
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0.w,
            vertical: 20.0.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تأكيد الغاء الطلب ؟',
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              verticalSpace(12),
              BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
                listener: (context, state) {
                  if (state is WasullyCancelSuccessState) {
                    showToast('تم الغاء الطلب بنجاح');
                    // Cancel Dialog
                    MagicRouter.pop(); // Naviagte to shipments screen
                    MagicRouter.navigateAndPopUntilFirstPage(
                        const ShipmentsScreen(
                      filterIndex: 6,
                    ));
                  }
                  if (state is WasullyCancelErrorState) {
                    MagicRouter.pop();
                    cubit.getWassullyDetails(cubit.wasullyModel!.id);
                    showToast('لا يمكنك إلغاء هذا الطلب', isError: true);
                  }
                },
                builder: (context, state) {
                  if (state is WasullyCancelLoadingState) {
                    return const Center(
                      child: CustomLoadingIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      WeevoButton(
                        onTap: () {
                          cubit.cancelWasully();
                        },
                        title: 'الغاء الطلب',
                        color: weevoPrimaryOrangeColor,
                        isStable: true,
                        isExpand: true,
                      ),
                      verticalSpace(8),
                      WeevoButton(
                        onTap: () {
                          MagicRouter.pop();
                        },
                        title: 'الغاء',
                        color: weevoRedColor,
                        isStable: true,
                        isExpand: true,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
