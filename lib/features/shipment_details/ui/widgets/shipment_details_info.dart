import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/shipment_details_model.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core_new/helpers/spacing.dart';
import 'wasully_details_price_info.dart';

class ShipmentDetailsInfo extends StatelessWidget {
  final ShipmentDetailsModel? shipmentDetails;
  const ShipmentDetailsInfo({super.key, this.shipmentDetails});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ShipmentDetailsCubit>();
        final product =
            cubit.shipmentDetails!.products[cubit.currentProductIndex];
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                spreadRadius: 1.0,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.productInfo.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  horizontalSpace(4),
                  IconButton(
                    onPressed: () =>
                        context.read<ShipmentDetailsCubit>().shareWasully(),
                    icon: const Icon(
                      Icons.share,
                    ),
                  ),
                ],
              ),
              verticalSpace(10),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        WasullyDetailsPriceInfo(
                          priceImage: 'weevo_money',
                          price: shipmentDetails?.amount ?? '',
                          title: 'قيمة الطلب',
                        ),
                        Text(
                          '|',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/shipment_inside_online_icon.png',
                              height: 20.h,
                              width: 20.w,
                              fit: BoxFit.contain,
                            ),
                            horizontalSpace(2),
                            Text(
                              'مدفوع أونلاين',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpace(5),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      runSpacing: 5,
                      direction: Axis.horizontal,
                      children: [
                        WasullyDetailsPriceInfo(
                          priceImage: 'van_icon',
                          price:
                              '${shipmentDetails!.agreedShippingCostAfterDiscount ?? shipmentDetails!.agreedShippingCost ?? shipmentDetails!.expectedShippingCost}',
                          title: 'رسوم التوصيل',
                        ),
                        Text(
                          '|',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        WasullyDetailsPriceInfo(
                          priceImage: 'van_icon',
                          price: product.productInfo.weight,
                          title: 'الوزن',
                          subTitle: 'كيلو',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
