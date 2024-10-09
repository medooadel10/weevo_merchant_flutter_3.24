import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/qr_dialog_code.dart';
import '../../core/Models/display_bulk_shipment.dart';
import '../../core/Models/refresh_qr_code.dart';
import '../../core/Models/shipment_notification.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core_new/widgets/custom_image.dart';
import '../Screens/choose_courier.dart';
import 'slide_dotes.dart';

class BulkItem extends StatefulWidget {
  final DisplayBulkShipment bulkShipment;
  final VoidCallback onItemPressed;

  const BulkItem({
    super.key,
    required this.bulkShipment,
    required this.onItemPressed,
  });

  @override
  State<BulkItem> createState() => _BulkItemState();
}

class _BulkItemState extends State<BulkItem> {
  int _currentIndex = 0;
  late PageController _pageController;
  final Preferences _preferences = Preferences.instance;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final addShipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return GestureDetector(
      onTap: widget.onItemPressed,
      child: widget.bulkShipment.children!.isNotEmpty
          ? Container(
              margin: const EdgeInsets.all(6.0),
              height: 170.h,
              child: PageView.builder(
                onPageChanged: (int i) {
                  setState(() {
                    _currentIndex = i;
                  });
                },
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemCount: widget.bulkShipment.children!.length,
                itemBuilder: (context, i) => Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150.0.h,
                          width: 150.0.h,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: CustomImage(
                                            imageUrl: widget
                                                .bulkShipment
                                                .children![i]
                                                .products![0]
                                                .productInfo!
                                                .image,
                                            height: 150.0.h,
                                            width: 150.0.h,
                                          ),
                                        ),
                                      ),
                                      widget.bulkShipment.children!.length > 1
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              height: 40.h,
                                              margin: const EdgeInsets.only(
                                                  top: 20.0),
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      'assets/images/clip_path_background.png',
                                                    ),
                                                    fit: BoxFit.fill),
                                              ),
                                              child: Text(
                                                '${widget.bulkShipment.children!.length} شحنة',
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  widget.bulkShipment.status == 'available' &&
                                          widget.bulkShipment.isOfferBased == 1
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context, ChooseCourier.id,
                                                arguments: ShipmentNotification(
                                                    merchantName:
                                                        authProvider.name,
                                                    merchantImage:
                                                        authProvider.photo,
                                                    merchantFcmToken:
                                                        authProvider.fcmToken,
                                                    receivingState: widget
                                                        .bulkShipment
                                                        .receivingState,
                                                    receivingCity: null,
                                                    deliveryCity: null,
                                                    childrenShipment: widget
                                                        .bulkShipment
                                                        .children!
                                                        .length,
                                                    deliveryState: widget
                                                        .bulkShipment
                                                        .deliveringState,
                                                    shipmentId:
                                                        widget.bulkShipment.id,
                                                    shippingCost: widget
                                                        .bulkShipment
                                                        .shippingCost,
                                                    totalShipmentCost: widget
                                                        .bulkShipment.amount));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 6.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 30.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ),
                                                    color: _preferences
                                                                .getWeevoShipmentOfferCount(widget
                                                                    .bulkShipment
                                                                    .id
                                                                    .toString()) <=
                                                            0
                                                        ? weevoPrimaryOrangeColor
                                                        : weevoPrimaryBlueColor,
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15.0,
                                                    vertical: 4.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        _preferences.getWeevoShipmentOfferCount(widget
                                                                    .bulkShipment
                                                                    .id
                                                                    .toString()) <=
                                                                0
                                                            ? 'في انتظار العروض'
                                                            : 'لديك ${_preferences.getWeevoShipmentOfferCount(widget.bulkShipment.id.toString())} عرض',
                                                        style: const TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4.0.w,
                                                      ),
                                                      const SpinKitThreeBounce(
                                                        color: Colors.white,
                                                        size: 10.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              widget.bulkShipment.status ==
                                      'on-the-way-to-get-shipment-from-merchant'
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: navigator.currentContext!,
                                          builder: (context) => QrCodeDialog(
                                              data: RefreshQrcode(
                                                  filename: widget.bulkShipment
                                                      .handoverQrcodeMerchantToCourier!
                                                      .split('/')
                                                      .last,
                                                  path: widget.bulkShipment
                                                      .handoverQrcodeMerchantToCourier,
                                                  code: int.parse(widget
                                                      .bulkShipment
                                                      .handoverCodeMerchantToCourier!))),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          right: 12.0,
                                          bottom: 6.0,
                                        ),
                                        height: 45.h,
                                        width: 45.h,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: weevoPrimaryOrangeColor,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Image.asset(
                                            'assets/images/big_qrcode_icon.png',
                                            color: Colors.white,
                                            height: 15.0.h,
                                            width: 15.0.h),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget
                                                .bulkShipment
                                                .children![i]
                                                .products![0]
                                                .productInfo!
                                                .name!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            widget
                                                .bulkShipment
                                                .children![i]
                                                .products![0]
                                                .productInfo!
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
                                        '${addShipmentProvider.getStateNameById(int.parse(widget.bulkShipment.children?[i].receivingState ?? '0'))} - ${addShipmentProvider.getCityNameById(int.parse(widget.bulkShipment.children?[i].receivingState ?? '0'), int.parse(widget.bulkShipment.children?[i].receivingCity ?? '0'))}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                                          borderRadius:
                                              BorderRadius.circular(1.5),
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
                                        '${addShipmentProvider.getStateNameById(int.parse(widget.bulkShipment.children?[i].deliveringState ?? '0'))} - ${addShipmentProvider.getCityNameById(int.parse(widget.bulkShipment.children?[i].deliveringState ?? '0'), int.parse(widget.bulkShipment.children?[i].deliveringCity ?? '0'))}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                            Row(
                                              children: [
                                                Text(
                                                  '${double.parse(widget.bulkShipment.children?[i].amount ?? '0').toInt()}',
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
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${double.parse(widget.bulkShipment.children![i].agreedShippingCostAfterDiscount ?? widget.bulkShipment.children![i].agreedShippingCost ?? widget.bulkShipment.children![i].shippingCost ?? '0').toInt()}',
                                                    style: TextStyle(
                                                      fontSize: 12.0.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    'جنية',
                                                    style: TextStyle(
                                                      fontSize: 10.0.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
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
                    widget.bulkShipment.children!.length > 1
                        ? Positioned(
                            top: size.height * 0.21,
                            right: size.width * 0.42,
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
                                  widget.bulkShipment.children!.length,
                                  (index) => _currentIndex == index
                                      ? CategoryDotes(
                                          isActive: true,
                                          isPlus: true,
                                        )
                                      : CategoryDotes(
                                          isActive: false,
                                          isPlus: true,
                                        ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: (widget.bulkShipment.products![0]
                                            .productInfo!.image !=
                                        null &&
                                    widget.bulkShipment.products![0]
                                        .productInfo!.image!.isNotEmpty)
                                ? CustomImage(
                                    imageUrl: widget.bulkShipment.products![0]
                                        .productInfo!.image,
                                    height: 150.0.h,
                                    width: 150.0.h,
                                  )
                                : Image.asset(
                                    'assets/images/profile_picture.png',
                                    height: 150.0.h,
                                    width: 150.0.h,
                                  ),
                          ),
                          widget.bulkShipment.status == 'available' &&
                                  widget.bulkShipment.isOfferBased == 1
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      ChooseCourier.id,
                                      arguments: ShipmentNotification(
                                          merchantName: authProvider.name,
                                          merchantImage: authProvider.photo,
                                          merchantFcmToken:
                                              authProvider.fcmToken,
                                          receivingState: widget
                                              .bulkShipment.receivingState,
                                          receivingCity:
                                              widget.bulkShipment.receivingCity,
                                          deliveryCity: widget
                                              .bulkShipment.deliveringCity,
                                          childrenShipment: widget
                                              .bulkShipment.children!.length,
                                          deliveryState: widget
                                              .bulkShipment.deliveringState,
                                          shipmentId: widget.bulkShipment.id,
                                          shippingCost:
                                              widget.bulkShipment.shippingCost,
                                          totalShipmentCost:
                                              widget.bulkShipment.amount),
                                    );
                                  },
                                  child: Container(
                                    height: 30.0,
                                    margin: const EdgeInsets.only(bottom: 6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        20.0,
                                      ),
                                      color: _preferences
                                                  .getWeevoShipmentOfferCount(
                                                      widget.bulkShipment.id
                                                          .toString()) <=
                                              0
                                          ? weevoPrimaryOrangeColor
                                          : weevoPrimaryBlueColor,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          _preferences.getWeevoShipmentOfferCount(
                                                      widget.bulkShipment.id
                                                          .toString()) <=
                                                  0
                                              ? 'في انتظار العروض'
                                              : 'لديك ${_preferences.getWeevoShipmentOfferCount(widget.bulkShipment.id.toString())} عرض',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.0.w,
                                        ),
                                        const SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 10.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      widget.bulkShipment.status ==
                              'on-the-way-to-get-shipment-from-merchant'
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: navigator.currentContext!,
                                  builder: (context) => QrCodeDialog(
                                      data: RefreshQrcode(
                                          filename: widget.bulkShipment
                                              .handoverQrcodeMerchantToCourier!
                                              .split('/')
                                              .last,
                                          path: widget.bulkShipment
                                              .handoverQrcodeMerchantToCourier,
                                          code: int.parse(widget.bulkShipment
                                              .handoverCodeMerchantToCourier!))),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  right: 12.0,
                                  bottom: 6.0,
                                ),
                                height: 45.h,
                                width: 45.h,
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: weevoPrimaryOrangeColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Image.asset(
                                    'assets/images/big_qrcode_icon.png',
                                    color: Colors.white,
                                    height: 15.0.h,
                                    width: 15.0.h),
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
                                      widget.bulkShipment.products![0]
                                          .productInfo!.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      widget.bulkShipment.products![0]
                                              .productInfo!.description ??
                                          '',
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
                              widget.bulkShipment.paymentMethod == 'cod'
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
                                  '${widget.bulkShipment.receivingStateModel!.name} - ${widget.bulkShipment.receivingCityModel!.name}',
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
                                  '${widget.bulkShipment.deliveringStateModel!.name} - ${widget.bulkShipment.deliveringCityModel!.name}',
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
                                        '${double.parse(widget.bulkShipment.amount!).toInt()}',
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
                                        '${double.parse(widget.bulkShipment.agreedShippingCostAfterDiscount ?? widget.bulkShipment.agreedShippingCost ?? widget.bulkShipment.shippingCost ?? '0').toInt()}',
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
            ),
    );
  }
}
