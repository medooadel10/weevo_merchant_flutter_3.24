import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/Dialogs/done_dialog.dart';
import '../../../../core/Dialogs/loading_dialog.dart';
import '../../../../core/Dialogs/qr_code_scanner.dart';
import '../../../../core/Dialogs/wallet_dialog.dart';
import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../logic/cubit/wasully_handle_shipment_cubit.dart';
import '../../logic/cubit/wasully_handle_shipment_state.dart';
import 'wasully_rating_dialog.dart';

class WasullyCourierToMerchantQrCodeDialog extends StatelessWidget {
  final ShipmentTrackingModel model;
  final String locationId;

  const WasullyCourierToMerchantQrCodeDialog({
    super.key,
    required this.model,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final WasullyHandleShipmentCubit cubit = context.read();
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
            'عشان تستلم الطلب \nلازم تعمل مسح لرمز ال Qrcode \nاو تكتب الكود اللي عند الكابتن',
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
                builder: (c) => QrCodeScanner(
                  onDataCallback: (String v) async {
                    if (v.isNotEmpty) {
                      Navigator.pop(c);
                      showDialog(
                          context: c,
                          builder: (c) => BlocConsumer<
                                  WasullyHandleShipmentCubit,
                                  WasullyHandleShipmentState>(
                                listener: (context, state) async {
                                  if (state
                                      is WasullyHandleShipmentHandleReturnedShipmentStateSuccess) {
                                    DocumentSnapshot userToken =
                                        await FirebaseFirestore.instance
                                            .collection('courier_users')
                                            .doc(model.courierId.toString())
                                            .get();
                                    String token = userToken['fcmToken'];
                                    log('FCM TOKEN CR: $token');
                                    authProvider.sendNotification(
                                        title: 'تم ارتجاع طلبك بنجاح',
                                        body:
                                            'تم ارتجاع طلبك بنجاح برجاء تقييم طلبك مع التاجر ${authProvider.name}',
                                        toToken: token,
                                        image: authProvider.photo != null &&
                                                authProvider.photo!.isNotEmpty
                                            ? authProvider.photo
                                            : '',
                                        type: 'wasully_rating',
                                        screenTo: '',
                                        data: model.toJson());
                                    if (model.wasullyModel!.courier != null) {
                                      String? merchantPhoneNumber =
                                          Preferences.instance.getPhoneNumber;
                                      String? courierPhoneNumber =
                                          model.wasullyModel?.courier?.phone;

                                      String locationId = '';
                                      if (merchantPhoneNumber.hashCode >=
                                          courierPhoneNumber.hashCode) {
                                        locationId =
                                            '$merchantPhoneNumber-$courierPhoneNumber-${model.wasullyModel?.id}';
                                      } else {
                                        locationId =
                                            '$courierPhoneNumber-$merchantPhoneNumber-${model.wasullyModel?.id}';
                                      }

                                      FirebaseFirestore.instance
                                          .collection('locations')
                                          .doc(locationId)
                                          .set(
                                        {
                                          'status': 'closed',
                                          'shipmentId':
                                              model.wasullyModel!.slug,
                                        },
                                      );
                                    }
                                    MagicRouter.pop();
                                    await showDialog(
                                        context: navigator.currentContext!,
                                        builder: (c) => DoneDialog(
                                              content: 'تم ارتجاع طلبك بنجاح',
                                              onDoneCallback: () {
                                                MagicRouter.pop();
                                              },
                                            ));
                                    MagicRouter.navigateAndPopAll(
                                        WasullyRatingDialog(model: model));
                                  }
                                  if (state
                                      is WasullyHandleShipmentHandleReturnedShipmentStateError) {
                                    MagicRouter.pop();
                                    showDialog(
                                      context: navigator.currentContext!,
                                      builder: (context) => WalletDialog(
                                        msg: state.error,
                                        onPress: () {
                                          MagicRouter.pop();
                                        },
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return const LoadingDialog();
                                },
                              ));
                      await cubit
                          .handleReturnedShipmentByValidatingHandoverQrCodeCourierToMerchant(
                        model.shipmentId!,
                        int.parse(v),
                        locationId,
                      );
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
