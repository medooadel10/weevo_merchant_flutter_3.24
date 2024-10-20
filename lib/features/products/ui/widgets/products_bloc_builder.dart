import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/features/products/logic/cubit/products_cubit.dart';
import 'package:weevo_merchant_upgrade/features/products/ui/widgets/products_grid.dart';
import 'package:weevo_merchant_upgrade/features/products/ui/widgets/products_loading.dart';

class ProductsBlocBuilder extends StatelessWidget {
  const ProductsBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (previous, current) =>
          current is Loading ||
          current is Success ||
          current is Failure ||
          current is PagingLoading,
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const ProductsLoading(
            length: 6,
          ),
          success: (data) => ProductsGrid(
            products: data,
          ),
          pagingLoading: (data) => Column(
            children: [
              ProductsGrid(products: data),
              verticalSpace(10),
              const ProductsLoading(
                length: 4,
              ),
            ],
          ),
          failure: (message) => const ProductsLoading(
            length: 6,
          ),
          orElse: () => Container(),
        );
      },
    );
  }
}
