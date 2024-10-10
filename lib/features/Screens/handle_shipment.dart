import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/courier_to_merchant_qr_code_dialog.dart';
import '../../core/Dialogs/loading.dart';
import '../../core/Dialogs/qr_dialog_code.dart';
import '../../core/Dialogs/share_save_qr_code_dialog.dart';
import '../../core/Dialogs/tracking_dialog.dart';
import '../../core/Dialogs/wallet_dialog.dart';
import '../../core/Models/refresh_qr_code.dart';
import '../../core/Models/shipment_tracking_model.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/display_shipment_provider.dart';
import '../../core/Providers/shipment_tracking_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import 'home.dart';

class HandleShipment extends StatefulWidget {
  static const String id = 'Handle_shipment';
  final ShipmentTrackingModel model;

  const HandleShipment({
    super.key,
    required this.model,
  });

  @override
  State<HandleShipment> createState() => _HandleShipmentState();
}

class _HandleShipmentState extends State<HandleShipment> {
  String? _locationId;
  String? status;
  final Preferences _pref = Preferences.instance;

  @override
  void initState() {
    super.initState();
    _locationId =
        '${widget.model.courierNationalId}-${widget.model.merchantNationalId}-${widget.model.shipmentId}';
  }

  @override
  Widget build(BuildContext context) {
    final ShipmentTrackingProvider shipmentTrackingProvider =
        Provider.of<ShipmentTrackingProvider>(context);
    DisplayShipmentProvider displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (authProvider.fromOutsideNotification) {
          authProvider.setFromOutsideNotification(false);
          Navigator.pushReplacementNamed(context, Home.id);
        } else {
          MagicRouter.pop();
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                if (authProvider.fromOutsideNotification) {
                  authProvider.setFromOutsideNotification(false);
                  Navigator.pushReplacementNamed(context, Home.id);
                } else {
                  MagicRouter.pop();
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.model.wasullyModel != null
                      ? 'طلب رقم ${widget.model.shipmentId}'
                      : 'شحنة رقم ${widget.model.shipmentId}',
                  style: const TextStyle(
                    color: weevoPrimaryOrangeColor,
                  ),
                ),
              ],
            ),
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('locations')
                  .doc(_locationId)
                  .snapshots(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  status = snapshot.data!['status'];
                }
                log('status: $status');
                return snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              weevoPrimaryOrangeColor),
                        ),
                      )
                    : snapshot.hasData && snapshot.data!.exists
                        ? Column(
                            children: [
                              (widget.model.paymentMethod == 'online' &&
                                      status == 'receivedShipment' &&
                                      _pref.getWeevoShareFirstTime(widget
                                              .model.shipmentId
                                              .toString()) ==
                                          -1)
                                  ? Container(
                                      margin: const EdgeInsets.all(20.0),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            widget.model.wasullyModel != null
                                                ? 'برجاء الضغط علي الزر الأزرق لارسال رمز\nال qrcode للمستلم لتأكيد استلام الطلب من الكابتن'
                                                : 'برجاء الضغط علي الزر الأزرق لارسال رمز\nال qrcode للمستلم لتأكيد استلام الشحنة من الكابتن',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: weevoPrimaryBlueColor,
                                              shape: BoxShape.circle,
                                            ),
                                            height: 50.0,
                                            width: 50.0,
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Icon(
                                              Icons.qr_code,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  status == 'receivingShipment'
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FloatingActionButton(
                                            onPressed: () async {
                                              if (displayShipmentProvider
                                                          .shipmentById ==
                                                      null ||
                                                  (displayShipmentProvider
                                                              .shipmentById!
                                                              .handoverCodeMerchantToCourier ==
                                                          null &&
                                                      displayShipmentProvider
                                                              .shipmentById!
                                                              .handoverQrcodeMerchantToCourier ==
                                                          null)) {
                                                showDialog(
                                                    context: navigator
                                                        .currentContext!,
                                                    builder: (context) =>
                                                        const LoadingDialog());
                                                await shipmentTrackingProvider
                                                    .refreshHandoverQrCodeMerchantToCourier(
                                                        widget
                                                            .model.shipmentId!);
                                                if (shipmentTrackingProvider
                                                        .state ==
                                                    NetworkState.SUCCESS) {
                                                  MagicRouter.pop();
                                                  showDialog(
                                                    context: navigator
                                                        .currentContext!,
                                                    builder: (context) =>
                                                        QrCodeDialog(
                                                            data: shipmentTrackingProvider
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
                                                        MagicRouter.pop();
                                                      },
                                                    ),
                                                  );
                                                }
                                              } else {
                                                showDialog(
                                                  context:
                                                      navigator.currentContext!,
                                                  builder: (context) => QrCodeDialog(
                                                      data: RefreshQrcode(
                                                          filename:
                                                              displayShipmentProvider
                                                                  .shipmentById!
                                                                  .handoverQrcodeMerchantToCourier!
                                                                  .split('/')
                                                                  .last,
                                                          path: displayShipmentProvider
                                                              .shipmentById!
                                                              .handoverQrcodeMerchantToCourier,
                                                          code: int.parse(
                                                              displayShipmentProvider
                                                                  .shipmentById!
                                                                  .handoverCodeMerchantToCourier!))),
                                                );
                                              }
                                            },
                                            backgroundColor:
                                                weevoPrimaryBlueColor,
                                            child: const Icon(
                                              Icons.qr_code,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : (status == 'receivedShipment' ||
                                                  status ==
                                                      'handingOverShipmentToCustomer') &&
                                              widget.model.paymentMethod ==
                                                  'online'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FloatingActionButton(
                                                onPressed: () async {
                                                  _pref.setShareFirstTime(
                                                      widget.model.shipmentId
                                                          .toString(),
                                                      1);
                                                  if (displayShipmentProvider
                                                              .shipmentById ==
                                                          null ||
                                                      (displayShipmentProvider
                                                                  .shipmentById!
                                                                  .handoverQrcodeCourierToCustomer ==
                                                              null &&
                                                          displayShipmentProvider
                                                                  .shipmentById!
                                                                  .handoverCodeCourierToCustomer ==
                                                              null)) {
                                                    showDialog(
                                                        context: navigator
                                                            .currentContext!,
                                                        builder: (context) =>
                                                            const LoadingDialog());
                                                    await shipmentTrackingProvider
                                                        .refreshHandoverQrCodeCourierToCustomer(
                                                            widget.model
                                                                .shipmentId!);
                                                    if (shipmentTrackingProvider
                                                            .state ==
                                                        NetworkState.SUCCESS) {
                                                      MagicRouter.pop();
                                                      showDialog(
                                                        context: navigator
                                                            .currentContext!,
                                                        builder: (context) =>
                                                            ShareSaveQrCodeDialog(
                                                                shipmentId: widget
                                                                    .model
                                                                    .shipmentId!,
                                                                data: shipmentTrackingProvider
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
                                                    log('${displayShipmentProvider.shipmentById!.handoverQrcodeCourierToCustomer}');
                                                    log('${displayShipmentProvider.shipmentById!.handoverCodeCourierToCustomer}');
                                                    log(displayShipmentProvider
                                                        .shipmentById!
                                                        .handoverQrcodeCourierToCustomer!
                                                        .split('/')
                                                        .last);
                                                    showDialog(
                                                        context: navigator
                                                            .currentContext!,
                                                        builder: (context) => ShareSaveQrCodeDialog(
                                                            shipmentId: displayShipmentProvider
                                                                        .shipmentById!
                                                                        .parentId! >
                                                                    0
                                                                ? displayShipmentProvider
                                                                    .shipmentById!
                                                                    .parentId!
                                                                : displayShipmentProvider
                                                                    .shipmentById!
                                                                    .id!,
                                                            data: RefreshQrcode(
                                                                filename: displayShipmentProvider
                                                                    .shipmentById!
                                                                    .handoverQrcodeCourierToCustomer!
                                                                    .split('/')
                                                                    .last,
                                                                path: displayShipmentProvider
                                                                    .shipmentById!
                                                                    .handoverQrcodeCourierToCustomer,
                                                                code: int.parse(
                                                                    displayShipmentProvider.shipmentById!.handoverCodeCourierToCustomer!))));
                                                  }
                                                },
                                                backgroundColor:
                                                    weevoPrimaryBlueColor,
                                                child: const Icon(
                                                  Icons.qr_code,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : status ==
                                                  'handingOverReturnedShipmentToMerchant'
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FloatingActionButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                          context: navigator
                                                              .currentContext!,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (ctx) =>
                                                              CourierToMerchantQrCodeScanner(
                                                                  parentContext:
                                                                      context,
                                                                  model: widget
                                                                      .model,
                                                                  locationId:
                                                                      _locationId!));
                                                    },
                                                    backgroundColor:
                                                        weevoPrimaryBlueColor,
                                                    child: const Icon(
                                                      Icons.qr_code,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  TrackingDialog(
                                    model: widget.model,
                                  ),
                                ],
                              )
                            ],
                          )
                        : const Center(
                            child: Text(
                              'لم يبدأ الكابتن التوصيل بعد',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
              })),
    );
  }
}
