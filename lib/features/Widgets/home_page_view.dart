import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/product_provider.dart';
import 'product_item.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final PageController _pageController =
      PageController(initialPage: 1, viewportFraction: 0.6);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return Column(
      children: [
        SizedBox(
          height: 280.h,
          child: PageView.builder(
            onPageChanged: (int i) {},
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemCount: productProvider.last5Products.length,
            itemBuilder: (context, i) => ProductItem(
              product: productProvider.last5Products[i],
              isEditable: false,
            ),
          ),
        ),
      ],
    );
  }
}
