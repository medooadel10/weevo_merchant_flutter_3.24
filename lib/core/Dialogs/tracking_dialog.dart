import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/api_constants.dart';

import '../../core_new/helpers/spacing.dart';
import '../../features/Screens/chat_screen.dart';
import '../Models/chat_data.dart';
import '../Models/shipment_tracking_model.dart';
import '../Providers/add_shipment_provider.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';

class TrackingDialog extends StatelessWidget {
  final ShipmentTrackingModel model;
  final bool isWasully;

  const TrackingDialog({
    super.key,
    required this.model,
    this.isWasully = false,
  });

  @override
  Widget build(BuildContext context) {
    final AddShipmentProvider addShipmentProvider =
        Provider.of<AddShipmentProvider>(context);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0))),
        elevation: 0,
        margin: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35.0,
                    backgroundImage: model.courierImage != null &&
                            model.courierImage!.isNotEmpty
                        ? NetworkImage(model.courierImage!
                                .contains(ApiConstants.baseUrl)
                            ? model.courierImage ?? ''
                            : '${ApiConstants.baseUrl}${model.courierImage}')
                        : const AssetImage('assets/images/profile_picture.png'),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.courierName ?? '',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Row(
                          children: [
                            Text(
                              '4.9',
                              style: TextStyle(
                                color: weevoPrimaryOrangeColor,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              color: weevoPrimaryOrangeColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChatScreen.id,
                            arguments: ChatData(
                              authProvider.phone ?? '',
                              model.courierPhone ?? '',
                              currentUserNationalId: '',
                              peerNationalId: model.courierNationalId ?? '',
                              currentUserImageUrl: authProvider.photo ?? '',
                              currentUserId: authProvider.id ?? '',
                              currentUserName: authProvider.name ?? '',
                              peerId: model.courierId.toString(),
                              peerUserName: model.courierName ?? '',
                              shipmentId: model.shipmentId ?? 0,
                              peerImageUrl: model.courierImage ?? '',
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: weevoLightPurpleColor,
                          radius: 20.0,
                          child: Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await launchUrlString(
                            'tel:${model.courierPhone}',
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: weevoLightGreen,
                          radius: 20.0,
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 5.0,
                    backgroundColor: weevoYellowColor,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: model.wasullyModel == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addShipmentProvider.getStateNameById(int.parse(
                                        model.receivingState ?? '0')) ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                addShipmentProvider.getCityNameById(
                                      int.parse(model.receivingState ?? '0'),
                                      int.parse(model.receivingCity ?? '0'),
                                    ) ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0.sp,
                                ),
                              ),
                              if (isWasully)
                                Text(
                                  model.deliveringStreet ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0.sp,
                                  ),
                                ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.wasullyModel?.receivingStateModel?.name ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                model.wasullyModel?.receivingCityModel?.name ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0.sp,
                                ),
                              ),
                              if (isWasully)
                                Text(
                                  model.deliveringStreet ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0.sp,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 5.0,
                    backgroundColor: weevoRedColor,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: model.wasullyModel == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addShipmentProvider.getStateNameById(
                                      int.parse(model.deliveringState ?? '0'),
                                    ) ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                addShipmentProvider.getCityNameById(
                                      int.parse(model.deliveringState ?? '0'),
                                      int.parse(model.deliveringCity ?? '0'),
                                    ) ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0.sp,
                                ),
                              ),
                              if (isWasully)
                                Text(
                                  model.receivingStreet ?? '',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0.sp),
                                ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.wasullyModel?.deliveringStateModel
                                        ?.name ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                model.wasullyModel?.deliveringCityModel?.name ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0.sp,
                                ),
                              ),
                              if (isWasully)
                                Text(
                                  model.receivingStreet ?? '',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0.sp),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
              if (model.wasullyModel != null) ...[
                verticalSpace(20),
                Row(
                  children: [
                    Text(
                      'سيتم تحصيل رسوم التوصيل من',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    horizontalSpace(4),
                    Expanded(
                      child: Text(
                        model.wasullyModel?.whoPay == 'me'
                            ? 'المرسل'
                            : 'المستلم',
                        style: TextStyle(
                          color: weevoPrimaryOrangeColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
