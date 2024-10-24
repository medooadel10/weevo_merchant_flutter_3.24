import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_text_field.dart';

import '../../../../core/Models/city.dart';
import '../../../../core/Models/state.dart';
import '../../logic/add_shipment_cubit.dart';

class CitiesBottomSheet extends StatefulWidget {
  final List<States>? states;
  final List<Cities>? cities;
  const CitiesBottomSheet({super.key, this.states, this.cities});

  @override
  State<CitiesBottomSheet> createState() => _CitiesBottomSheetState();
}

class _CitiesBottomSheetState extends State<CitiesBottomSheet> {
  List<Cities>? _filteredCities;
  final searchController = TextEditingController();
  late AddShipmentCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<AddShipmentCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر المنطقة',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalSpace(14),
        CustomTextField(
          controller: searchController,
          hintText: 'إبحث',
          errorMsg: '',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onChange: (value) {
            setState(() {
              _filteredCities = widget.cities
                  ?.where((city) =>
                      city.name
                          ?.toLowerCase()
                          .contains(value?.toLowerCase() ?? '') ??
                      false)
                  .toList();
            });
          },
        ),
        verticalSpace(14),
        Expanded(
          child: _buildListView(),
        ),
      ],
    ).paddingSymmetric(
      horizontal: 20.w,
      vertical: 10.h,
    );
  }

  Widget _buildListView() => ListView.separated(
        shrinkWrap: true,
        itemCount: _filteredCities?.length ?? widget.cities?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              cubit
                  .changeCity(_filteredCities?[index] ?? widget.cities![index]);
              Navigator.pop(context, widget.cities?[index]);
            },
            child: ListTile(
              title: Text(
                _filteredCities?[index].name ??
                    widget.cities?[index].name ??
                    '',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[400],
        ),
      );
}
