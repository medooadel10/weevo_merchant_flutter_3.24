import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/helpers/toasts.dart';
import '../../../../core_new/router/router.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../Widgets/weevo_button.dart';
import '../../../shipments/ui/screens/shipments_screen.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';

class WasullyRestoreCancelledButton extends StatelessWidget {
  const WasullyRestoreCancelledButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
      listener: (context, state) {
        if (state is WasullyRestoreErrorState) {
          showToast(state.error, isError: true);
        }
        if (state is WasullyRestoreSuccessState) {
          showToast('تم اضافة الطلب بنجاح');
          MagicRouter.navigateAndPopUntilFirstPage(const ShipmentsScreen());
        }
      },
      buildWhen: (previous, current) =>
          current is WasullyRestoreErrorState ||
          current is WasullyRestoreSuccessState ||
          current is WasullyRestoreLoadingState,
      builder: (context, state) {
        if (state is WasullyRestoreLoadingState) {
          return const CustomLoadingIndicator();
        }
        return SizedBox(
          width: double.infinity,
          child: WeevoButton(
            onTap: () {
              context.read<WasullyDetailsCubit>().restoreWasully();
            },
            title: 'إضافة الطلب',
            color: weevoPrimaryOrangeColor,
            isStable: true,
          ),
        );
      },
    );
  }
}
