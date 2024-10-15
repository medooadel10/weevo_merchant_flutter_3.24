import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/data/models/bulk_shipment_status/base_bulk_shipment_status.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_loading_indicator.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/logic/cubit/bulk_shipment_cubit.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/ui/widgets/bulk_shipments_list_view.dart';

import 'bulk_shipment_details_app_bar.dart';

class BulkShipmentDetailsBody extends StatelessWidget {
  final int id;
  const BulkShipmentDetailsBody({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulkShipmentCubit, BulkShipmentState>(
      builder: (context, state) {
        final cubit = context.read<BulkShipmentCubit>();
        final data = cubit.bulkShipmentModel;
        return Column(
          children: [
            BulkShipmentDetailsAppBar(id: id),
            if (data == null)
              const Expanded(
                child: Center(
                  child: CustomLoadingIndicator(),
                ),
              ),
            if (data != null)
              Expanded(
                child: Container(
                  color: Colors.grey[50],
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () => cubit.getBulkShipmentDetails(data.id),
                    child: Column(
                      children: [
                        if (cubit.bulkShipmentModel != null)
                          const Expanded(
                            child: BulkShipmentsListView(),
                          ),
                        verticalSpace(10),
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: BaseBulkShipmentStatus
                                      .statuses[cubit.bulkShipmentModel!.status]
                                      ?.buildShipmentDetailsButtons(context) ??
                                  Container(),
                            ),
                            verticalSpace(10),
                            SizedBox(
                              width: double.infinity,
                              child: WeevoButton(
                                  onTap: null,
                                  color: Colors.black,
                                  isStable: false,
                                  title:
                                      'التكلفة الكلية للتوصيل ${data.agreedShippingCostAfterDiscount?.toStringAsFixed0() ?? data.agreedShippingCost?.toStringAsFixed0() ?? data.expectedShippingCost?.toStringAsFixed0()} جنية'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
