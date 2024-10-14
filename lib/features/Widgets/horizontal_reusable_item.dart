import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Models/product_model.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/product_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core_new/router/router.dart';
import '../../core_new/widgets/custom_image.dart';
import 'product_price_edit.dart';
import 'product_quantity_edit.dart';

class HorizontalReusableItem extends StatefulWidget {
  final Product product;

  const HorizontalReusableItem({
    super.key,
    required this.product,
  });

  @override
  State<HorizontalReusableItem> createState() => _HorizontalReusableItemState();
}

class _HorizontalReusableItemState extends State<HorizontalReusableItem> {
  bool isChecked = false;
  late AddShipmentProvider _shipmentProvider;

  @override
  void initState() {
    super.initState();
    _shipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    isChecked = _shipmentProvider.isChosen(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return GestureDetector(
      onTap: () {
        if (shipmentProvider.isChosen(widget.product)) {
          shipmentProvider.removeShipmentProduct(widget.product);
        } else {
          shipmentProvider.addShipmentProduct(widget.product);
        }
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ],
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 6.0,
                            right: 6.0,
                            bottom: 6.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(
                                            6.0,
                                          ),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: weevoPrimaryOrangeColor,
                                          ),
                                          child: Image.asset(
                                            'assets/images/smallshirt.png',
                                            width: 10.0.w,
                                            height: 10.0.h,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '${productProvider.getCatById(widget.product.categoryId ?? 0)!.name}',
                                          style: TextStyle(
                                            fontSize: 9.0.sp,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          widget.product.name ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                          strutStyle: const StrutStyle(
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.0.h,
                                        ),
                                        Text(
                                          widget.product.description ?? '',
                                          maxLines: 1,
                                          textAlign: TextAlign.end,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8.0.r,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (isChecked) {
                                          showDialog(
                                            context: navigator.currentContext!,
                                            builder: (context) =>
                                                ProductPriceEdit(
                                              price: widget.product.price
                                                      ?.toDouble() ??
                                                  0.0,
                                              onDone: (String s) {
                                                shipmentProvider
                                                    .updateShipmentProduct(
                                                  Product(
                                                    id: widget.product.id,
                                                    name: widget.product.name,
                                                    categoryId: widget
                                                        .product.categoryId,
                                                    height:
                                                        widget.product.height,
                                                    description: widget
                                                        .product.description,
                                                    width: widget.product.width,
                                                    weight:
                                                        widget.product.weight,
                                                    length:
                                                        widget.product.length,
                                                    merchantId: widget
                                                        .product.merchantId,
                                                    image: widget.product.image,
                                                    price: double.parse(s),
                                                    quantity:
                                                        widget.product.quantity,
                                                  ),
                                                );
                                                // setPrice to update total price;
                                                shipmentProvider.setPrice();
                                                MagicRouter.pop();
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'تعديل',
                                        style: TextStyle(
                                          color: Color(0xFF0062DD),
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'جنية',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10.0.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          '${widget.product.price}',
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'السعر',
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Container(
                                padding: const EdgeInsets.all(
                                  6.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8.0.r,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (isChecked) {
                                                if (widget.product.quantity! >
                                                    1) {
                                                  shipmentProvider
                                                      .updateShipmentProduct(
                                                    Product(
                                                      id: widget.product.id,
                                                      name: widget.product.name,
                                                      categoryId: widget
                                                          .product.categoryId,
                                                      height:
                                                          widget.product.height,
                                                      description: widget
                                                          .product.description,
                                                      width:
                                                          widget.product.width,
                                                      weight:
                                                          widget.product.weight,
                                                      length:
                                                          widget.product.length,
                                                      merchantId: widget
                                                          .product.merchantId,
                                                      image:
                                                          widget.product.image,
                                                      price:
                                                          widget.product.price,
                                                      quantity: widget.product
                                                              .quantity! -
                                                          1,
                                                    ),
                                                  );
                                                  shipmentProvider.setPrice();
                                                }
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 1.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff0062DD))),
                                              child: const Icon(
                                                Icons.remove,
                                                color: Color(0xff0062DD),
                                                size: 18.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isChecked) {
                                                  showDialog(
                                                    context: navigator
                                                        .currentContext!,
                                                    builder: (context) =>
                                                        ProductQuantityEdit(
                                                      quantity: widget
                                                          .product.quantity!,
                                                      onDone: (String s) {
                                                        shipmentProvider
                                                            .updateShipmentProduct(
                                                          Product(
                                                            id: widget
                                                                .product.id,
                                                            name: widget
                                                                .product.name,
                                                            categoryId: widget
                                                                .product
                                                                .categoryId,
                                                            height: widget
                                                                .product.height,
                                                            description: widget
                                                                .product
                                                                .description,
                                                            width: widget
                                                                .product.width,
                                                            weight: widget
                                                                .product.weight,
                                                            length: widget
                                                                .product.length,
                                                            merchantId: widget
                                                                .product
                                                                .merchantId,
                                                            image: widget
                                                                .product.image,
                                                            price: widget
                                                                .product.price,
                                                            quantity:
                                                                int.parse(s),
                                                          ),
                                                        );
                                                        shipmentProvider
                                                            .setPrice();
                                                        MagicRouter.pop();
                                                      },
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xff99A5B2),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0.r),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Text(
                                                  '${widget.product.quantity}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.0.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (isChecked) {
                                                shipmentProvider
                                                    .updateShipmentProduct(
                                                  Product(
                                                    id: widget.product.id,
                                                    name: widget.product.name,
                                                    categoryId: widget
                                                        .product.categoryId,
                                                    height:
                                                        widget.product.height,
                                                    description: widget
                                                        .product.description,
                                                    width: widget.product.width,
                                                    weight:
                                                        widget.product.weight,
                                                    length:
                                                        widget.product.length,
                                                    merchantId: widget
                                                        .product.merchantId,
                                                    image: widget.product.image,
                                                    price: widget.product.price,
                                                    quantity: widget
                                                            .product.quantity! +
                                                        1,
                                                  ),
                                                );
                                                shipmentProvider.setPrice();
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 1.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff0062DD))),
                                              child: const Icon(
                                                Icons.add,
                                                color: Color(0xff0062DD),
                                                size: 18.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'الكمية',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8.0.r,
                                  ),
                                  color: const Color(0xffD8F3FF),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'جنية',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0.sp,
                                      ),
                                    ),
                                    Text(
                                      '${widget.product.price! * widget.product.quantity!}',
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'الكلي',
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        child: CustomImage(
                          imageUrl: widget.product.image,
                          width: 150.0.w,
                          height: 150.0.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          isChecked
              ? Positioned(
                  top: 5.0,
                  left: 5.0,
                  child: Container(
                    height: 20.0.h,
                    width: 20.0.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.0.r,
                      ),
                      color: weevoWhiteGreen,
                    ),
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
