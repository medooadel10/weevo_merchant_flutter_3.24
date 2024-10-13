import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/toasts.dart';
import '../../../../../core_new/router/router.dart';
import '../../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../shipments/ui/screens/shipments_screen.dart';

class ShipmentRestoreCancelledButton extends StatelessWidget {
  const ShipmentRestoreCancelledButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShipmentDetailsCubit, ShipmentDetailsState>(
      listener: (context, state) {
        if (state is RestoreCancelError) {
          showToast(state.error, isError: true);
        }
        if (state is RestoreCancelSuccess) {
          showToast('تم اضافة الطلب بنجاح');
          MagicRouter.navigateAndPopUntilFirstPage(const ShipmentsScreen());
        }
      },
      buildWhen: (previous, current) =>
          current is RestoreCancelError ||
          current is RestoreCancelSuccess ||
          current is RestoreCancelLoading,
      builder: (context, state) {
        return state.maybeMap(
          restoreCancelLoading: (_) => const CustomLoadingIndicator(),
          orElse: () => SizedBox(
            width: double.infinity,
            child: WeevoButton(
              onTap: () {
                context.read<ShipmentDetailsCubit>().restoreCancelledShipment();
              },
              title: 'إضافة الطلب',
              color: weevoPrimaryOrangeColor,
              isStable: true,
            ),
          ),
        );
      },
    );
  }
}
