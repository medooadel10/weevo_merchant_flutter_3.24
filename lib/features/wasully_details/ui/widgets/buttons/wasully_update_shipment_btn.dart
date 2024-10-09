import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/toasts.dart';
import '../../../../../core_new/router/router.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../waslny/ui/screens/wasully_screen.dart';
import '../../../data/models/wasully_model.dart';
import '../../../logic/cubit/wasully_details_cubit.dart';

class WasullyUpdateShipmentBtn extends StatelessWidget {
  final Color? color;
  const WasullyUpdateShipmentBtn({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    return SizedBox(
      width: double.infinity,
      child: WeevoButton(
        onTap: () async {
          await cubit.getWassullyDetails(cubit.wasullyModel!.id);
          if (cubit.wasullyModel?.status ==
                  'merchant-accepted-shipping-offer' ||
              cubit.wasullyModel?.status ==
                  'on-the-way-to-get-shipment-from-merchant' ||
              cubit.wasullyModel?.status == 'courier-applied-to-shipment' ||
              cubit.wasullyModel?.status == 'on-delivery') {
            showToast('لا يمكن تعديل الطلب بسبب تم قبول الطلب');
            return;
          }
          if (cubit.wasullyModel?.status == 'delivered') {
            showToast('لا يمكن تعديل الطلب بسبب تم إستلام الطلب');
            return;
          }
          if (cubit.wasullyModel?.status == 'returned') {
            showToast('لا يمكن تعديل الطلب بسبب تم استرجاع الطلب');
            return;
          }
          MagicRouter.navigateTo(
            WasullyScreen(
              wasullyModel: cubit.wasullyModel,
            ),
          ).then((value) {
            if (value is WasullyModel) {
              cubit.updateWasully(value);
            }
          });
        },
        color: color ?? weevoPrimaryOrangeColor,
        isStable: true,
        title: 'تعديل الطلب',
      ),
    );
  }
}
