import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/router/router.dart';
import '../../logic/cubit/bulk_shipment_cubit.dart';
import 'bulk_shipment_details_app_bar_title.dart';

class BulkShipmentDetailsAppBar extends StatelessWidget {
  final int? id;
  const BulkShipmentDetailsAppBar({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BulkShipmentCubit>();
    return BlocBuilder<BulkShipmentCubit, BulkShipmentState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: weevoPrimaryOrangeColor,
                onPressed: () {
                  MagicRouter.pop(data: cubit.bulkShipmentModel);
                },
              ),
              Expanded(
                child: BulkShipmentDetailsAppBarTitle(
                  id: id,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
