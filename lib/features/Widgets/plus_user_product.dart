import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/product_provider.dart';
import 'headline_text.dart';
import 'home_page_view.dart';
import 'slide_dotes.dart';

class PlusUserProducts extends StatefulWidget {
  final Size size;

  const PlusUserProducts({
    super.key,
    required this.size,
  });

  @override
  State<PlusUserProducts> createState() => _PlusUserProductsState();
}

class _PlusUserProductsState extends State<PlusUserProducts> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              productProvider.products.length > 1
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          productProvider.products.length,
                          (index) => _currentIndex == index
                              ? CategoryDotes(
                                  isActive: true,
                                  isPlus: true,
                                )
                              : CategoryDotes(
                                  isActive: false,
                                  isPlus: true,
                                ),
                        ),
                      ),
                    )
                  : Container(),
              const HeadLineText(
                title: 'احدث المنتجات',
              ),
            ],
          ),
        ),
        const HomePageView(),
      ],
    );
  }
}
