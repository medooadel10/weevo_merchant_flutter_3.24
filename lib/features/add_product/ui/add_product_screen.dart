import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/features/add_product/ui/widgets/add_product_body.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منتج'),
      ),
      body: const AddProductBody(),
    );
  }
}
