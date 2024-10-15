import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/logic/cubit/bulk_shipment_cubit.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/ui/widgets/bulk_child_shpiment_tile.dart';

class BulkShipmentsListView extends StatelessWidget {
  const BulkShipmentsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulkShipmentCubit, BulkShipmentState>(
      builder: (context, state) {
        final cubit = context.read<BulkShipmentCubit>();
        final data = cubit.bulkShipmentModel;
        return ListView.separated(
          itemBuilder: (context, index) {
            return BulkChildShpimentTile(
              child: data!.children![index],
            );
          },
          itemCount: data?.children?.length ?? 0,
          separatorBuilder: (context, index) {
            return verticalSpace(10);
          },
        );
      },
    );
  }
}
