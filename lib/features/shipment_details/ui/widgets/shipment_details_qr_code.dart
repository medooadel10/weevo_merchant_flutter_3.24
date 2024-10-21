import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core/Dialogs/courier_to_merchant_qr_code_dialog.dart';
import '../../../../core/Dialogs/loading_dialog.dart';
import '../../../../core/Dialogs/qr_dialog_code.dart';
import '../../../../core/Dialogs/share_save_qr_code_dialog.dart';
import '../../../../core/Models/refresh_qr_code.dart';
import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../../../../core_new/router/router.dart';

class ShipmentDetailsQrCode extends StatelessWidget {
  final String locationId;
  final String status;
  final String courierNationalId;
  final String merchantNationalId;
  const ShipmentDetailsQrCode(
      {super.key,
      required this.locationId,
      required this.status,
      required this.courierNationalId,
      required this.merchantNationalId});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    Preferences pref = Preferences.instance;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (status == 'receivingShipment' ||
        status == 'handingOverShipmentToCustomer' ||
        status == 'receivedShipment' ||
        status == 'handingOverReturnedShipmentToMerchant') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            if (status == 'receivingShipment') {
              if (cubit.shipmentDetails == null ||
                  (cubit.shipmentDetails!.handoverCodeMerchantToCourier ==
                          null &&
                      cubit.shipmentDetails!.handoverQrcodeMerchantToCourier ==
                          null)) {
                showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => const LoadingDialog());
                await refreshHandoverQrCodeMerchantToCourier(
                    cubit.shipmentDetails!.id);
                MagicRouter.pop();
              } else {
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => QrCodeDialog(
                    data: RefreshQrcode(
                      filename: cubit
                          .shipmentDetails!.handoverQrcodeMerchantToCourier!
                          .split('/')
                          .last,
                      path: cubit
                          .shipmentDetails!.handoverQrcodeMerchantToCourier,
                      code: int.parse(
                        cubit.shipmentDetails!.handoverCodeMerchantToCourier!,
                      ),
                    ),
                  ),
                );
              }
            } else if (status == 'receivedShipment' ||
                status == 'handingOverShipmentToCustomer') {
              pref.setShareFirstTime(cubit.shipmentDetails!.id.toString(), 1);
              if (cubit.shipmentDetails == null ||
                  (cubit.shipmentDetails!.handoverQrcodeCourierToCustomer ==
                          null &&
                      cubit.shipmentDetails!.handoverCodeCourierToCustomer ==
                          null)) {
                showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => const LoadingDialog());
                await refreshHandoverQrCodeCourierToCustomer(
                    cubit.shipmentDetails!.id);
                MagicRouter.pop();
              } else {
                log('${cubit.shipmentDetails!.handoverQrcodeCourierToCustomer}');
                log('${cubit.shipmentDetails!.handoverCodeCourierToCustomer}');
                log(cubit.shipmentDetails!.handoverQrcodeCourierToCustomer!
                    .split('/')
                    .last);
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => ShareSaveQrCodeDialog(
                    shipmentId: cubit.shipmentDetails!.id,
                    data: RefreshQrcode(
                      filename: cubit
                          .shipmentDetails!.handoverQrcodeCourierToCustomer!
                          .split('/')
                          .last,
                      path: cubit
                          .shipmentDetails!.handoverQrcodeCourierToCustomer,
                      code: int.parse(cubit
                          .shipmentDetails!.handoverCodeCourierToCustomer!),
                    ),
                  ),
                );
              }
            } else if (status == 'handingOverReturnedShipmentToMerchant') {
              showDialog(
                context: navigator.currentContext!,
                builder: (ctx) => CourierToMerchantQrCodeScanner(
                  parentContext: navigator.currentContext!,
                  model: ShipmentTrackingModel(
                    courierNationalId: courierNationalId,
                    merchantNationalId: merchantNationalId,
                    shipmentId: cubit.shipmentDetails!.id,
                    deliveringState:
                        cubit.shipmentDetails!.deliveringState.toString(),
                    deliveringCity:
                        cubit.shipmentDetails!.deliveringCity.toString(),
                    receivingState:
                        cubit.shipmentDetails!.receivingState.toString(),
                    receivingCity:
                        cubit.shipmentDetails!.receivingCity.toString(),
                    deliveringLat: cubit.shipmentDetails!.deliveringLat,
                    clientPhone: cubit.shipmentDetails!.clientPhone,
                    hasChildren: 0,
                    status: cubit.shipmentDetails!.status,
                    deliveringLng: cubit.shipmentDetails!.deliveringLng,
                    receivingLng: cubit.shipmentDetails!.receivingLng,
                    receivingLat: cubit.shipmentDetails!.receivingLat,
                    merchantId: cubit.shipmentDetails!.merchantId,
                    merchantImage: authProvider.photo,
                    merchantPhone: authProvider.phone,
                    merchantName: authProvider.name,
                    courierId: cubit.shipmentDetails!.courierId,
                    paymentMethod: cubit.shipmentDetails!.paymentMethod,
                    courierImage: cubit.shipmentDetails!.courier?.photo,
                    courierName: cubit.shipmentDetails!.courier?.name,
                    courierPhone: cubit.shipmentDetails!.courier?.phone,
                    deliveringStreet: cubit.shipmentDetails!.deliveringStreet,
                    receivingStreet: cubit.shipmentDetails!.receivingStreet,
                  ),
                  locationId: locationId,
                ),
              );
            }
          },
          backgroundColor: weevoPrimaryOrangeColor,
          child: const Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
        ),
      );
    }
    return Container();
  }

  Future<RefreshQrcode?> refreshHandoverQrCodeMerchantToCourier(
      int shipmentId) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/merchant/shipments/$shipmentId/refresh-handover-qrcode-mtc',
        data: {},
        token: token,
      );
      return RefreshQrcode.fromJson(response.data);
    } on DioException {
      return null;
    }
  }

  Future<RefreshQrcode?> refreshHandoverQrCodeCourierToCustomer(
      int shipmentId) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/merchant/shipments/$shipmentId/refresh-handover-qrcode-ctc',
        data: {},
        token: token,
      );
      log('Doneeee ${response.data}');
      return RefreshQrcode.fromJson(response.data);
    } on DioException catch (e) {
      log('Error Code ${e.toString()}');
      return null;
    }
  }
}
