import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Models/shipment_tab_model.dart';
import '../../core/Providers/display_shipment_provider.dart';

class ShipmentStatusItem extends StatelessWidget {
  final ShipmentTab data;
  final Function onItemClick;
  final int index;
  final int selectedItem;

  const ShipmentStatusItem({
    required this.data,
    required this.onItemClick,
    required this.index,
    required this.selectedItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DisplayShipmentProvider displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context);
    return GestureDetector(
      onTap: () => onItemClick(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: selectedItem == index ? Colors.orange : Colors.grey[200],
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              data.image,
              height: 20.h,
              width: 20.w,
              color: index == selectedItem
                  ? Colors.white
                  : const Color(0xff575757),
            ),
            SizedBox(
              width: 6.0.w,
            ),
            Text(
              data.name,
              style: TextStyle(
                  fontSize: 10.0.sp,
                  color: index == selectedItem
                      ? Colors.white
                      : const Color(0xff575757)),
            ),
            SizedBox(
              width: 6.0.w,
            ),
            index == selectedItem
                ? index == 0
                    ? Container(
                        height: 18.h,
                        width: 18.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(
                          '${displayShipmentProvider.availableTotalItems + displayShipmentProvider.offerBasedTotalItems}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )))
                    : index == 1
                        ? Container(
                            height: 18.h,
                            width: 18.w,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              '${displayShipmentProvider.unCompletedTotalItems}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )))
                        : index == 2
                            ? Container(
                                height: 18.h,
                                width: 18.w,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: Text(
                                  '${displayShipmentProvider.merchantAcceptedTotalItems}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )))
                            : index == 3
                                ? Container(
                                    height: 18.h,
                                    width: 18.w,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                        child: Text(
                                      '${displayShipmentProvider.courierOnHisWatToGetShipmentTotalItems}',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )))
                                : index == 4
                                    ? Container(
                                        height: 18.h,
                                        width: 18.w,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${displayShipmentProvider.onDeliveryTotalItems}',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )))
                                    : index == 5
                                        ? Container(
                                            height: 18.h,
                                            width: 18.w,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                                child: Text(
                                              '${displayShipmentProvider.deliveredTotalItems}',
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )))
                                        : index == 6
                                            ? Container(
                                                height: 18.h,
                                                width: 18.w,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  '${displayShipmentProvider.returnedTotalItems}',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )))
                                            : Container(
                                                height: 18.h,
                                                width: 18.w,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${displayShipmentProvider.cancelledTotalItems}',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                : Container(),
          ],
        ),
      ),
    );
  }
}
