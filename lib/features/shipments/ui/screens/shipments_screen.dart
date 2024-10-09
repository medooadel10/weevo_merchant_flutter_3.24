import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../core_new/di/dependency_injection.dart';
import '../../logic/cubit/shipments_cubit.dart';
import '../widgets/shipments_body.dart';

class ShipmentsScreen extends StatefulWidget {
  final int filterIndex;
  const ShipmentsScreen({super.key, this.filterIndex = 0});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShipmentsCubit(getIt())
        ..filterAndGetShipments(widget.filterIndex, isForcedGetData: true),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'حالة الشحنات',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              MagicRouter.pop();
            },
          ),
        ),
        body: const ShipmentsBody(),
      ),
    );
  }
}
