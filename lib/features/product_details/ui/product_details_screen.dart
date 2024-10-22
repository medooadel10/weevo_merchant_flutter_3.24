import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core_new/di/dependency_injection.dart';
import 'package:weevo_merchant_upgrade/features/product_details/logic/cubit/product_details_cubit.dart';

import 'widgets/product_details_body.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductDetailsCubit(getIt())..getProductDetails(productId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('منتج رقم $productId'),
        ),
        body: const ProductDetailsBody(),
      ),
    );
  }
}
