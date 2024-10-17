import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/Dialogs/loading.dart';
import '../../../../core/Dialogs/qr_dialog_code.dart';
import '../../../../core/Dialogs/share_save_qr_code_dialog.dart';
import '../../../../core/Dialogs/tracking_dialog.dart';
import '../../../../core/Dialogs/wallet_dialog.dart';
import '../../../../core/Models/refresh_qr_code.dart';
import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_loading_indicator.dart';
import '../../../Screens/home.dart';
import '../../../wasully_details/logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_handle_shipment_cubit.dart';
import '../../logic/cubit/wasully_handle_shipment_state.dart';
import '../widgets/wasully_courier_to_merchant_qr_code_dialog.dart';

class WasullyHandleShipmentScreen extends StatefulWidget {
  final ShipmentTrackingModel model;
  const WasullyHandleShipmentScreen({
    super.key,
    required this.model,
  });

  @override
  State<WasullyHandleShipmentScreen> createState() =>
      _WasullyHandleShipmentScreenState();
}

class _WasullyHandleShipmentScreenState
    extends State<WasullyHandleShipmentScreen> {
  String? _locationId;
  String? status;
  final Preferences _pref = Preferences.instance;

  @override
  void initState() {
    super.initState();
    if (widget.model.merchantNationalId.hashCode >=
        widget.model.courierNationalId.hashCode) {
      _locationId =
          '${widget.model.merchantNationalId}-${widget.model.courierNationalId}-${widget.model.shipmentId}';
    } else {
      _locationId =
          '${widget.model.courierNationalId}-${widget.model.merchantNationalId}-${widget.model.shipmentId}';
    }
    log('location id $_locationId');
    context
        .read<WasullyHandleShipmentCubit>()
        .listenToShipmentStatus(_locationId!, widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    final authProvider = Provider.of<AuthProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (authProvider.fromOutsideNotification) {
          authProvider.setFromOutsideNotification(false);
          MagicRouter.navigateAndPop(const Home());
        } else {
          MagicRouter.pop();
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                if (authProvider.fromOutsideNotification) {
                  authProvider.setFromOutsideNotification(false);
                  MagicRouter.navigateAndPop(const Home());
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
                  'طلب رقم ${widget.model.shipmentId}',
                  style: const TextStyle(
                    color: weevoPrimaryOrangeColor,
                  ),
                ),
              ],
            ),
          ),
          body: BlocConsumer<WasullyHandleShipmentCubit,
              WasullyHandleShipmentState>(
            listener: (context, state) {
              if (state is WasullyHandleShipmentRefreshQrCodeStateSuccess) {
                MagicRouter.pop();
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => QrCodeDialog(
                    data: state.qrCode,
                  ),
                );
              }
              if (state is WasullyHandleShipmentRefreshQrCodeStateError) {
                MagicRouter.pop();
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
            },
            builder: (context, state) {
              final handleShipmentCubit =
                  context.read<WasullyHandleShipmentCubit>();
              log('Status : $status');
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('locations')
                      .doc(_locationId)
                      .snapshots(),
                  builder: (BuildContext ctx,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      status = snapshot.data!['status'];
                      log('status: $status');
                      log('locationId: $_locationId');
                    }
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CustomLoadingIndicator(),
                          )
                        : snapshot.hasData && snapshot.data!.exists
                            ? Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      status == 'receivingShipment'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      'برجاء الضغط علي الزر الأزرق لارسال رمز\nال qrcode للكابتن لتأكيد تسليم الطلب للكابتن',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.0),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    verticalSpace(10),
                                                    FloatingActionButton(
                                                      onPressed: () async {
                                                        if (cubit.wasullyModel ==
                                                                null ||
                                                            (cubit.wasullyModel
                                                                        ?.handoverCodeMerchantToCourier ==
                                                                    null &&
                                                                cubit.wasullyModel
                                                                        ?.handoverQrcodeMerchantToCourier ==
                                                                    null)) {
                                                          showDialog(
                                                              context: navigator
                                                                  .currentContext!,
                                                              builder: (context) =>
                                                                  const LoadingDialog());
                                                          await handleShipmentCubit
                                                              .refreshHandoverQrCodeMerchantToCourier(
                                                            widget.model
                                                                .shipmentId!,
                                                          );
                                                        } else {
                                                          showDialog(
                                                            context: navigator
                                                                .currentContext!,
                                                            builder: (context) =>
                                                                QrCodeDialog(
                                                              data:
                                                                  RefreshQrcode(
                                                                filename: cubit
                                                                    .wasullyModel!
                                                                    .handoverQrcodeMerchantToCourier!
                                                                    .split('/')
                                                                    .last,
                                                                path: cubit
                                                                    .wasullyModel!
                                                                    .handoverQrcodeMerchantToCourier,
                                                                code: int.parse(
                                                                  cubit
                                                                      .wasullyModel!
                                                                      .handoverCodeMerchantToCourier!,
                                                                ),
                                                              ),
                                                            ),
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
                                                  ],
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
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text(
                                                          'برجاء الضغط علي الزر الأزرق لارسال رمز\nال qrcode للمستلم لتأكيد استلام الطلب من الكابتن',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14.0),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        verticalSpace(10),
                                                        FloatingActionButton(
                                                          onPressed: () async {
                                                            _pref.setShareFirstTime(
                                                                widget.model
                                                                    .shipmentId
                                                                    .toString(),
                                                                1);
                                                            if (cubit.wasullyModel ==
                                                                    null ||
                                                                (cubit.wasullyModel!
                                                                            .handoverQrcodeCourierToCustomer ==
                                                                        null &&
                                                                    cubit.wasullyModel!
                                                                            .handoverCodeCourierToCustomer ==
                                                                        null)) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          const LoadingDialog());
                                                              await handleShipmentCubit
                                                                  .refreshHandoverQrCodeCourierToCustomer(
                                                                      widget
                                                                          .model
                                                                          .shipmentId!);
                                                            } else {
                                                              log('${cubit.wasullyModel!.handoverQrcodeCourierToCustomer}');
                                                              log('${cubit.wasullyModel!.handoverCodeCourierToCustomer}');
                                                              log(cubit
                                                                  .wasullyModel!
                                                                  .handoverQrcodeCourierToCustomer!
                                                                  .split('/')
                                                                  .last);
                                                              showDialog(
                                                                context: navigator
                                                                    .currentContext!,
                                                                builder:
                                                                    (context) =>
                                                                        ShareSaveQrCodeDialog(
                                                                  shipmentId: cubit
                                                                      .wasullyModel!
                                                                      .id,
                                                                  data:
                                                                      RefreshQrcode(
                                                                    filename: cubit
                                                                        .wasullyModel!
                                                                        .handoverQrcodeCourierToCustomer!
                                                                        .split(
                                                                            '/')
                                                                        .last,
                                                                    path: cubit
                                                                        .wasullyModel!
                                                                        .handoverQrcodeCourierToCustomer,
                                                                    code: int.parse(cubit
                                                                        .wasullyModel!
                                                                        .handoverCodeCourierToCustomer!),
                                                                  ),
                                                                ),
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
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : status ==
                                                      'handingOverReturnedShipmentToMerchant'
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                              'برجاء الضغط على الزر الأزرق لإدخال الكود\n وبعد التحقق سيتم إستلام الطلب من الكابتن',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      14.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            verticalSpace(10),
                                                            FloatingActionButton(
                                                              onPressed:
                                                                  () async {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        true,
                                                                    builder: (ctx) => WasullyCourierToMerchantQrCodeDialog(
                                                                        model: widget
                                                                            .model,
                                                                        locationId:
                                                                            _locationId!));
                                                              },
                                                              backgroundColor:
                                                                  weevoPrimaryBlueColor,
                                                              child: const Icon(
                                                                Icons.qr_code,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      TrackingDialog(
                                        model: widget.model,
                                        isWasully: true,
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
                  });
            },
          )),
    );
  }
}
