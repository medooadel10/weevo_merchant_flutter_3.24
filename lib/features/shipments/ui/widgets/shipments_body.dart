import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../logic/cubit/shipments_cubit.dart';
import 'shipment_filter_list_bloc_builder.dart';
import 'shipments_list_bloc_builder.dart';

class ShipmentsBody extends StatefulWidget {
  const ShipmentsBody({super.key});

  @override
  State<ShipmentsBody> createState() => _ShipmentsBodyState();
}

class _ShipmentsBodyState extends State<ShipmentsBody> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_addListener);
  }

  void _addListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      context.read<ShipmentsCubit>().getShipments(isPaging: true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_addListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<ShipmentsCubit>().getShipments();
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 160.h,
              excludeHeaderSemantics: true,
              leading: null,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background:
                    const ShipmentFilterListBlocBuilder().paddingSymmetric(
                  horizontal: 10.w,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: const ShipmentsListBlocBuilder().paddingSymmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
