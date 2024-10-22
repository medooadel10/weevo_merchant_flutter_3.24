import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../../../core/Models/pivot.dart';
import '../../../../core/Models/product_model.dart';
import '../../../../core/Providers/add_shipment_provider.dart';
import '../../../../core/Utilits/constants.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../Screens/add_shipment.dart';

class ProductCharge extends StatelessWidget {
  final ProductModel product;
  const ProductCharge({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final addShipmentProvider = context.read<AddShipmentProvider>();
    return WeevoButton(
      onTap: () {
        addShipmentProvider.addShipmentProduct(
          Product(
            id: product.id,
            name: product.name,
            image: product.image,
            description: product.description,
            price: product.price,
            height: product.height,
            width: product.width,
            length: product.length,
            weight: product.weight,
            merchantId: product.merchantId,
            categoryId: product.categoryId,
            productCategory: ProductCategory(
              id: product.category.id,
              name: product.category.name,
              image: product.category.image,
            ),
            quantity: 1,
            pivot: Pivot(
              productId: product.id,
            ),
          ),
        );
        addShipmentProvider.setShipmentFromWhere(oneShipment);
        Navigator.pushNamed(context, AddShipment.id);
      },
      color: const Color(0xFFD8F3FF),
      isStable: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/new_icon.png',
            color: weevoPrimaryBlueColor,
            height: 25.h,
            width: 25.w,
          ),
          horizontalSpace(5),
          Text(
            'اشحن',
            style: TextStyle(
              fontSize: 12.0.sp,
              color: weevoPrimaryBlueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
