import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core_new/widgets/custom_image.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';

class WasullyPhotoBlocBuilder extends StatelessWidget {
  const WasullyPhotoBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyCubit, WasullyStates>(
      buildWhen: (previous, current) =>
          current is WasullyChangeImageState || current is WasullyInitialState,
      builder: (context, state) {
        WasullyCubit cubit = context.read();

        if (state is WasullyChangeImageState && state.image != null) {
          return Stack(
            children: [
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
              ),
            ],
          ).paddingSymmetric(
            vertical: 14.h,
          );
        } else if (cubit.wasullyModel != null &&
            cubit.wasullyModel!.image != null) {
          return CustomImage(
            imageUrl: cubit.wasullyModel?.image,
            width: double.infinity,
          ).paddingSymmetric(
            vertical: 14.h,
          );
        }
        return Container();
      },
    );
  }
}
