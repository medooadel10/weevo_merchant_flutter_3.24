import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core_new/di/dependency_injection.dart';
import 'package:weevo_merchant_upgrade/features/add_product/logic/cubit/add_product_cubit.dart';
import 'package:weevo_merchant_upgrade/features/add_product/ui/widgets/add_product_body.dart';

import '../../products/data/models/products_response_body_model.dart';

class AddProductScreen extends StatelessWidget {
  final ProductModel? product;
  final bool isDuplicate;
  const AddProductScreen({
    super.key,
    this.product,
    this.isDuplicate = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductCubit(getIt())..init(product, isDuplicate),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة منتج'),
        ),
        body: const AddProductBody(),
      ),
    );
  }
}
