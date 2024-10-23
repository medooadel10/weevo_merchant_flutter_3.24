import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_bottom_sheet.dart';

import '../../../../../core/Providers/map_provider.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/widgets/custom_text_field.dart';

class AddShipmentFirstBody extends StatelessWidget {
  const AddShipmentFirstBody({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.read<MapProvider>();
    return Column(
      children: [
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'العنوان',
          errorMsg: 'العنوان مطلوب',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          prefixIcon: CupertinoIcons.chevron_down_circle,
          onTap: () {
            CustomBottomSheet.show(
              context,
              children: mapProvider.address
                      ?.map(
                        (e) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.name ?? '',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              verticalSpace(5),
                              Text(
                                e.state ?? '',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              verticalSpace(10),
                              Text(
                                '${e.buildingNumber} ${e.street} - الدور ${e.floor} - شقة ${e.apartment} \nعلامة مميزة: ${e.landmark}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ).paddingSymmetric(
                          horizontal: 16.0.w,
                          vertical: 8.0,
                        ),
                      )
                      .toList() ??
                  [],
              title: 'إختر العنوان',
            );
          },
          readOnly: true,
          suffixIcon: Icons.place,
        ),
        verticalSpace(16),
        CustomTextField(
          controller: TextEditingController(),
          hintText: 'تاريخ استلام الشحنة',
          errorMsg: 'تاريخ استلام الشحنة مطلوب',
          keyboardType: TextInputType.datetime,
          textInputAction: TextInputAction.done,
          suffixIcon: Icons.touch_app_rounded,
          onTap: () {},
          readOnly: true,
          prefixIcon: Icons.access_time_sharp,
        ),
      ],
    );
  }
}
