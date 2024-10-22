import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/products/ui/widgets/products_bloc_builder.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../add_product/ui/add_product_screen.dart';
import '../../data/models/products_response_body_model.dart';
import '../../logic/cubit/products_cubit.dart';
import 'products_header.dart';

class ProductsScrollView extends StatefulWidget {
  const ProductsScrollView({super.key});

  @override
  State<ProductsScrollView> createState() => _ProductsScrollViewState();
}

class _ProductsScrollViewState extends State<ProductsScrollView> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_addListener);
  }

  void _addListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<ProductsCubit>().getProducts(isPaging: true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_addListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => context.read<ProductsCubit>().getProducts(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: const ProductsHeader(),
                toolbarHeight: 48.h,
              ),
              const SliverToBoxAdapter(
                child: ProductsBlocBuilder(),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30.h,
          right: 20.w,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductScreen(),
                  )).then((value) async {
                if (value is ProductModel) {
                  if (context.mounted) {
                    context.read<ProductsCubit>().getProducts();
                  }
                }
              });
            },
            backgroundColor: weevoPrimaryBlueColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
