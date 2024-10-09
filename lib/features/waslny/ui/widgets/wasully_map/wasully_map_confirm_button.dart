import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/router/router.dart';
import '../../../logic/wasully_map_cubit/wasully_map_cubit.dart';
import '../../../logic/wasully_map_cubit/wasully_map_states.dart';

class WasullyMapConfirmButton extends StatelessWidget {
  const WasullyMapConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyMapCubit, WasullyMapStates>(
      buildWhen: (previous, current) =>
          current is WasullyMapGetAddressSuccessState ||
          current is WasullyMapGetAddressLoadingState ||
          current is WasullyMapGetAddressErrorState,
      builder: (context, state) {
        WasullyMapCubit cubit = context.read();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: state is WasullyMapGetAddressLoadingState
              ? const Center(
                  child: SpinKitDoubleBounce(
                    color: weevoPrimaryBlueColor,
                    size: 30.0,
                  ),
                )
              : Column(
                  children: [
                    if (state is WasullyMapGetAddressSuccessState) ...[
                      Text(
                        '${cubit.currentAddress}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      verticalSpace(10),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (cubit.addressFill != null) {
                            MagicRouter.pop(data: cubit.addressFill);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(weevoPrimaryBlueColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(
                              16.0,
                            ),
                          ),
                        ),
                        child: const Text(
                          'تأكيد',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
