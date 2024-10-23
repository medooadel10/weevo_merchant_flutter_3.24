import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_bottom_sheet.dart';
import 'package:weevo_merchant_upgrade/features/add_shipment/logic/add_shipment_cubit.dart';

import '../../../../../core/Providers/map_provider.dart';
import '../../../../../core/Storage/shared_preference.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/widgets/custom_text_field.dart';

class AddShipmentFirstBody extends StatelessWidget {
  const AddShipmentFirstBody({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.read<MapProvider>();
    final cubit = context.read<AddShipmentCubit>();
    return BlocBuilder<AddShipmentCubit, AddShipmentState>(
      builder: (context, state) {
        return Form(
          key: cubit.formKeyFirst,
          child: Column(
            children: [
              CustomTextField(
                controller: cubit.receiverAddressController,
                hintText: 'العنوان',
                errorMsg: 'العنوان مطلوب',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                prefixIcon: CupertinoIcons.chevron_down_circle,
                onTap: () {
                  CustomBottomSheet.show(
                    context,
                    hasHeight: true,
                    children: mapProvider.address
                            ?.map(
                              (e) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.pop(context);
                                  cubit.changeRecieverAddress(e);
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
                controller: cubit.receiverDateTimeController,
                hintText: 'تاريخ استلام الشحنة',
                errorMsg: 'تاريخ استلام الشحنة مطلوب',
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.done,
                suffixIcon: Icons.touch_app_rounded,
                onTap: () async {
                  TimeOfDay? tod;
                  DateTime? dt;
                  dt = await showDatePicker(
                    context: navigator.currentContext!,
                    initialDate: cubit.receiverDateTime != null
                        ? DateTime.parse(cubit.receiverDateTime!)
                        : DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          dialogTheme: DialogTheme(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0))),
                          colorScheme: const ColorScheme.light(
                            primary: weevoPrimaryOrangeColor,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: weevoPrimaryOrangeColor,
                          ),
                          dialogBackgroundColor: Colors.white,
                        ),
                        child: child ?? Container(),
                      );
                    },
                  );
                  if (dt != null) {
                    tod = await showTimePicker(
                      context: navigator.currentContext!,
                      initialTime: cubit.receiverDateTime != null
                          ? TimeOfDay.fromDateTime(
                              DateTime.parse(cubit.receiverDateTime!))
                          : TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            timePickerTheme: TimePickerThemeData(
                              dialBackgroundColor: weevoOrangeLighter,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  25.0,
                                ),
                              ),
                            ),
                            colorScheme: const ColorScheme.light(
                              primary: weevoPrimaryOrangeColor,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: weevoPrimaryOrangeColor,
                            ),
                            dialogBackgroundColor: Colors.white,
                          ),
                          child: child ?? Container(),
                        );
                      },
                    );
                  }
                  if (dt != null && tod != null) {
                    final dateTime = DateTime(
                        dt.year, dt.month, dt.day, tod.hour, tod.minute);
                    cubit.changeRecieverDateTime(dateTime.toIso8601String());
                    cubit.receiverDateTimeController.text =
                        intl.DateFormat('hh:mm a - E dd MMM y', 'ar-EG')
                            .format(dateTime);
                  }
                },
                readOnly: true,
                prefixIcon: Icons.access_time_sharp,
              ),
            ],
          ),
        );
      },
    );
  }
}
