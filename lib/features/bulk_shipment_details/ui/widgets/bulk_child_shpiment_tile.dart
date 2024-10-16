import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Providers/add_shipment_provider.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/core_new/router/router.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_image.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/product_model.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/ui/shipment_details_screen.dart';

import '../../../../core/Utilits/colors.dart';
import '../../../Widgets/slide_dotes.dart';
import '../../../shipment_details/data/models/shipment_details_model.dart';

class BulkChildShpimentTile extends StatefulWidget {
  final ShipmentDetailsModel child;
  const BulkChildShpimentTile({super.key, required this.child});

  @override
  State<BulkChildShpimentTile> createState() => _BulkChildShpimentTileState();
}

class _BulkChildShpimentTileState extends State<BulkChildShpimentTile> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    log('Statusssssss : ${widget.child.status}');

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.child.products.length,
          itemBuilder: (context, index, realIndex) {
            final product = widget.child.products[index];
            return _bulildCartShipmentProductTile(product, context);
          },
          options: CarouselOptions(
            autoPlay: false,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            aspectRatio: 1.0,
            initialPage: 0,
            height: 191.h,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        if (widget.child.status == 'delivered' ||
            widget.child.status == 'returned')
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                color: widget.child.status == 'delivered'
                    ? weevoPrimaryBlueColor
                    : widget.child.status == 'returned'
                        ? weevoPrimaryOrangeColor
                        : null,
              ),
              child: Text(
                widget.child.status == 'delivered'
                    ? 'مكتملة'
                    : widget.child.status == 'returned'
                        ? 'مرتجعة'
                        : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10.w,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.child.products.length,
                (index) => currentIndex == index
                    ? const CategoryDotes(
                        isActive: true,
                        isPlus: true,
                      )
                    : const CategoryDotes(
                        isActive: false,
                        isPlus: true,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bulildCartShipmentProductTile(
      ProductModel product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        MagicRouter.navigateTo(ShipmentDetailsScreen(id: widget.child.id));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            SizedBox(
              height: 110.h,
              child: Row(
                children: [
                  CustomImage(
                    imageUrl: product.productInfo.image,
                    width: 100.w,
                    height: 100.h,
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productInfo.name,
                                    style: TextStyle(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    product.productInfo.description,
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            horizontalSpace(10),
                            Image.asset(
                              widget.child.paymentMethod == 'cod'
                                  ? 'assets/images/shipment_cod_icon.png'
                                  : 'assets/images/shipment_online_icon.png',
                              width: 30.w,
                              height: 30.h,
                            )
                          ],
                        ),
                        verticalSpace(10),
                        _buildShipmentLocations(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(10),
            _buildShipmentPrices(context, product),
          ],
        ).paddingSymmetric(
          horizontal: 10.0.w,
          vertical: 10.0.h,
        ),
      ),
    );
  }

  Widget _buildShipmentLocations(BuildContext context) {
    final addShipmentProvider = context.read<AddShipmentProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 10.0.h,
              width: 10.0.w,
              decoration: const BoxDecoration(
                color: weevoPrimaryOrangeColor,
                shape: BoxShape.circle,
              ),
            ),
            horizontalSpace(5),
            Expanded(
              child: Text(
                '${addShipmentProvider.getStateNameById(int.parse(widget.child.receivingState))} - ${addShipmentProvider.getCityNameById(int.parse(widget.child.receivingState), int.parse(widget.child.receivingCity)) ?? ''}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          backgroundColor: weevoPrimaryOrangeColor,
          radius: 3.0,
        ).paddingOnly(
          right: 2.3.w,
        ),
        verticalSpace(3),
        const CircleAvatar(
          backgroundColor: weevoPrimaryOrangeColor,
          radius: 3.0,
        ).paddingOnly(
          right: 2.3.w,
        ),
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: weevoPrimaryBlueColor,
              radius: 5.0,
            ),
            horizontalSpace(5),
            Expanded(
              child: Text(
                '${addShipmentProvider.getStateNameById(int.parse(widget.child.deliveringState))} - ${addShipmentProvider.getCityNameById(int.parse(widget.child.deliveringState), int.parse(widget.child.deliveringCity)) ?? ''}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShipmentPrices(BuildContext context, ProductModel product) {
    return Container(
      height: 40.h,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffD8F3FF),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/money_icon.png',
                    fit: BoxFit.contain,
                    color: const Color(0xff091147),
                    height: 20.h,
                    width: 20.w,
                  ),
                  horizontalSpace(5),
                  Expanded(
                    child: Text(
                      '${product.price.toString().toStringAsFixed0()} جنية',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          horizontalSpace(5),
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  'assets/images/van_icon.png',
                  fit: BoxFit.contain,
                  color: const Color(0xff091147),
                  height: 20.h,
                  width: 20.w,
                ),
                horizontalSpace(5),
                Expanded(
                  child: Text(
                    '${widget.child.agreedShippingCost != null ? widget.child.agreedShippingCost?.toStringAsFixed0() : widget.child.expectedShippingCost?.toStringAsFixed0()} جنية',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
