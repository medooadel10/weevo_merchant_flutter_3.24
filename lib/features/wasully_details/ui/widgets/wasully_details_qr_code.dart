import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/Dialogs/loading.dart';
import '../../../../core/Dialogs/qr_dialog_code.dart';
import '../../../../core/Dialogs/share_save_qr_code_dialog.dart';
import '../../../../core/Models/refresh_qr_code.dart';
import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../../../wasully_handle_shipment/ui/widgets/wasully_courier_to_merchant_qr_code_dialog.dart';
import '../../logic/cubit/wasully_details_cubit.dart';

class WasullyDetailsQrCode extends StatelessWidget {
  final String locationId;
  final String status;
  final String courierNationalId;
  final String merchantNationalId;
  const WasullyDetailsQrCode(
      {super.key,
      required this.locationId,
      required this.status,
      required this.courierNationalId,
      required this.merchantNationalId});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
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
              if (cubit.wasullyModel == null ||
                  (cubit.wasullyModel!.handoverCodeMerchantToCourier == null &&
                      cubit.wasullyModel!.handoverQrcodeMerchantToCourier ==
                          null)) {
                showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => const Loading());
                await refreshHandoverQrCodeMerchantToCourier(
                    cubit.wasullyModel!.id);
              } else {
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => QrCodeDialog(
                    data: RefreshQrcode(
                      filename: cubit
                          .wasullyModel!.handoverQrcodeMerchantToCourier!
                          .split('/')
                          .last,
                      path: cubit.wasullyModel!.handoverQrcodeMerchantToCourier,
                      code: int.parse(
                        cubit.wasullyModel!.handoverCodeMerchantToCourier!,
                      ),
                    ),
                  ),
                );
              }
            } else if (status == 'receivedShipment' ||
                status == 'handingOverShipmentToCustomer') {
              pref.setShareFirstTime(cubit.wasullyModel!.id.toString(), 1);
              if (cubit.wasullyModel == null ||
                  (cubit.wasullyModel!.handoverQrcodeCourierToCustomer ==
                          null &&
                      cubit.wasullyModel!.handoverCodeCourierToCustomer ==
                          null)) {
                showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => const Loading());
                await refreshHandoverQrCodeCourierToCustomer(
                    cubit.wasullyModel!.id);
              } else {
                log('${cubit.wasullyModel!.handoverQrcodeCourierToCustomer}');
                log('${cubit.wasullyModel!.handoverCodeCourierToCustomer}');
                log(cubit.wasullyModel!.handoverQrcodeCourierToCustomer!
                    .split('/')
                    .last);
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => ShareSaveQrCodeDialog(
                    shipmentId: cubit.wasullyModel!.id,
                    data: RefreshQrcode(
                      filename: cubit
                          .wasullyModel!.handoverQrcodeCourierToCustomer!
                          .split('/')
                          .last,
                      path: cubit.wasullyModel!.handoverQrcodeCourierToCustomer,
                      code: int.parse(
                          cubit.wasullyModel!.handoverCodeCourierToCustomer!),
                    ),
                  ),
                );
              }
            } else if (status == 'handingOverReturnedShipmentToMerchant') {
              showDialog(
                context: navigator.currentContext!,
                barrierDismissible: false,
                builder: (ctx) => WasullyCourierToMerchantQrCodeDialog(
                  model: ShipmentTrackingModel(
                    courierNationalId: courierNationalId,
                    merchantNationalId: merchantNationalId,
                    shipmentId: cubit.wasullyModel!.id,
                    deliveringState:
                        cubit.wasullyModel!.deliveringState.toString(),
                    deliveringCity:
                        cubit.wasullyModel!.deliveringCity.toString(),
                    receivingState:
                        cubit.wasullyModel!.receivingState.toString(),
                    receivingCity: cubit.wasullyModel!.receivingCity.toString(),
                    deliveringLat: cubit.wasullyModel!.deliveringLat,
                    clientPhone: cubit.wasullyModel!.clientPhone,
                    hasChildren: 0,
                    status: cubit.wasullyModel!.status,
                    deliveringLng: cubit.wasullyModel!.deliveringLng,
                    receivingLng: cubit.wasullyModel!.receivingLng,
                    receivingLat: cubit.wasullyModel!.receivingLat,
                    merchantId: cubit.wasullyModel!.merchantId,
                    merchantImage: authProvider.photo,
                    merchantPhone: authProvider.phone,
                    merchantName: authProvider.name,
                    courierId: cubit.wasullyModel!.courierId,
                    paymentMethod: cubit.wasullyModel!.paymentMethod,
                    courierImage: cubit.wasullyModel!.courier?.photo,
                    courierName: cubit.wasullyModel!.courier?.name,
                    courierPhone: cubit.wasullyModel!.courier?.phone,
                    deliveringStreet: cubit.wasullyModel!.deliveringStreet,
                    receivingStreet: cubit.wasullyModel!.receivingStreet,
                    wasullyModel: cubit.wasullyModel,
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
            '${ApiConstants.baseUrl}/api/v1/merchant/wasuliy/wasuliy/$shipmentId/refresh-handover-qrcode-mtc',
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
            '${ApiConstants.baseUrl}/api/v1/merchant/wasuliy/wasuliy/$shipmentId/refresh-handover-qrcode-ctc',
        data: {},
        token: token,
      );
      return RefreshQrcode.fromJson(response.data);
    } on DioException {
      return null;
    }
  }
}
