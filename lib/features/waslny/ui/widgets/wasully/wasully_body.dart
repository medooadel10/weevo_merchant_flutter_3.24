import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';
import 'wasully_form.dart';

class WasullyBody extends StatelessWidget {
  const WasullyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyCubit, WasullyStates>(
      buildWhen: (previous, current) =>
          current is WasullyGetDataLoadingState ||
          current is WasullyGetDataSuccessState ||
          current is WasullyGetDataErrorState,
      builder: (context, state) {
        WasullyCubit cubit = context.read<WasullyCubit>();
        if (state is WasullyGetDataLoadingState)
          return const CustomLoadingIndicator();
        else if (state is WasullyGetDataSuccessState ||
            cubit.wasullyModel != null)
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                SystemChannels.textInput.invokeMethod('TextInput.hide'),
            child: const SingleChildScrollView(
              child: WasullyForm(),
            ).paddingOnly(
              left: 20.0.w,
              right: 20.0.w,
              bottom: 20.0.h,
            ),
          );
        else if (state is WasullyGetDataErrorState)
          return Center(
            child: Text(
              state.error,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        return Container();
      },
    );
  }
}
