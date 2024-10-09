import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/router/router.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/api_constants.dart';

import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_tracking_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import 'done_dialog.dart';
import 'loading.dart';
import 'qr_code_scanner.dart';
import 'rating_dialog.dart';
import 'wallet_dialog.dart';

class CourierToMerchantQrCodeScanner extends StatelessWidget {
  final ShipmentTrackingModel model;
  final BuildContext parentContext;
  final String locationId;

  const CourierToMerchantQrCodeScanner({
    super.key,
    required this.parentContext,
    required this.model,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    final ShipmentTrackingProvider trackingProvider =
        Provider.of<ShipmentTrackingProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/weevo_scan_qr_code.gif'),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            model.wasullyModel != null
                ? 'عشان تستلم الطلب \nلازم تعمل مسح لرمز ال Qrcode \nاو تكتب الكود اللي عند الكابتن'
                : 'عشان تستلم الشحنة \nلازم تعمل مسح لرمز ال Qrcode \nاو تكتب الكود اللي عند الكابتن',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
              height: 1.21,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              MagicRouter.pop();
              showDialog(
                context: navigator.currentContext!,
                barrierDismissible: false,
                builder: (c) => QrCodeScanner(
                  onDataCallback: (String v) async {
                    if (v.isNotEmpty) {
                      Navigator.pop(c);
                      showDialog(context: c, builder: (c) => Loading());
                      await trackingProvider
                          .handleReturnedShipmentByValidatingHandoverQrCodeCourierToMerchant(
                              model.shipmentId!, int.parse(v));
                      if (trackingProvider.state == NetworkState.SUCCESS) {
                        FirebaseFirestore.instance
                            .collection('locations')
                            .doc(locationId)
                            .update(
                          {
                            'status': 'closed',
                            'shipmentId': '${model.shipmentId}'
                          },
                        );
                        DocumentSnapshot userToken = await FirebaseFirestore
                            .instance
                            .collection('merchant_users')
                            .doc(model.merchantId.toString())
                            .get();
                        String token = userToken['fcmToken'];
                        authProvider.sendNotification(
                            title: model.wasullyModel != null
                                ? 'تم ارتجاع طلبك بنجاح'
                                : 'تم ارتجاع شحنتك بنجاح',
                            body: model.wasullyModel != null
                                ? 'تم ارتجاع طلبك بنجاح برجاء تقييم طلبك مع التاجر ${authProvider.name}'
                                : 'تم ارتجاع شحنتك بنجاح برجاء تقييم شحنتك مع التاجر ${authProvider.name}',
                            toToken: token,
                            image: authProvider.photo != null &&
                                    authProvider.photo!.isNotEmpty
                                ? authProvider.photo!
                                        .contains(ApiConstants.baseUrl)
                                    ? authProvider.photo
                                    : '${ApiConstants.baseUrl}${authProvider.photo}'
                                : '',
                            type: 'rating',
                            screenTo: '',
                            data: model.toJson());
                        if (model.courierPhone != null) {
                          String merchantPhoneNumber =
                              Preferences.instance.getPhoneNumber;
                          String courierPhoneNumber = model.courierPhone ?? '';
                          String locationId =
                              '$courierPhoneNumber-$merchantPhoneNumber-${model.shipmentId}';
                          FirebaseFirestore.instance
                              .collection('locations')
                              .doc(locationId)
                              .set(
                            {
                              'status': 'closed',
                              'shipmentId': '${model.shipmentId}'
                            },
                          );
                        }
                        MagicRouter.pop();
                        await showDialog(
                            context: navigator.currentContext!,
                            builder: (c) => DoneDialog(
                                  content: model.wasullyModel != null
                                      ? 'تم ارتجاع طلبك بنجاح'
                                      : 'تم ارتجاع شحنتك بنجاح',
                                  onDoneCallback: () {
                                    MagicRouter.pop();
                                  },
                                ));
                        MagicRouter.navigateAndPopAll(RatingDialog(
                          model: model,
                        ));
                      } else {
                        MagicRouter.pop();
                        if (trackingProvider.ctmQrCodeError) {
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (context) => WalletDialog(
                              msg:
                                  'الكود الذي أدخلته غبي صحيح\nيرجي التأكد من الكود\nوأعادة المحاولة مرة آخري',
                              onPress: () {
                                MagicRouter.pop();
                              },
                            ),
                          );
                        } else {
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (context) => WalletDialog(
                              msg: 'حدث خطأ برجاء المحاولة مرة اخري',
                              onPress: () {
                                MagicRouter.pop();
                              },
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
              );
            },
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
