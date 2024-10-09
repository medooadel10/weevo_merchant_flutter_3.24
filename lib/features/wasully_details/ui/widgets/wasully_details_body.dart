import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../data/models/shipment_status/base_shipment_status.dart';
import '../../data/models/wasully_model.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';
import 'wasully_details_app_bar.dart';
import 'wasully_details_buttons.dart';
import 'wasully_details_image.dart';
import 'wasully_details_info.dart';
import 'wasully_details_locations.dart';

class WasullyDetailsBody extends StatelessWidget {
  final int? id;
  const WasullyDetailsBody({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
        WasullyModel? wasullyModel = cubit.wasullyModel;
        if (wasullyModel == null) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }
        return Column(
          children: [
            WasullyDetailsAppBar(
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
                          await cubit.getWassullyDetails(wasullyModel.id);
                          return Future.value();
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: BaseShipmentStatus
                                  .shipmentStatusMap[wasullyModel.status]!
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
                                background: WasullyDetailsImage(
                                  image: wasullyModel.image,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  verticalSpace(10),
                                  WasullyDetailsInfo(
                                    wasullyModel: wasullyModel,
                                  ),
                                  verticalSpace(16),
                                  WasullyDetailsLocations(
                                    wasullyModel: wasullyModel,
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
