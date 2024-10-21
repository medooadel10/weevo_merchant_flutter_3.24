import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/features/add_product/logic/cubit/add_product_cubit.dart';
import 'package:weevo_merchant_upgrade/features/add_product/ui/widgets/add_product_body.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة منتج'),
        ),
        body: const AddProductBody(),
      ),
    );
  }
}
