import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/Storage/shared_preference.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/toasts.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../logic/cubit/wasully_details_cubit.dart';
import '../wasully_update_price_dialog.dart';

class WasullyIncreasePriceBtn extends StatelessWidget {
  final Color? color;
  const WasullyIncreasePriceBtn({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    return WeevoButton(
      onTap: () async {
        await cubit.getWassullyDetails(cubit.wasullyModel!.id);
        if (cubit.wasullyModel?.status != 'available') {
          showToast('لا يمكن رفع سعر الطلب بسبب تم قبول الطلب');
          return;
        }
        showDialog(
          context: navigator.currentContext!,
          builder: (_) {
            return BlocProvider.value(
              value: cubit,
              child: const WasullyUpdatePriceDialog(),
            );
          },
        );
      },
      title: 'رفع سعر التوصيل',
      color: color ?? weevoPrimaryBlueColor,
      isStable: true,
    );
  }
}
