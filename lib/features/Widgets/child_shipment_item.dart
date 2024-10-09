import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Models/display_child_shipment.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core_new/widgets/custom_image.dart';

class ChildShipmentItem extends StatelessWidget {
  final VoidCallback onItemClick;
  final DisplayChildShipment shipment;

  const ChildShipmentItem({
    super.key,
    required this.onItemClick,
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    final addShipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);

    return GestureDetector(
        onTap: onItemClick,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImage(
                          imageUrl: shipment.products![0].productInfo!.image,
                          height: 150.0.h,
                          width: 150.0.h,
                        ),
                      ),
                      shipment.status == 'returned' ||
                              shipment.status == 'delivered'
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              height: 32.h,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                  color: shipment.status == 'returned'
                                      ? weevoPrimaryOrangeColor
                                      : weevoPrimaryBlueColor),
                              child: Center(
                                child: Text(
                                  shipment.status == 'returned'
                                      ? 'مرتجعة'
                                      : 'مكتملة',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shipment.products![0].productInfo!.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      shipment.products![0].productInfo!
                                          .description!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              shipment.paymentMethod == 'cod'
                                  ? Image.asset(
                                      'assets/images/shipment_cod_icon.png',
                                      height: 35.0.h,
                                      width: 35.0.h)
                                  : Image.asset(
                                      'assets/images/shipment_online_icon.png',
                                      height: 35.0.h,
                                      width: 35.0.h)
                            ],
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: weevoPrimaryOrangeColor,
                                ),
                                height: 8.h,
                                width: 8.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: Text(
                                  '${addShipmentProvider.getStateNameById(int.parse(shipment.receivingState ?? '0'))} - ${addShipmentProvider.getCityNameById(int.parse(shipment.receivingState ?? '0'), int.parse(shipment.receivingCity ?? '0'))}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 2.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: List.generate(
                                3,
                                (index) => Container(
                                  margin: const EdgeInsets.only(top: 1),
                                  height: 3,
                                  width: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.5),
                                    color: index < 3
                                        ? weevoPrimaryOrangeColor
                                        : weevoPrimaryBlueColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: weevoPrimaryBlueColor,
                                ),
                                height: 8.h,
                                width: 8.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: Text(
                                  '${addShipmentProvider.getStateNameById(int.parse(shipment.deliveringState ?? '0'))} - ${addShipmentProvider.getCityNameById(int.parse(shipment.deliveringState ?? '0'), int.parse(shipment.deliveringCity ?? '0'))}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color(0xffD8F3FF),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/money_icon.png',
                                        fit: BoxFit.contain,
                                        color: const Color(0xff091147),
                                        height: 20.h,
                                        width: 20.w,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '${double.parse(shipment.amount ?? '0').toInt()}',
                                        style: TextStyle(
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        'جنية',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '${double.parse(shipment.agreedShippingCostAfterDiscount ?? shipment.agreedShippingCost ?? shipment.shippingCost ?? '0').toInt()}',
                                        style: TextStyle(
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        'جنية',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
