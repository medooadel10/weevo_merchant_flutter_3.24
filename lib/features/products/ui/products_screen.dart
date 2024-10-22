import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core_new/di/dependency_injection.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/features/products/logic/cubit/products_cubit.dart';
import 'package:weevo_merchant_upgrade/features/products/ui/widgets/products_scroll_view.dart';
import 'package:weevo_merchant_upgrade/features/products/ui/widgets/products_search.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(getIt())..getProducts(),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Row(
            children: [
              const Text('المنتجات'),
              horizontalSpace(10),
              const Expanded(
                child: ProductsSearch(),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            context.unfocus();
          },
          child: const ProductsScrollView(),
        ),
      ),
    );
  }
}
