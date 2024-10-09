import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/Storage/shared_preference.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../logic/cubit/wasully_details_cubit.dart';
import '../wasully_cancel_dialog.dart';

class WasullyCancelBtn extends StatelessWidget {
  final Color? color;
  const WasullyCancelBtn({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    return SizedBox(
      width: double.infinity,
      child: WeevoButton(
        onTap: () {
          showDialog(
            context: navigator.currentContext!,
            builder: (_) {
              return BlocProvider.value(
                value: cubit,
                child: const WasullyCancelDialog(),
              );
            },
          );
        },
        title: 'إلغاء الطلب',
        color: color ?? weevoPrimaryBlueColor,
        isStable: true,
      ),
    );
  }
}
