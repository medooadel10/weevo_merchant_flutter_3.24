import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/shipment_details_model.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core/Models/chat_data.dart';
import '../../../../core/Models/feedback_data_arg.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/widgets/custom_image.dart';
import '../../../Screens/chat_screen.dart';
import '../../../Screens/merchant_feedback.dart';

class ShipmentDetailsCourierHeader extends StatelessWidget {
  const ShipmentDetailsCourierHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    ShipmentDetailsModel? data = cubit.shipmentDetails;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.0.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            spreadRadius: 1.0,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.w,
        vertical: 5.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImage(
            imageUrl: data?.courier?.photo != null
                ? data!.courier!.photo!.contains(ApiConstants.baseUrl)
                    ? data.courier!.photo
                    : '${ApiConstants.baseUrl}/${data.courier!.photo}'
                : '',
            height: 60.h,
            width: 60.h,
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${data!.courier!.firstName} ${data.courier!.lastName}',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                data.courier!.deliveryMethod == 'truck'
                    ? Image.asset(
                        'assets/images/courier_van_delivery_method.png',
                        height: 25.0.h,
                        width: 25.0.w,
                      )
                    : data.courier!.deliveryMethod == 'car'
                        ? Image.asset(
                            'assets/images/courier_car_delivery_method.png',
                            height: 25.0.h,
                            width: 25.0.w,
                          )
                        : data.courier!.deliveryMethod == 'motorbike'
                            ? Image.asset(
                                'assets/images/courier_motor_cycle_delivery_method.png',
                                height: 25.0.h,
                                width: 25.0.w,
                              )
                            : data.courier!.deliveryMethod == 'bicycle'
                                ? Image.asset(
                                    'assets/images/courier_bicycle_delivery_method.png',
                                    height: 25.0.h,
                                    width: 25.0.w,
                                  )
                                : Container(),
                verticalSpace(5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, MerchantFeedback.id,
                            arguments: FeedbackDataArg(
                                username: data.courier!.name,
                                userId: data.courier!.id));
                      },
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFFE9DF),
                        ),
                        child: const Icon(
                          Icons.star,
                          size: 20.0,
                          color: weevoPrimaryOrangeColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(
                          navigator.currentContext!,
                          ChatScreen.id,
                          arguments: ChatData(
                            authProvider.phone!,
                            data.courier!.phone,
                            currentUserNationalId: '',
                            peerNationalId: data.courier!.phone,
                            currentUserImageUrl: authProvider.photo!,
                            currentUserId: authProvider.id!,
                            currentUserName: authProvider.name!,
                            peerId: data.courierId.toString(),
                            peerUserName: data.courier!.name,
                            shipmentId: data.id,
                            peerImageUrl: data.courier!.photo!,
                          ),
                        );
                      },
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFFE9DF),
                        ),
                        child: Image.asset(
                          'assets/images/new_chat_icon.png',
                          color: weevoPrimaryOrangeColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () async {
                        await launchUrlString(
                          'tel:${data.courier!.phone}',
                        );
                      },
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFFE9DF),
                        ),
                        child: Image.asset(
                          'assets/images/new_call_icon.png',
                          color: weevoPrimaryOrangeColor,
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
    );
  }
}
