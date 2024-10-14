import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_loading_indicator.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/shipment_details_model.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/ui/widgets/shipment_details_header.dart';

import '../../../../core_new/data/models/shipment_status/base_shipment_status.dart';
import '../../../../core_new/helpers/spacing.dart';
import 'shipment_details_app_bar.dart';
import 'shipment_details_buttons.dart';
import 'shipment_details_info.dart';
import 'shipment_details_locations.dart';

class ShipmentDetailsBody extends StatelessWidget {
  final int? id;
  const ShipmentDetailsBody({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
        ShipmentDetailsModel? shipmentDetails = cubit.shipmentDetails;

        return Column(
          children: [
            ShipmentDetailsAppBar(
              id: id,
            ),
            if (shipmentDetails == null)
              const Expanded(
                child: Center(
                  child: CustomLoadingIndicator(),
                ),
              ),
            if (shipmentDetails != null)
              Expanded(
                child: Container(
                  color: Colors.grey[50],
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
                    vertical: 10.0.h,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await cubit.getShipmentDetails(shipmentDetails.id);
                            return Future.value();
                          },
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: BaseShipmentStatus
                                    .shipmentStatusMap[shipmentDetails.status]!
                                    .buildShipmentDetailsCourierHeader(context),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    ShipmentDetailsHeader(
                                      image: shipmentDetails
                                          .products[cubit.currentProductIndex]
                                          .productInfo
                                          .image,
                                    ),
                                    verticalSpace(10),
                                    ShipmentDetailsInfo(
                                      shipmentDetails: shipmentDetails,
                                    ),
                                    verticalSpace(16),
                                    ShipmentDetailsLocations(
                                      shipmentModel: shipmentDetails,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      verticalSpace(10),
                      const ShipmentDetailsButtons(),
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
