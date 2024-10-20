import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core/router/router.dart';
import 'package:weevo_merchant_upgrade/core_new/di/dependency_injection.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_text_field.dart';
import 'package:weevo_merchant_upgrade/features/add_product/ui/add_product_screen.dart';
import 'package:weevo_merchant_upgrade/features/products/logic/cubit/products_cubit.dart';
import 'package:weevo_merchant_upgrade/features/products/ui/widgets/products_scroll_view.dart';

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
              Expanded(
                child: CustomTextField(
                  controller: TextEditingController(),
                  hintText: 'ابحث بإسم المنتج',
                  errorMsg: '',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  suffixIcon: Icons.search,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            MagicRouter.navigateTo(const AddProductScreen());
          },
          backgroundColor: weevoPrimaryBlueColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
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
