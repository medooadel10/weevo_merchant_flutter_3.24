import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Dialogs/cancel_shipment_dialog.dart';
import '../../core/Dialogs/loading.dart';
import '../../core/Dialogs/qr_dialog_code.dart';
import '../../core/Dialogs/share_save_qr_code_dialog.dart';
import '../../core/Dialogs/shipment_raise_dialog.dart';
import '../../core/Dialogs/wallet_dialog.dart';
import '../../core/Models/chat_data.dart';
import '../../core/Models/feedback_data_arg.dart';
import '../../core/Models/refresh_qr_code.dart';
import '../../core/Models/shipment_notification.dart';
import '../../core/Models/shipment_tracking_model.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/choose_captain_provider.dart';
import '../../core/Providers/display_shipment_provider.dart';
import '../../core/Providers/shipment_tracking_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../../core_new/networking/api_constants.dart';
import '../../core_new/widgets/custom_image.dart';
import '../Widgets/loading_widget.dart';
import '../Widgets/shipment_product_item.dart';
import '../Widgets/weevo_button.dart';
import 'add_shipment.dart';
import 'chat_screen.dart';
import 'choose_courier.dart';
import 'handle_shipment.dart';
import 'home.dart';
import 'merchant_feedback.dart';

class ShipmentDetailsWithMoreThanOneProduct extends StatefulWidget {
  final int shipmentId;

  const ShipmentDetailsWithMoreThanOneProduct(
      {super.key, required this.shipmentId});

  @override
  State<ShipmentDetailsWithMoreThanOneProduct> createState() =>
      _ShipmentDetailsWithMoreThanOneProductState();
}

class _ShipmentDetailsWithMoreThanOneProductState
    extends State<ShipmentDetailsWithMoreThanOneProduct> {
  String? shareLink;

  final String _ratingNumber = '3.5';
  PageController? _controller;
  late AuthProvider _authProvider;
  final Preferences _preferences = Preferences.instance;

  @override
  void initState() {
    super.initState();
    _createDynamicLink(widget.shipmentId);
    // _initDynamicLinks();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _controller = PageController(viewportFraction: 0.7, initialPage: 1);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    final trackingProvider = Provider.of<ShipmentTrackingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context);
    final chooseCaptainProvider = Provider.of<ChooseCaptainProvider>(context);
    return Consumer<DisplayShipmentProvider>(
      builder: (context, data, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'شحنة رقم ${data.shipmentById!.id}',
                    ),
                  ),
                ),
                (data.shipmentById!.parentId == 0 &&
                        data.shipmentById!.status == 'available' &&
                        data.shipmentById!.isOfferBased == 1)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            ChooseCourier.id,
                            arguments: ShipmentNotification(
                                merchantName: authProvider.name,
                                merchantImage: authProvider.photo,
                                merchantFcmToken: authProvider.fcmToken,
                                receivingState:
                                    data.shipmentById!.receivingState,
                                receivingCity: data.shipmentById!.receivingCity,
                                deliveryCity: data.shipmentById!.deliveringCity,
                                childrenShipment: 0,
                                deliveryState:
                                    data.shipmentById!.deliveringState,
                                shipmentId: data.shipmentById!.id,
                                shippingCost: data.shipmentById!.shippingCost,
                                totalShipmentCost: data.shipmentById!.amount),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            color: _preferences.getWeevoShipmentOfferCount(
                                        data.shipmentById!.id.toString()) <=
                                    0
                                ? weevoPrimaryOrangeColor
                                : weevoPrimaryBlueColor,
                          ),
                          padding: const EdgeInsets.all(
                            12.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                _preferences.getWeevoShipmentOfferCount(
                                            data.shipmentById!.id.toString()) <=
                                        0
                                    ? 'في انتظار العروض'
                                    : 'لديك ${_preferences.getWeevoShipmentOfferCount(data.shipmentById!.id.toString())} عرض',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
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
                (data.shipmentById!.status == 'available' &&
                        data.shipmentById!.isOfferBased == 1)
                    ? Container()
                    : Container(
                        height: 45.h,
                        width: 45.h,
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFE9DF),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            data.shipmentById!.paymentMethod == 'cod'
                                ? Image.asset(
                                    'assets/images/shipment_inside_cod_icon.png',
                                    height: 15.0.h,
                                    width: 15.0.h)
                                : Image.asset(
                                    'assets/images/shipment_inside_online_icon.png',
                                    height: 15.0.h,
                                    width: 15.0.h),
                            data.shipmentById!.paymentMethod == 'cod'
                                ? Text(
                                    'دفع مقدم',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    'مدفوع أونلاين',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                SizedBox(width: 6.w),
                data.shipmentById!.status ==
                        'on-the-way-to-get-shipment-from-merchant'
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (context) => QrCodeDialog(
                                data: RefreshQrcode(
                                    filename: data.shipmentById!
                                        .handoverQrcodeMerchantToCourier!
                                        .split('/')
                                        .last,
                                    path: data.shipmentById!
                                        .handoverQrcodeMerchantToCourier!,
                                    code: int.parse(data.shipmentById!
                                        .handoverCodeMerchantToCourier!))),
                          );
                        },
                        child: Container(
                          height: 45.h,
                          width: 45.h,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: weevoPrimaryOrangeColor,
                            borderRadius: BorderRadius.circular(12.r),
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
            leading: IconButton(
              onPressed: () {
                if (data.fromNewShipment && data.shipmentById!.parentId == 0) {
                  MagicRouter.pop();
                } else if (data.shipmentById!.parentId == 0) {
                  MagicRouter.pop();
                } else if (data.acceptNewShipment && !data.fromChildrenReview) {
                  data.setAcceptNewShipment(false);
                  Navigator.pushNamedAndRemoveUntil(
                      context, Home.id, (route) => false);
                } else if (_authProvider.fromOutsideNotification) {
                  _authProvider.setFromOutsideNotification(false);
                  Navigator.pushReplacementNamed(context, Home.id);
                } else {
                  if (displayShipmentProvider.shipmentById!.parentId! > 0) {
                    displayShipmentProvider.getBulkShipmentById(
                        displayShipmentProvider.shipmentById!.parentId!);
                  }
                  MagicRouter.pop();
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
              ),
            ),
          ),
          body: LoadingWidget(
            isLoading: shipmentProvider.state == NetworkState.WAITING ||
                data.merchantAcceptedShipmentState == NetworkState.WAITING ||
                data.offerBasedState == NetworkState.WAITING ||
                data.availableState == NetworkState.WAITING ||
                data.onDeliveryState == NetworkState.WAITING ||
                data.unCompletedState == NetworkState.WAITING ||
                data.cancelledState == NetworkState.WAITING,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Column(
                children: [
                  data.shipmentById!.status == 'courier-applied-to-shipment' ||
                          data.shipmentById!.status ==
                              'merchant-accepted-shipping-offer' ||
                          data.shipmentById!.status ==
                              'on-the-way-to-get-shipment-from-merchant' ||
                          data.shipmentById!.status == 'on-delivery'
                      ? Container(
                          height: 81.h,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  height: 60.h,
                                  width: 60.w,
                                  child: CustomImage(
                                    imageUrl: data.shipmentById!.courier!.photo,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${data.shipmentById!.courier!.firstName} ${data.shipmentById!.courier!.lastName}',
                                      style: TextStyle(
                                        fontSize: 15.0.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (data.shipmentById!.courier!
                                            .cachedAverageRating !=
                                        null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RatingBar.builder(
                                            initialRating:
                                                double.parse(_ratingNumber),
                                            minRating: 1,
                                            ignoreGestures: true,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 18.0,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: weevoLightYellow,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            data.shipmentById!.courier!
                                                    .cachedAverageRating ??
                                                '4.5',
                                            style: TextStyle(
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.pushNamed(
                                      context, MerchantFeedback.id,
                                      arguments: FeedbackDataArg(
                                          username:
                                              data.shipmentById!.courier!.name!,
                                          userId:
                                              data.shipmentById!.courier!.id!));
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
                                    )),
                              ),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: () async {
                                  DocumentSnapshot userToken =
                                      await FirebaseFirestore.instance
                                          .collection('merchant_users')
                                          .doc(data.shipmentById!.merchantId
                                              .toString())
                                          .get();
                                  String merchantNationalId =
                                      userToken['national_id'];
                                  Navigator.pushNamed(
                                      navigator.currentContext!, ChatScreen.id,
                                      arguments: ChatData(authProvider.phone!,
                                          '${data.shipmentById!.courier!.phone} ',
                                          currentUserImageUrl:
                                              authProvider.photo!,
                                          peerNationalId: merchantNationalId,
                                          currentUserNationalId:
                                              authProvider.getNationalId!,
                                          currentUserId: authProvider.id!,
                                          currentUserName: authProvider.name!,
                                          shipmentId: data.shipmentById!.id!,
                                          peerId: data
                                              .shipmentById!.courier!.id!
                                              .toString(),
                                          peerUserName:
                                              '${data.shipmentById!.courier!.firstName} ${data.shipmentById!.courier!.lastName}',
                                          peerImageUrl: data
                                              .shipmentById!.courier!.photo!));
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
                                    'tel:${data.shipmentById!.courier!.phone}',
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
                        )
                      : Container(),
                  data.shipmentById!.status ==
                              'merchant-accepted-shipping-offer' ||
                          data.shipmentById!.status ==
                              'courier-applied-to-shipment' ||
                          data.shipmentById!.status ==
                              'on-the-way-to-get-shipment-from-merchant' ||
                          data.shipmentById!.status == 'on-delivery'
                      ? SizedBox(
                          height: 10.h,
                        )
                      : Container(),
                  SizedBox(
                    height: 285.0.h,
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (int i) {
                        setState(() {});
                      },
                      itemBuilder: (context, i) => ShipmentProductItem(
                        product: data.shipmentById!.products![i],
                      ),
                      itemCount: data.shipmentById!.products!.length,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // IconButton(
                        //     onPressed: () async {
                        //       String msg;
                        //       StringBuffer sb = StringBuffer();
                        //       setState(() {
                        //         sb.write(
                        //             "اسم المنتج : ${data.shipmentById!.products![0].productInfo!.name} \n");
                        //         sb.write(
                        //             "مبلغ الشحنه : ${data.shipmentById!.amount} \n");
                        //         sb.write(
                        //             "تكلفة التوصيل : ${data.shipmentById!.agreedShippingCost ?? data.shipmentById!.shippingCost} \n");
                        //         sb.write(
                        //             "من : ${shipmentProvider.getCityNameById(int.parse(data.shipmentById!.deliveringState!), int.parse(data.shipmentById!.deliveringCity!))} - ${shipmentProvider.getStateNameById(int.parse(data.shipmentById!.deliveringState!))}  إلي : ${shipmentProvider.getCityNameById(int.parse(data.shipmentById!.receivingState!), int.parse(data.shipmentById!.receivingCity!))} - ${shipmentProvider.getStateNameById(int.parse(data.shipmentById!.receivingState!))}\n");

                        //         sb.write(shareLink);

                        //         msg = sb.toString();
                        //         log(shareLink.toString());
                        //       });
                        //       if (data.shipmentById!.products![0].productInfo!
                        //           .image!.isNotEmpty) {
                        //         var request = await HttpClient().getUrl(
                        //             Uri.parse(data.shipmentById!.products![0]
                        //                 .productInfo!.image!));
                        //         var response = await request.close();
                        //         Uint8List bytes =
                        //             await consolidateHttpClientResponseBytes(
                        //                 response);
                        //         await Share.('ESYS AMLOG', 'amlog.jpg',
                        //             bytes, 'image/jpg',
                        //             text: msg);
                        //       } else {
                        //         Share.text("title", msg, 'text/plain');
                        //       }
                        //     },
                        //     icon: const Icon(
                        //       Icons.share,
                        //       size: 20,
                        //     )),
                        SizedBox(
                          width: 8.w,
                        ),
                        Image.asset(
                          'assets/images/weevo_money.png',
                          height: 20.h,
                          width: 20.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '${double.parse(data.shipmentById!.amount!).toInt()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          strutStyle: const StrutStyle(
                            forceStrutHeight: true,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'جنية',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 7.0.sp,
                          ),
                          strutStyle: const StrutStyle(
                            forceStrutHeight: true,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        SizedBox(
                          height: 15.h,
                          child: VerticalDivider(
                            width: 1.w,
                            thickness: 1.0,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Image.asset(
                          'assets/images/van_icon.png',
                          height: 20.h,
                          width: 20.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '${double.parse(data.shipmentById!.agreedShippingCostAfterDiscount ?? data.shipmentById!.agreedShippingCost ?? data.shipmentById!.shippingCost ?? '0').toInt()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          strutStyle: const StrutStyle(
                            forceStrutHeight: true,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'جنية',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 7.0.sp,
                          ),
                          strutStyle: const StrutStyle(
                            forceStrutHeight: true,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        SizedBox(
                          height: 15.h,
                          child: VerticalDivider(
                            width: 1.w,
                            thickness: 1.0,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        data.shipmentById!.paymentMethod == 'cod'
                            ? Image.asset(
                                'assets/images/shipment_inside_cod_icon.png',
                                height: 20.0.h,
                                width: 20.0.h)
                            : Image.asset(
                                'assets/images/shipment_inside_online_icon.png',
                                height: 20.0.h,
                                width: 20.0.h),
                        SizedBox(
                          width: 5.w,
                        ),
                        data.shipmentById!.paymentMethod == 'cod'
                            ? Text(
                                'دفع مقدم',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              )
                            : Text(
                                'مدفوع أونلاين',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold,
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
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20.0,
                            spreadRadius: 0.0,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ]),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10.h,
                                  width: 10.w,
                                  decoration: BoxDecoration(
                                      color: weevoPrimaryOrangeColor,
                                      borderRadius: BorderRadius.circular(5.r)),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'المنزل',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15.0.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Text(
                                          'من - ',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                          ),
                                          strutStyle: const StrutStyle(
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                        Text(
                                          '${shipmentProvider.getStateNameById(int.parse(data.shipmentById!.receivingState!))} - ${shipmentProvider.getCityNameById(int.parse(data.shipmentById!.receivingState!), int.parse(data.shipmentById!.receivingCity!))}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                          ),
                                          strutStyle: const StrutStyle(
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                                height: 31.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).day ==
                                                  DateTime.now().day) &&
                                              (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).month ==
                                                  DateTime.now().month) &&
                                              (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).year ==
                                                  DateTime.now().year)
                                          ? 'اليوم'
                                          : (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).day ==
                                                      DateTime.now().day + 1) &&
                                                  (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).month ==
                                                      DateTime.now().month) &&
                                                  (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).year ==
                                                      DateTime.now().year)
                                              ? 'غداً'
                                              : (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).day ==
                                                          DateTime.now().day -
                                                              1) &&
                                                      (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).month ==
                                                          DateTime.now()
                                                              .month) &&
                                                      (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).year ==
                                                          DateTime.now().year)
                                                  ? 'أمس'
                                                  : intl.DateFormat('dd MMM yyyy', 'ar-EG')
                                                      .format(DateTime.parse(data.shipmentById!.dateToReceiveShipment!)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Text(
                                      intl.DateFormat('hh:mm a', 'ar-EG')
                                          .format(DateTime.parse(data
                                              .shipmentById!
                                              .dateToReceiveShipment!)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        const Divider(
                          height: 1.0,
                          thickness: 1.0,
                          color: Color(0xffE2E2E2),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10.h,
                                  width: 10.w,
                                  decoration: BoxDecoration(
                                      color: weevoPrimaryBlueColor,
                                      borderRadius: BorderRadius.circular(5.r)),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.shipmentById!.clientName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15.0.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Text(
                                          'إلي - ',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                          ),
                                          strutStyle: const StrutStyle(
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                        Text(
                                          '${shipmentProvider.getStateNameById(int.parse(data.shipmentById!.deliveringState!))} - ${shipmentProvider.getCityNameById(int.parse(data.shipmentById!.deliveringState!), int.parse(data.shipmentById!.deliveringCity!))}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                          ),
                                          strutStyle: const StrutStyle(
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      data.shipmentById!.deliveringStreet!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: const Color(0xffA1A1A1),
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                    width: 100.w,
                                    height: 31.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).day ==
                                                      DateTime.now().day) &&
                                                  (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).month ==
                                                      DateTime.now().month) &&
                                                  (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).year ==
                                                      DateTime.now().year)
                                              ? 'اليوم'
                                              : (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).day ==
                                                          DateTime.now().day +
                                                              1) &&
                                                      (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).month ==
                                                          DateTime.now()
                                                              .month) &&
                                                      (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).year ==
                                                          DateTime.now().year)
                                                  ? 'غداً'
                                                  : (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).day == DateTime.now().day - 1) &&
                                                          (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).month ==
                                                              DateTime.now()
                                                                  .month) &&
                                                          (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).year ==
                                                              DateTime.now()
                                                                  .year)
                                                      ? 'أمس'
                                                      : intl.DateFormat('dd MMM yyyy', 'ar-EG')
                                                          .format(DateTime.parse(data.shipmentById!.dateToDeliverShipment!)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          strutStyle: const StrutStyle(
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Text(
                                          intl.DateFormat('hh:mm a', 'ar-EG')
                                              .format(DateTime.parse(data
                                                  .shipmentById!
                                                  .dateToDeliverShipment!)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                          ),
                                          strutStyle: const StrutStyle(
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 4.h),
                                data.shipmentById!.status ==
                                            'courier-applied-to-shipment' ||
                                        data.shipmentById!.status ==
                                            'merchant-accepted-shipping-offer' ||
                                        data.shipmentById!.status ==
                                            'on-the-way-to-get-shipment-from-merchant' ||
                                        data.shipmentById!.status ==
                                            'on-delivery'
                                    ? Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await launchUrlString(
                                                'tel:${data.shipmentById!.clientPhone}',
                                              );
                                            },
                                            child: Container(
                                              height: 30.h,
                                              width: data.shipmentById!
                                                          .paymentMethod ==
                                                      'online'
                                                  ? 50.w
                                                  : 100.w,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffFFE9DF),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Image.asset(
                                                  'assets/images/big_phone_icon.png',
                                                  height: 25.0.h,
                                                  width: 25.0.w),
                                            ),
                                          ),
                                          data.shipmentById!.paymentMethod ==
                                                  'online'
                                              ? SizedBox(
                                                  width: 10.w,
                                                )
                                              : Container(),
                                          data.shipmentById!.paymentMethod ==
                                                  'online'
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    if (data.shipmentById!
                                                                .handoverCodeCourierToCustomer ==
                                                            null &&
                                                        data.shipmentById!
                                                                .handoverQrcodeCourierToCustomer ==
                                                            null) {
                                                      showDialog(
                                                          context: navigator
                                                              .currentContext!,
                                                          builder: (context) =>
                                                              const Loading());
                                                      await trackingProvider
                                                          .refreshHandoverQrCodeCourierToCustomer(data
                                                                      .shipmentById!
                                                                      .parentId! >
                                                                  0
                                                              ? data
                                                                  .shipmentById!
                                                                  .parentId!
                                                              : data
                                                                  .shipmentById!
                                                                  .id!);
                                                      if (trackingProvider
                                                              .state ==
                                                          NetworkState
                                                              .SUCCESS) {
                                                        MagicRouter.pop();
                                                        showDialog(
                                                          context: navigator
                                                              .currentContext!,
                                                          builder: (context) => ShareSaveQrCodeDialog(
                                                              shipmentId: data
                                                                          .shipmentById!
                                                                          .parentId! >
                                                                      0
                                                                  ? data
                                                                      .shipmentById!
                                                                      .parentId!
                                                                  : data
                                                                      .shipmentById!
                                                                      .id!,
                                                              data: trackingProvider
                                                                  .refreshQrcode!),
                                                        );
                                                      } else {
                                                        MagicRouter.pop();
                                                        showDialog(
                                                          context: navigator
                                                              .currentContext!,
                                                          builder: (context) =>
                                                              WalletDialog(
                                                            msg:
                                                                'حدث خطأ برجاء المحاولة مرة اخري',
                                                            onPress: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      log('${data.shipmentById!.handoverQrcodeCourierToCustomer}');
                                                      log('${data.shipmentById!.handoverCodeCourierToCustomer}');
                                                      log(data.shipmentById!
                                                          .handoverQrcodeCourierToCustomer!
                                                          .split('/')
                                                          .last);
                                                      showDialog(
                                                          context: navigator
                                                              .currentContext!,
                                                          builder: (context) => ShareSaveQrCodeDialog(
                                                              shipmentId: data
                                                                          .shipmentById!
                                                                          .parentId! >
                                                                      0
                                                                  ? data
                                                                      .shipmentById!
                                                                      .parentId!
                                                                  : data
                                                                      .shipmentById!
                                                                      .id!,
                                                              data: RefreshQrcode(
                                                                  filename: data
                                                                      .shipmentById!
                                                                      .handoverQrcodeCourierToCustomer!
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  path: data
                                                                      .shipmentById!
                                                                      .handoverQrcodeCourierToCustomer,
                                                                  code: int.parse(
                                                                      data.shipmentById!.handoverCodeCourierToCustomer!))));
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30.h,
                                                    width: 45.w,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffFFE9DF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Image.asset(
                                                      'assets/images/big_qrcode_icon.png',
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        data.shipmentById!.status == 'new' &&
                                data.shipmentById!.parentId == 0
                            ? Expanded(
                                child: WeevoButton(
                                  icon: 'assets/images/product_shipment.png',
                                  isStable: true,
                                  color: weevoPrimaryBlueColor,
                                  onTap: () async {
                                    showDialog(
                                        context: navigator.currentContext!,
                                        barrierDismissible: false,
                                        builder: (_) => const Loading());
                                    shipmentProvider
                                        .setShipmentFromInside(true);
                                    shipmentProvider.setCaptainShipmentId(
                                        data.shipmentById!.id!);
                                    shipmentProvider.setShipmentNotification(
                                        ShipmentNotification(
                                            receivingState: data
                                                .shipmentById!.receivingState,
                                            receivingCity: data
                                                .shipmentById!.receivingCity,
                                            deliveryState: data
                                                .shipmentById!.deliveringState,
                                            deliveryCity: data
                                                .shipmentById!.deliveringCity,
                                            shipmentId: data.shipmentById!.id,
                                            shippingCost: data
                                                .shipmentById!.shippingCost));
                                    await chooseCaptainProvider
                                        .postShipmentToGetOffers(
                                            shipmentId: shipmentProvider
                                                .captainShipmentId!);
                                    if (chooseCaptainProvider.state ==
                                        NetworkState.SUCCESS) {
                                      Navigator.pop(navigator.currentContext!);
                                      shipmentProvider
                                          .setShipmentFromInside(false);
                                      Navigator.pushReplacementNamed(
                                        navigator.currentContext!,
                                        ChooseCourier.id,
                                        arguments: shipmentProvider
                                            .shipmentNotification,
                                      );
                                      shipmentProvider.setIndex(0);
                                      shipmentProvider.shipments.clear();
                                    } else if (chooseCaptainProvider.state ==
                                        NetworkState.LOGOUT) {
                                      Navigator.pop(navigator.currentContext!);
                                      check(
                                          ctx: navigator.currentContext!,
                                          auth: authProvider,
                                          state: chooseCaptainProvider.state!);
                                    } else {
                                      Navigator.pop(navigator.currentContext!);
                                      showDialog(
                                        context: navigator.currentContext!,
                                        builder: (context) => ActionDialog(
                                          content:
                                              'تأكد من الاتصال بشبكة الانترنت',
                                          cancelAction: 'حسناً',
                                          onCancelClick: () {
                                            MagicRouter.pop();
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  title: 'اشحن الاوردر',
                                ),
                              )
                            : Container(),
                        (((data.shipmentById!.status ==
                                            'merchant-accepted-shipping-offer' ||
                                        data.shipmentById!.status ==
                                            'on-the-way-to-get-shipment-from-merchant' ||
                                        data.shipmentById!.status ==
                                            'courier-applied-to-shipment' ||
                                        data.shipmentById!.status ==
                                            'on-delivery') &&
                                    data.shipmentById!.parentId == 0) ||
                                (data.shipmentById!.status == 'on-delivery' &&
                                    data.shipmentById!.parentId! > 0))
                            ? SizedBox(
                                width: 10.0.w,
                              )
                            : Container(),
                        (((data.shipmentById!.status ==
                                            'merchant-accepted-shipping-offer' ||
                                        data.shipmentById!.status ==
                                            'on-the-way-to-get-shipment-from-merchant' ||
                                        data.shipmentById!.status ==
                                            'courier-applied-to-shipment' ||
                                        data.shipmentById!.status ==
                                            'on-delivery') &&
                                    data.shipmentById!.parentId == 0) ||
                                (data.shipmentById!.status == 'on-delivery' &&
                                    data.shipmentById!.parentId! > 0))
                            ? Expanded(
                                child: WeevoButton(
                                  isStable: true,
                                  color: weevoPrimaryOrangeColor,
                                  onTap: () async {
                                    DocumentSnapshot userToken =
                                        await FirebaseFirestore.instance
                                            .collection('courier_users')
                                            .doc(data.shipmentById!.courierId
                                                .toString())
                                            .get();
                                    String courierNationalId =
                                        userToken['national_id'];
                                    Navigator.pushNamed(
                                        navigator.currentContext!, HandleShipment.id,
                                        arguments: ShipmentTrackingModel(
                                            courierNationalId:
                                                courierNationalId,
                                            merchantNationalId:
                                                authProvider.getNationalId,
                                            shipmentId: data.shipmentById!.id,
                                            deliveringState: data
                                                .shipmentById!.deliveringState,
                                            deliveringCity: data
                                                .shipmentById!.deliveringCity,
                                            receivingState: data
                                                .shipmentById!.receivingState,
                                            receivingCity: data
                                                .shipmentById!.receivingCity,
                                            deliveringLat: data
                                                .shipmentById!.deliveringLat,
                                            clientPhone:
                                                data.shipmentById!.clientPhone,
                                            hasChildren:
                                                data.shipmentById!.parentId == 0
                                                    ? 0
                                                    : 1,
                                            status: data.shipmentById!.status,
                                            deliveringLng: data
                                                .shipmentById!.deliveringLng,
                                            receivingLng:
                                                data.shipmentById!.receivingLng,
                                            receivingLat:
                                                data.shipmentById!.receivingLat,
                                            merchantId: data.shipmentById!.merchantId,
                                            merchantImage: authProvider.photo,
                                            merchantPhone: authProvider.phone,
                                            merchantName: authProvider.name,
                                            courierId: data.shipmentById!.courierId,
                                            paymentMethod: data.shipmentById!.paymentMethod,
                                            courierImage: data.shipmentById!.courier!.photo,
                                            courierName: data.shipmentById!.courier!.name,
                                            courierPhone: data.shipmentById!.courier!.phone));
                                  },
                                  title: 'تتبع الشحنة',
                                ),
                              )
                            : Container(),
                        (data.shipmentById!.status == 'available' ||
                                    data.shipmentById!.status == 'new' ||
                                    data.shipmentById!.status ==
                                        'courier-applied-to-shipment' ||
                                    data.shipmentById!.status ==
                                        'merchant-accepted-shipping-offer' ||
                                    data.shipmentById!.status ==
                                        'on-the-way-to-get-shipment-from-merchant') &&
                                data.shipmentById!.parentId == 0
                            ? SizedBox(width: 10.w)
                            : Container(),
                        (data.shipmentById!.status == 'available' ||
                                    data.shipmentById!.status == 'new' ||
                                    data.shipmentById!.status ==
                                        'courier-applied-to-shipment' ||
                                    data.shipmentById!.status ==
                                        'merchant-accepted-shipping-offer' ||
                                    data.shipmentById!.status ==
                                        'on-the-way-to-get-shipment-from-merchant') &&
                                data.shipmentById!.parentId == 0
                            ? Expanded(
                                child: WeevoButton(
                                  isStable: true,
                                  color: Colors.red,
                                  onTap: () async {
                                    if (await authProvider.checkConnection()) {
                                      await cancelShippingCallback(
                                          data, shipmentProvider, authProvider);
                                    } else {
                                      showDialog(
                                        context: navigator.currentContext!,
                                        builder: (ctx) => ActionDialog(
                                          content:
                                              'تأكد من الاتصال بشبكة الانترنت',
                                          cancelAction: 'حسناً',
                                          approveAction: 'حاول مرة اخري',
                                          onApproveClick: () async {
                                            MagicRouter.pop();
                                            await cancelShippingCallback(data,
                                                shipmentProvider, authProvider);
                                          },
                                          onCancelClick: () {
                                            MagicRouter.pop();
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  title: 'الغاء الشحنة',
                                ),
                              )
                            : Container(),
                        if (data.shipmentById!.status == 'available')
                          SizedBox(width: 10.w),
                        if (data.shipmentById!.status == 'available')
                          Expanded(
                            child: WeevoButton(
                              isStable: true,
                              color: weevoPrimaryBlueColor,
                              onTap: () async {
                                if (await authProvider.checkConnection()) {
                                  showDialog(
                                      context: navigator.currentContext!,
                                      builder: (_) => ShipmentRaiseDialog(
                                            shipmentId: data.shipmentById!.id!,
                                            currentValue: data
                                                .shipmentById!.shippingCost!,
                                          ));
                                } else {
                                  showDialog(
                                    context: navigator.currentContext!,
                                    builder: (ctx) => ActionDialog(
                                      content: 'تأكد من الاتصال بشبكة الانترنت',
                                      cancelAction: 'حسناً',
                                      approveAction: 'حاول مرة اخري',
                                      onApproveClick: () async {
                                        MagicRouter.pop();
                                        await cancelShippingCallback(data,
                                            shipmentProvider, authProvider);
                                      },
                                      onCancelClick: () {
                                        MagicRouter.pop();
                                      },
                                    ),
                                  );
                                }
                              },
                              title: 'رفع سعر الشحن',
                            ),
                          ),
                        data.shipmentById!.status == 'cancelled' &&
                                data.shipmentById!.parentId == 0
                            ? SizedBox(width: 10.w)
                            : Container(),
                        data.shipmentById!.status == 'cancelled' &&
                                data.shipmentById!.parentId == 0
                            ? Expanded(
                                child: WeevoButton(
                                  isStable: true,
                                  color: weevoPrimaryOrangeColor,
                                  onTap: () async {
                                    await shipmentProvider
                                        .restoreCancelShipment(
                                            shipmentId: data.shipmentById!.id!);
                                    if (shipmentProvider.restoreShipmentState ==
                                        NetworkState.SUCCESS) {
                                      MagicRouter.pop();
                                    } else if (shipmentProvider
                                            .restoreShipmentState ==
                                        NetworkState.LOGOUT) {
                                      check(
                                          auth: _authProvider,
                                          state: shipmentProvider
                                              .restoreShipmentState!,
                                          ctx: navigator.currentContext!);
                                    }
                                  },
                                  title: 'أضافة الشحنة',
                                ),
                              )
                            : Container(),
                        data.shipmentById!.status == 'new'
                            ? SizedBox(width: 10.w)
                            : Container(),
                        data.shipmentById!.status == 'new'
                            ? Expanded(
                                child: WeevoButton(
                                  isStable: true,
                                  color: weevoPrimaryOrangeColor,
                                  onTap: () {
                                    shipmentProvider
                                        .setShipmentFromWhere(oneShipment);
                                    shipmentProvider
                                        .setIsUpdatedFromServer(true);
                                    shipmentProvider.setDataFromServer(
                                      model: data.shipmentById!,
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AddShipment.id,
                                    );
                                  },
                                  title: 'تعديل الشحنة',
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createDynamicLink(int shipmentId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://weevoapp.page.link',
      link: Uri.parse('https://weevo.net/$shipmentId'),
      androidParameters: const AndroidParameters(
        packageName: 'org.emarketingo.courier',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'org.emarketingo.courier',
        minimumVersion: "0",
      ),
    );

    Uri url = parameters.link;
    if (mounted) {
      setState(() {
        shareLink = url.toString();
      });
    }
  }

  Future<void> cancelShippingCallback(
      DisplayShipmentProvider data,
      AddShipmentProvider addShipmentProvider,
      AuthProvider authProvider) async {
    showDialog(
        context: navigator.currentContext!,
        barrierDismissible: false,
        builder: (_) => CancelShipmentDialog(onOkPressed: () async {
              String status = data.shipmentById!.status!;
              Navigator.pop(navigator.currentContext!);
              showDialog(
                  context: navigator.currentContext!,
                  barrierDismissible: false,
                  builder: (_) => const Loading());
              await addShipmentProvider.cancelShipment(
                  shipmentId: data.shipmentById!.id!);
              if (addShipmentProvider.cancelShipmentState ==
                  NetworkState.SUCCESS) {
                Navigator.pop(navigator.currentContext!);
                // await showDialog(
                //     navigator.currentContext!,
                //     barrierDismissible: false,
                //     builder: (context) =>
                //         ActionDialog(
                //           content: addShipmentProvider.cancelMessage,
                //           onApproveClick: () {
                //       magicRouter.pop();                //           },
                //           approveAction: 'حسناً',
                //         ));
                showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (_) => const Loading());
                if (status != 'available' && status != 'new') {
                  DocumentSnapshot userToken = await FirebaseFirestore.instance
                      .collection('courier_users')
                      .doc(data.shipmentById!.courierId.toString())
                      .get();
                  String token = userToken['fcmToken'];
                  FirebaseFirestore.instance
                      .collection('courier_notifications')
                      .doc(data.shipmentById!.courierId.toString())
                      .collection(data.shipmentById!.courierId.toString())
                      .add({
                    'read': false,
                    'date_time': DateTime.now().toIso8601String(),
                    'type': 'cancel_shipment',
                    'title': 'تم إلغاء الشحنة',
                    'body':
                        'قام التاجر ${authProvider.name} بالغاء الشحنة يمكنك الذهاب للشحنات المتاحة والتقديم علي شحنات اخري',
                    'user_icon': authProvider.photo!.isNotEmpty
                        ? authProvider.photo!.contains(ApiConstants.baseUrl)
                            ? authProvider.photo
                            : '${ApiConstants.baseUrl}${authProvider.photo}'
                        : '',
                    'screen_to': 'no_screen',
                    'data': {
                      'shipment_id': data.shipmentById!.id,
                    },
                  });
                   Provider.of<AuthProvider>(navigator.currentContext!, listen: false)
                      .sendNotification(
                    title: 'تم إلغاء الشحنة',
                    body:
                        'قام التاجر ${authProvider.name} بالغاء الشحنة يمكنك الذهاب للشحنات المتاحة والتقديم علي شحنات اخري',
                    image: authProvider.photo!.isNotEmpty
                        ? authProvider.photo!.contains(ApiConstants.baseUrl)
                            ? authProvider.photo
                            : '${ApiConstants.baseUrl}${authProvider.photo}'
                        : '',
                    screenTo: 'no_screen',
                    type: 'cancel_shipment',
                    data: {
                      'shipment_id': data.shipmentById!.id,
                    },
                    toToken: token,
                  );
                }
                if (data.shipmentById!.courier != null) {
                  String merchantPhoneNumber =
                      Preferences.instance.getPhoneNumber;
                  String courierPhoneNumber = data.shipmentById!.courier!.phone!;

                  String locationId =
                      '$courierPhoneNumber-$merchantPhoneNumber-${data.shipmentById!.id}';
                  FirebaseFirestore.instance
                      .collection('locations')
                      .doc(locationId)
                      .set(
                    {
                      'status': 'closed',
                      'shipmentId': '${data.shipmentById!.id}',
                    },
                  );
                }
                Navigator.pop(navigator.currentContext!);
                Navigator.pop(navigator.currentContext!);
              } else if (addShipmentProvider.cancelShipmentState ==
                  NetworkState.LOGOUT) {
                MagicRouter.pop();
                check(
                    auth: _authProvider,
                    state: addShipmentProvider.cancelShipmentState!,
                    ctx: navigator.currentContext!);
              } else if (addShipmentProvider.cancelShipmentState ==
                  NetworkState.ERROR) {
                MagicRouter.pop();
                showDialog(context:navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                          content: 'حدث خطأ من فضلك حاول مرة اخري',
                          cancelAction: 'حسناً',
                          onCancelClick: () {
                            MagicRouter.pop();
                          },
                        ));
              }
            }, onCancelPressed: () {
              MagicRouter.pop();
            }));
  }
}
