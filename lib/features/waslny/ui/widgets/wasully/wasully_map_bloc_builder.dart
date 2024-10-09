import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';

import '../../../../../core/Models/address_fill.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/router/router.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';
import '../../screens/wasully_map_screen.dart';

class WasullyMapBlocBuilder extends StatelessWidget {
  const WasullyMapBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyCubit, WasullyStates>(
      builder: (context, state) {
        WasullyCubit cubit = context.read();
        return Column(
          children: [
            InkWell(
              onTap: () {
                LatLng? location;
                if (cubit.recieverAddressFill != null) {
                  location = LatLng(
                    cubit.recieverAddressFill!.lat,
                    cubit.recieverAddressFill!.long,
                  );
                }
                MagicRouter.navigateTo(WasullyMapScreen(location: location))
                    .then(
                  (value) {
                    if (value is AddressFill) {
                      cubit.changeRecieverAddress(value);
                      cubit.getDeliveryPrice(navigator.currentContext!);
                    }
                  },
                );
              },
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 4.0.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.grey[400]!,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الإستلام من',
                            style: TextStyle(
                              color: weevoDarkGrey,
                            ),
                          ),
                          verticalSpace(4),
                          Text(
                            cubit.recieverAddressFill == null
                                ? 'اختر مكان الإستلام'
                                : '${cubit.recieverAddressFill?.administrativeArea} - ${cubit.recieverAddressFill?.subAdministrativeArea}',
                            style: const TextStyle(
                              color: weevoDarkGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/google_map.svg',
                      height: 25.0.h,
                      width: 25.0.w,
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(14.0),
            InkWell(
              onTap: () {
                LatLng? location;
                if (cubit.senderAddressFill != null) {
                  location = LatLng(
                    cubit.senderAddressFill!.lat,
                    cubit.senderAddressFill!.long,
                  );
                }
                MagicRouter.navigateTo(WasullyMapScreen(location: location))
                    .then(
                  (value) {
                    if (value is AddressFill) {
                      cubit.changeSenderAddress(value);
                      cubit.getDeliveryPrice(navigator.currentContext!);
                    }
                  },
                );
              },
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 4.0.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.grey[400]!,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'التوصيل إلى',
                            style: TextStyle(
                              color: weevoDarkGrey,
                            ),
                          ),
                          verticalSpace(4),
                          Text(
                            cubit.senderAddressFill == null
                                ? 'اختر مكان التوصيل'
                                : '${cubit.senderAddressFill?.administrativeArea} - ${cubit.senderAddressFill?.subAdministrativeArea}',
                            style: const TextStyle(
                              color: weevoDarkGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/google_map.svg',
                      height: 25.0.h,
                      width: 25.0.w,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
