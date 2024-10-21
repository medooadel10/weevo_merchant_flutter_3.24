import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core_new/data/models/shipment_status/base_shipment_status.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_shimmer.dart';
import '../../logic/cubit/shipments_cubit.dart';

class ShipmentFilterItem extends StatelessWidget {
  final BaseShipmentStatus data;
  final bool isSelected;
  final bool isLoading;
  const ShipmentFilterItem({
    required this.data,
    required this.isSelected,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShipmentsCubit>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.w,
        vertical: 8.0.h,
      ),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.grey[200],
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            data.image,
            height: 20.h,
            width: 20.w,
            color: isSelected ? Colors.white : const Color(0xff575757),
          ),
          horizontalSpace(6),
          Text(
            data.statusAr,
            style: TextStyle(
              fontSize: 10.0.sp,
              color: isSelected ? Colors.white : const Color(0xff575757),
            ),
          ),
          horizontalSpace(6),
          Visibility(
            visible: isSelected,
            child: Container(
              width: 16.0.w,
              height: 16.0.h,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? const CustomShimmer()
                  : Center(
                      child: Text(
                        '${cubit.responseBody?.total}',
                        style: TextStyle(
                          fontSize: 10.0.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
