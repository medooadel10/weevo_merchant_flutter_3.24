import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Models/add_product_arg.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/product_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core_new/networking/api_constants.dart';
import '../../core_new/router/router.dart';
import '../../core_new/widgets/custom_image.dart';
import 'add_product.dart';
import 'add_shipment.dart';

class ProductDetails extends StatefulWidget {
  static const String id = 'ProductDetails';
  final int productId;

  const ProductDetails({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late ProductProvider _productProvider;
  late AuthProvider _authProvider;
  late AddShipmentProvider _addShipmentProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _addShipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final AddShipmentProvider shipmentProvider =
        Provider.of<AddShipmentProvider>(context);
    log('productProvider.productById.image -> ${productProvider.productById!.image}');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'منتج رقم ${widget.productId}',
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Container(
                height: 35.h,
                width: 35.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                )),
            onPressed: () {
              MagicRouter.pop();
            },
          ),
        ),
        body: productProvider.productByIdState == NetworkState.WAITING
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    weevoPrimaryOrangeColor,
                  ),
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: CustomImage(
                          imageUrl: productProvider.productById!.image,
                          height: 196.h,
                          width: size.width,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productProvider.productById!.name!,
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  strutStyle: const StrutStyle(
                                    forceStrutHeight: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                Text(
                                  productProvider.productById!.description ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 11.0.sp,
                                    color: const Color(0xff858585),
                                  ),
                                  strutStyle: const StrutStyle(
                                    forceStrutHeight: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Row(children: [
                            productProvider.getCatById(productProvider
                                        .productById!.categoryId!) !=
                                    null
                                ? Row(
                                    children: [
                                      CustomImage(
                                        imageUrl:
                                            '${ApiConstants.baseUrl}${productProvider.productById!.productCategory!.image}',
                                        height: 25.h,
                                        width: 25.w,
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        '${productProvider.productById!.productCategory!.name}',
                                        style: TextStyle(
                                          fontSize: 12.0.sp,
                                        ),
                                      )
                                    ],
                                  )
                                : Container(),
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/weevo_dimension.png',
                            fit: BoxFit.contain,
                            height: 30.0.h,
                            width: 30.0.w,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            '${double.parse(productProvider.productById!.length!).toInt()}',
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            ' x ',
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              color: Colors.grey,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            '${double.parse(productProvider.productById!.width!).toInt()}',
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            ' x ',
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              color: Colors.grey,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            '${double.parse(productProvider.productById!.height!).toInt()}',
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            child: Image.asset(
                              'assets/images/weevo_weight.png',
                              fit: BoxFit.contain,
                              height: 30.0.h,
                              width: 30.0.w,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '${double.parse(productProvider.productById!.weight!).toInt()}',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'كيلو جرام',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: weevoBlueBlack,
                                  fontWeight: FontWeight.w300,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            child: Image.asset(
                              'assets/images/weevo_money.png',
                              fit: BoxFit.contain,
                              height: 30.0.h,
                              width: 30.0.w,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Row(
                            children: [
                              Text(
                                '${productProvider.productById!.price}',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                'جنيه',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: weevoBlueBlack,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _addShipmentProvider.addShipmentProduct(
                                productProvider.productById!,
                              );
                              shipmentProvider
                                  .setShipmentFromWhere(oneShipment);
                              Navigator.pushNamed(context, AddShipment.id);
                            },
                            child: Card(
                              elevation: 2.0,
                              shadowColor:
                                  weevoPrimaryOrangeColor.withOpacity(0.2),
                              color: weevoPrimaryOrangeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  12.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/product_shipment.png',
                                      width: 30.0,
                                      height: 30.0,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.03,
                                    ),
                                    const Text(
                                      'اشحن المنتج',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AddProduct.id,
                                      arguments: AddProductArg(
                                        isUpdated: true,
                                        isDuplicate: false,
                                        product: productProvider.productById,
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    elevation: 2.0,
                                    shadowColor:
                                        weevoLightPurpleColor.withOpacity(0.2),
                                    color: Colors.grey,
                                    child: const Padding(
                                      padding: EdgeInsets.all(
                                        12.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'تعديل المنتج',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: navigator.currentContext!,
                                      builder: (context) => ActionDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                        ),
                                        title: 'حذف المنتج',
                                        content: 'هل تود حذف هذا المنتج',
                                        approveAction: 'نعم',
                                        onApproveClick: () {
                                          productProvider.removeProduct(
                                              productProvider.productById!.id!);
                                          MagicRouter.pop();
                                          if (productProvider
                                                  .removeProductState ==
                                              NetworkState.LOGOUT) {
                                            check(
                                                ctx: context,
                                                auth: _authProvider,
                                                state: productProvider
                                                    .removeProductState!);
                                          } else {
                                            MagicRouter.pop();
                                          }
                                        },
                                        cancelAction: 'لا',
                                        onCancelClick: () {
                                          MagicRouter.pop();
                                        },
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.red,
                                    elevation: 2.0,
                                    shadowColor: Colors.red.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(
                                        12.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'حذف المنتج',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void getProduct() async {
    await _productProvider.getProductById(
      widget.productId,
    );
    check(
        ctx: navigator.currentContext!,
        auth: _authProvider,
        state: _productProvider.productByIdState!);
  }
}
