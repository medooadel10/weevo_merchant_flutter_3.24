import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/logic/cubit/bulk_shipment_cubit.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/ui/widgets/bulk_shipment_details_body.dart';

class BulkShipmentDetailsScreen extends StatefulWidget {
  final int shipmentId;
  const BulkShipmentDetailsScreen({super.key, required this.shipmentId});

  @override
  State<BulkShipmentDetailsScreen> createState() =>
      _BulkShipmentDetailsScreenState();
}

class _BulkShipmentDetailsScreenState extends State<BulkShipmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BulkShipmentCubit>().getBulkShipmentDetails(widget.shipmentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulkShipmentCubit, BulkShipmentState>(
      builder: (context, state) {
        log('Status : ${context.read<BulkShipmentCubit>().bulkShipmentModel?.status}');
        return Scaffold(
          backgroundColor: Colors.white,
          body: BulkShipmentDetailsBody(
            id: widget.shipmentId,
          ),
        );
      },
    );
  }
}
