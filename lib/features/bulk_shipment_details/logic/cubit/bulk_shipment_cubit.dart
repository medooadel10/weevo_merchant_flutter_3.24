import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/data/repos/bulk_shipment_details_repo.dart';

import '../../../../core/Dialogs/rating_dialog.dart';
import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/router/router.dart';
import '../../data/models/bulk_shipment_model.dart';

part 'bulk_shipment_cubit.freezed.dart';
part 'bulk_shipment_state.dart';

class BulkShipmentCubit extends Cubit<BulkShipmentState> {
  final BulkShipmentDetailsRepo _bulkShipmentDetailsRepo;
  BulkShipmentCubit(this._bulkShipmentDetailsRepo)
      : super(const BulkShipmentState.initial());

  BulkShipmentModel? bulkShipmentModel;

  Future<void> getBulkShipmentDetails(int id,
      {bool clearShipment = true}) async {
    if (clearShipment) bulkShipmentModel = null;
    emit(const BulkShipmentState.loading());
    final result = await _bulkShipmentDetailsRepo.getBulkShipmentDetails(id);
    if (result.success) {
      bulkShipmentModel = result.data;
      emit(BulkShipmentState.success(bulkShipmentModel!));
    } else {
      emit(BulkShipmentState.error(result.error ?? ''));
    }
  }

  String courierNationalId = '';
  String merchantNationalId = '';
  String locationId = '';
  String status = '';
  void streamShipmentStatus(BuildContext context) async {
    try {
      log('courier id: ${bulkShipmentModel?.courier?.id}');
      DocumentSnapshot courierToken = await FirebaseFirestore.instance
          .collection('courier_users')
          .doc(bulkShipmentModel?.courier?.id.toString())
          .get();
      courierNationalId = courierToken['national_id'];
      log('courier id: $courierNationalId');
      merchantNationalId = Preferences.instance.getPhoneNumber;
      log('location id: $merchantNationalId');
      if (merchantNationalId.hashCode >= courierNationalId.hashCode) {
        locationId =
            '$merchantNationalId-$courierNationalId-${bulkShipmentModel?.id}';
      } else {
        locationId =
            '$courierNationalId-$merchantNationalId-${bulkShipmentModel?.id}';
      }
      FirebaseFirestore.instance
          .collection('locations')
          .doc(locationId)
          .snapshots()
          .listen((event) {
        if (event.data() != null && event.data()!['status'] != null) {
          status = event.data()!['status'];
          if (status == 'delivered' &&
              bulkShipmentModel!.status != 'delivered') {
            AuthProvider authProvider =
                Provider.of(navigator.currentContext!, listen: false);
            MagicRouter.navigateAndPopAll(
              RatingDialog(
                model: ShipmentTrackingModel(
                  courierNationalId: courierNationalId,
                  merchantNationalId: merchantNationalId,
                  shipmentId: bulkShipmentModel!.id,
                  deliveringState:
                      bulkShipmentModel!.deliveringState.toString(),
                  deliveringCity: bulkShipmentModel!.deliveringCity.toString(),
                  receivingState: bulkShipmentModel!.receivingState.toString(),
                  receivingCity: bulkShipmentModel!.receivingCity.toString(),
                  deliveringLat: bulkShipmentModel!.deliveringLat,
                  clientPhone: bulkShipmentModel!.clientPhone,
                  hasChildren: 0,
                  status: bulkShipmentModel!.status,
                  deliveringLng: bulkShipmentModel!.deliveringLng,
                  receivingLng: bulkShipmentModel!.receivingLng,
                  receivingLat: bulkShipmentModel!.receivingLat,
                  merchantId: bulkShipmentModel!.merchantId,
                  merchantImage: authProvider.photo,
                  merchantPhone: authProvider.phone,
                  merchantName: authProvider.name,
                  courierId: bulkShipmentModel!.courierId,
                  paymentMethod: bulkShipmentModel!.paymentMethod,
                  courierImage: bulkShipmentModel!.courier?.photo,
                  courierName: bulkShipmentModel!.courier?.name,
                  courierPhone: bulkShipmentModel!.courier?.phone,
                  deliveringStreet: bulkShipmentModel!.deliveringStreet,
                  receivingStreet: bulkShipmentModel!.receivingStreet,
                ),
              ),
            );
          }
          getBulkShipmentDetails(bulkShipmentModel!.id, clearShipment: false);
        }
      });
    } catch (e) {
      locationId = '';
    }
  }
}
