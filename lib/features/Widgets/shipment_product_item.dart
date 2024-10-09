import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Models/shipment_product.dart';
import '../../core/Providers/product_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core_new/widgets/custom_image.dart';

class ShipmentProductItem extends StatelessWidget {
  final ShipmentProduct product;

  const ShipmentProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: Colors.grey.withOpacity(0.1),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
                child: CustomImage(
                  imageUrl: product.productInfo!.image,
                  height: 150.0.h,
                  width: size.width,
                ),
              ),
              Container(
                height: 30.0.h,
                width: 70.0.h,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    )),
                child: Center(
                  child: Text('QTY: X${product.qty}'),
                ),
              )
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.productInfo!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                            6.0,
                          ),
                          decoration: BoxDecoration(
                            color: weevoPrimaryOrangeColor,
                            borderRadius: BorderRadius.circular(
                              20.0.r,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/smallshirt.png',
                            width: 10.0.w,
                            height: 10.0.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          '${productProvider.getCatById(product.productInfo!.categoryId!)!.name}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  product.productInfo!.description!,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10.0,
                                    spreadRadius: 0.0,
                                    color: Colors.grey.withOpacity(0.2),
                                  )
                                ]),
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.all(4.0),
                            height: 30.h,
                            width: 30.w,
                            child: Image.asset(
                              'assets/images/weevo_money.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            '${product.price}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                          const Text(
                            'جنيه',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10.0,
                                    spreadRadius: 0.0,
                                    color: Colors.grey.withOpacity(0.2),
                                  )
                                ]),
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.all(4.0),
                            width: 30.w,
                            height: 30.h,
                            child: Image.asset(
                              'assets/images/weevo_weight.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${double.parse(product.productInfo!.weight!).toInt()}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'كيلو',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
