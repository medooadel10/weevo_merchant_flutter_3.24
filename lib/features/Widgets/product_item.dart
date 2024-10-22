import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/features/product_details/ui/product_details_screen.dart';

import '../../core/Models/product_model.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core_new/networking/api_constants.dart';
import '../../core_new/router/router.dart';
import '../../core_new/widgets/custom_image.dart';
import '../Screens/add_shipment.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final bool isEditable;
  final VoidCallback? onMorePressed;

  const ProductItem({
    super.key,
    required this.product,
    required this.isEditable,
    this.onMorePressed,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late AddShipmentProvider _addShipmentProvider;

  @override
  void initState() {
    super.initState();
    _addShipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final AddShipmentProvider shipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    log('${widget.product.image}');
    log('${widget.product.name}');
    return GestureDetector(
      onTap: () {
        MagicRouter.navigateTo(ProductDetailsScreen(
          productId: widget.product.id!,
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CustomImage(
                        imageUrl: widget.product.image,
                        height: 110.0.h,
                        width: size.width,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/weevo_money.png',
                                fit: BoxFit.contain,
                                height: 20.h,
                                width: 20.w,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '${widget.product.price}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                'جنيه',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/weevo_weight.png',
                                fit: BoxFit.contain,
                                width: 20.w,
                                height: 20.h,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${double.parse(widget.product.weight!).toInt()}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                'كيلو',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              widget.isEditable
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: widget.onMorePressed,
                        child: Container(
                          padding: const EdgeInsets.all(
                            2.0,
                          ),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFD8F3FF)),
                          child: const Icon(
                            Icons.more_horiz,
                            color: weevoPrimaryBlueColor,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            widget.product.description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          CustomImage(
                            imageUrl:
                                '${ApiConstants.baseUrl}${widget.product.productCategory!.image}',
                            width: 25.0.w,
                            height: 25.0.h,
                          ),
                          Text(
                            '${widget.product.productCategory!.name}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextButton.icon(
                  icon: Image.asset(
                    'assets/images/product_shipment.png',
                    width: 30.0.w,
                    height: 30.0.h,
                    color: weevoPrimaryBlueColor,
                  ),
                  label: Text(
                    'اشحن',
                    style: TextStyle(
                      color: weevoPrimaryBlueColor,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    _addShipmentProvider.addShipmentProduct(
                      widget.product,
                    );
                    shipmentProvider.setShipmentFromWhere(oneShipment);
                    Navigator.pushNamed(context, AddShipment.id);
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFFD8F3FF)),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 6.0)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
