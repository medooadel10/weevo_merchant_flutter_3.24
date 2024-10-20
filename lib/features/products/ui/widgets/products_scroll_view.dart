import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/products/ui/widgets/products_bloc_builder.dart';

import 'products_header.dart';

class ProductsScrollView extends StatelessWidget {
  const ProductsScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
    );
  }
}
