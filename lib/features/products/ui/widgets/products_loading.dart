import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/features/products/ui/widgets/product_item_loading.dart';

class ProductsLoading extends StatelessWidget {
  final int length;
  const ProductsLoading({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10.0.h,
      ),
      child: Wrap(
        spacing: 10.0.w,
        runSpacing: 10.0.h,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        children: List.generate(
          length,
          (index) => Container(
            width: context.width * 0.45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const ProductItemLoading(),
          ),
        ),
      ),
    );
  }
}
