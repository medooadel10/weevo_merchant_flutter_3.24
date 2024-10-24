import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weevo_merchant_upgrade/core/Providers/add_shipment_provider.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_bottom_sheet.dart';
import 'package:weevo_merchant_upgrade/features/add_shipment/ui/widgets/cities_bottom_sheet.dart';

import '../../../../../core/Dialogs/action_dialog.dart';
import '../../../../../core/Models/address_fill.dart';
import '../../../../../core/Storage/shared_preference.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../../core/router/router.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/widgets/custom_text_field.dart';
import '../../../../waslny/ui/screens/wasully_map_screen.dart';
import '../../../logic/add_shipment_cubit.dart';

class AddShipmentSecondBody extends StatelessWidget {
  const AddShipmentSecondBody({super.key});

  @override
  Widget build(BuildContext context) {
    AddShipmentProvider addShipmentProvider =
        context.read<AddShipmentProvider>();
    final cubit = context.read<AddShipmentCubit>();
    return BlocBuilder<AddShipmentCubit, AddShipmentState>(
      builder: (context, state) {
        return Form(
          key: cubit.formKeySecond,
          child: Column(
            children: [
              CustomTextField(
                controller: cubit.stateController,
                hintText: 'المحافظة',
                errorMsg: 'المحافظة مطلوب',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.place,
                onTap: () {
                  CustomBottomSheet.show(
                    context,
                    title: 'إختر المحافظة',
                    items: addShipmentProvider.states
                        .map(
                          (e) => BottomSheetItem(
                            title: e.name ?? '',
                            onTap: () {
                              cubit.changeState(e);
                            },
                          ),
                        )
                        .toList(),
                  );
                },
                readOnly: true,
                suffixIcon: CupertinoIcons.chevron_down_circle,
              ),
              verticalSpace(16),
              CustomTextField(
                controller: cubit.cityController,
                hintText: 'المنطقة',
                errorMsg: 'المنطقة مطلوب',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.place,
                onTap: () {
                  if (cubit.currentState == null) {
                    showDialog(
                        context: navigator.currentContext!,
                        builder: (ctx) => ActionDialog(
                              content: 'عليك اختيار المحافظة اولاً',
                              approveAction: 'حسناً',
                              onApproveClick: () {
                                Navigator.pop(ctx);
                              },
                            ));
                    return;
                  }
                  showBottomSheet(
                    context: context,
                    builder: (context) {
                      return BlocProvider.value(
                        value: cubit,
                        child: CitiesBottomSheet(
                          cities: addShipmentProvider.states
                              .singleWhere(
                                  (e) => e.id == cubit.currentState?.id)
                              .cities,
                        ),
                      );
                    },
                  );
                  // CustomBottomSheet.show(
                  //   context,
                  //   title: 'إختر المنطقة',
                  //   hasHeight: true,
                  //   items: addShipmentProvider.states
                  //       .singleWhere((e) => e.id == cubit.currentState?.id)
                  //       .cities
                  //       ?.map(
                  //         (e) => BottomSheetItem(
                  //           title: e.name ?? '',
                  //           onTap: () {
                  //             cubit.changeCity(e);
                  //           },
                  //         ),
                  //       )
                  //       .toList(),
                  // );
                },
                readOnly: true,
                suffixIcon: CupertinoIcons.chevron_down_circle,
              ),
              verticalSpace(16),
              CustomTextField(
                controller: cubit.fullDeliveryAddressController,
                hintText: 'موقع التسليم بالتفصيل',
                errorMsg: 'موقع التسليم بالتفصيل مطلوب',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.place,
                onTap: () {},
              ),
              verticalSpace(16),
              CustomTextField(
                controller: cubit.deliveyAdressController,
                hintText: 'موقع التسليم بالخريطة',
                errorMsg: 'موقع التسليم بالخريطة مطلوب',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.place,
                onTap: () {
                  MagicRouter.navigateTo(WasullyMapScreen(
                          location: cubit.deliveryAddressFill != null
                              ? LatLng(cubit.deliveryAddressFill!.lat,
                                  cubit.deliveryAddressFill!.long)
                              : null))
                      .then(
                    (value) {
                      if (value is AddressFill) {
                        cubit.changeDeliveryAddressFill(value);
                      }
                    },
                  );
                },
                readOnly: true,
                suffixIcon: Icons.touch_app_rounded,
              ),
              verticalSpace(16),
              CustomTextField(
                controller: cubit.deliveryDateTimeController,
                hintText: 'تاريخ تسليم الشحنة',
                errorMsg: 'تاريخ تسليم الشحنة مطلوب',
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                suffixIcon: Icons.touch_app_rounded,
                onTap: () async {
                  TimeOfDay? tod;
                  DateTime? dt;
                  dt = await showDatePicker(
                    context: navigator.currentContext!,
                    initialDate: cubit.deliveryDateTime != null
                        ? DateTime.parse(cubit.deliveryDateTime!)
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
                      initialTime: cubit.deliveryDateTime != null
                          ? TimeOfDay.fromDateTime(
                              DateTime.parse(cubit.deliveryDateTime!))
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
                    cubit.changeDeliveryDateTime(dateTime);
                  }
                },
                readOnly: true,
                prefixIcon: Icons.access_time_sharp,
              ),
              verticalSpace(16),
              CustomTextField(
                controller: cubit.clientNameController,
                hintText: 'إسم العميل',
                errorMsg: 'إسم العميل مطلوب',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onTap: () {},
                prefixIcon: Icons.person,
              ),
              verticalSpace(16),
              CustomTextField(
                controller: cubit.clientPhoneController,
                hintText: 'رقم هاتف العميل',
                errorMsg: 'إسم العميل مطلوب',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onTap: () {},
                prefixIcon: Icons.phone,
                maxLength: 11,
              ),
              verticalSpace(16),
              CustomTextField(
                controller: cubit.notesController,
                hintText: 'تفاصيل أخرى',
                errorMsg: '',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onTap: () {},
                prefixIcon: Icons.notes,
              ),
            ],
          ),
        );
      },
    );
  }
}
