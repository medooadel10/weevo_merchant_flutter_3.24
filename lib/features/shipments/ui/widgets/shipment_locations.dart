import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../data/models/shipment_model.dart';

class ShipmentLocations extends StatelessWidget {
  final ShipmentModel shipment;
  const ShipmentLocations({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 10.0.h,
              width: 10.0.w,
              decoration: const BoxDecoration(
                color: weevoPrimaryOrangeColor,
                shape: BoxShape.circle,
              ),
            ),
            horizontalSpace(5),
            Expanded(
              child: Text(
                '${shipment.receivingStateModel?.name} - ${shipment.receivingCityModel?.name}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          backgroundColor: weevoPrimaryOrangeColor,
          radius: 3.0,
        ).paddingOnly(
          right: 2.3.w,
        ),
        verticalSpace(3),
        const CircleAvatar(
          backgroundColor: weevoPrimaryOrangeColor,
          radius: 3.0,
        ).paddingOnly(
          right: 2.3.w,
        ),
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: weevoPrimaryBlueColor,
              radius: 5.0,
            ),
            horizontalSpace(5),
            Expanded(
              child: Text(
                '${shipment.deliveringStateModel?.name} - ${shipment.deliveringCityModel?.name}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
