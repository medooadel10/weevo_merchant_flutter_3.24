import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/Dialogs/loading_dialog.dart';
import '../../../../core/Dialogs/qr_dialog_code.dart';
import '../../../../core/Models/refresh_qr_code.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../../core_new/networking/dio_factory.dart';
import '../../logic/cubit/bulk_shipment_cubit.dart';

class BulkShipmentDetailsQrCode extends StatelessWidget {
  final String locationId;
  final String status;
  final String courierNationalId;
  final String merchantNationalId;
  const BulkShipmentDetailsQrCode(
      {super.key,
      required this.locationId,
      required this.status,
      required this.courierNationalId,
      required this.merchantNationalId});

  @override
  Widget build(BuildContext context) {
    BulkShipmentCubit cubit = context.read<BulkShipmentCubit>();
    if (status == 'receivingShipment') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            if (status == 'receivingShipment') {
              if (cubit.bulkShipmentModel == null ||
                  (cubit.bulkShipmentModel!.handoverCodeMerchantToCourier ==
                          null &&
                      cubit.bulkShipmentModel!
                              .handoverQrcodeMerchantToCourier ==
                          null)) {
                showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => const LoadingDialog());
                await refreshHandoverQrCodeMerchantToCourier(
                    cubit.bulkShipmentModel!.id);
              } else {
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => QrCodeDialog(
                    data: RefreshQrcode(
                      filename: cubit
                          .bulkShipmentModel!.handoverQrcodeMerchantToCourier!
                          .split('/')
                          .last,
                      path: cubit
                          .bulkShipmentModel!.handoverQrcodeMerchantToCourier,
                      code: int.parse(
                        cubit.bulkShipmentModel!.handoverCodeMerchantToCourier!,
                      ),
                    ),
                  ),
                );
              }
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
      return RefreshQrcode.fromJson(response.data);
    } on DioException {
      return null;
    }
  }
}
