import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core/Storage/shared_preference.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/toasts.dart';
import '../../../../../core_new/router/router.dart';
import '../../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../wasully_details/ui/screens/wasully_details_screen.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';

class WasullySubmitBlocConsumer extends StatelessWidget {
  const WasullySubmitBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    WasullyCubit cubit = context.read<WasullyCubit>();
    return BlocListener<WasullyCubit, WasullyStates>(
      listenWhen: (previous, current) =>
          current is WasullyCreateWasullyLoadingState ||
          current is WasullyCreateWasullySuccessState ||
          current is WasullyCreateWasullyErrorState,
      listener: (context, state) {
        if (state is WasullyCreateWasullyLoadingState) {
          showLoadingIndicator(context);
        } else if (state is WasullyCreateWasullyErrorState) {
          showToast(state.error, isError: true);
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: WeevoButton(
          onTap: () => cubit.wasullyModel != null
              ? cubit.updateWasully()
              : cubit.createWasully(),
          title: cubit.wasullyModel != null
              ? 'تعديل الطلب'
              : 'إبحث عن كابتن للتوصيل',
          color: weevoPrimaryOrangeColor,
          isStable: true,
        ),
      ),
    );
  }

  void showLoadingIndicator(BuildContext context) {
    showDialog(
        context: navigator.currentContext!,
        barrierDismissible: false,
        builder: (_) {
          WasullyCubit cubit = context.read<WasullyCubit>();
          return BlocProvider.value(
            value: cubit,
            child: PopScope(
              onPopInvokedWithResult: (value, result) async => false,
              child: BlocListener<WasullyCubit, WasullyStates>(
                listenWhen: (previous, current) =>
                    current is WasullyCreateWasullyLoadingState ||
                    current is WasullyCreateWasullySuccessState ||
                    current is WasullyCreateWasullyErrorState,
                listener: (context, state) {
                  if (state is WasullyCreateWasullySuccessState) {
                    if (cubit.wasullyModel == null) {
                      showToast('تم إنشاء الطلب بنجاح', isError: false);
                      String idNumber = state.message.extractNumber() ?? '';
                      MagicRouter.pop();
                      MagicRouter.navigateAndPop(
                        WasullyDetailsScreen(
                          id: int.parse(idNumber),
                          navigateToOffers: true,
                        ),
                      );
                    } else {
                      showToast('تم تعديل الطلب بنجاح', isError: false);
                      MagicRouter.pop();
                      MagicRouter.pop(data: cubit.wasullyModel);
                    }
                  } else if (state is WasullyCreateWasullyErrorState) {
                    showToast(state.error, isError: true);
                    MagicRouter.pop();
                  }
                },
                child: const CustomLoadingIndicator(),
              ),
            ),
          );
        });
  }
}
