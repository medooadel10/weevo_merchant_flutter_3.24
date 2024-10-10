import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/shipment_details_model.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/ui/widgets/shipment_details_image.dart';

import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../wasully_details/data/models/shipment_status/base_shipment_status.dart';
import 'shipment_details_app_bar.dart';
import 'shipment_details_info.dart';
import 'shipment_details_locations.dart';
import 'wasully_details_buttons.dart';

class WasullyDetailsBody extends StatelessWidget {
  final int? id;
  const WasullyDetailsBody({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
        ShipmentDetailsModel? shipmentDetails = cubit.shipmentDetails;
        if (shipmentDetails == null) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }
        return Column(
          children: [
            ShipmentDetailsAppBar(
              id: id,
            ),
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
                            SliverAppBar(
                              pinned: false,
                              floating: true,
                              snap: true,
                              leading: null,
                              automaticallyImplyLeading: false,
                              expandedHeight: 200.h,
                              backgroundColor: Colors.transparent,
                              flexibleSpace: FlexibleSpaceBar(
                                background: ShipmentDetailsImage(
                                  image: shipmentDetails
                                      .products[cubit.currentProductIndex]
                                      .productInfo
                                      .image,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
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
                    const WasullyDetailsButtons(),
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
