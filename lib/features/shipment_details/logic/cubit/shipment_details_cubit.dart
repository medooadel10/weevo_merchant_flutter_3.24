import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weevo_merchant_upgrade/core/Dialogs/rating_dialog.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/data/models/shipment_details_model.dart';

import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/router/router.dart';
import '../../data/repos/shipment_details_repo.dart';

part 'shipment_details_cubit.freezed.dart';
part 'shipment_details_state.dart';

class ShipmentDetailsCubit extends Cubit<ShipmentDetailsState> {
  final ShipmentDetailsRepo _shipmentDetailsRepo;
  ShipmentDetailsCubit(this._shipmentDetailsRepo)
      : super(const ShipmentDetailsState.initial());

  ShipmentDetailsModel? shipmentDetails;

  Future<void> getShipmentDetails(int shipmentId,
      {bool clearShipment = true}) async {
    if (clearShipment) shipmentDetails = null;
    emit(const ShipmentDetailsState.loading());
    log('get shipment details');
    final result = await _shipmentDetailsRepo.getShipmentDetails(shipmentId);
    if (result.success) {
      log(result.data?.toJson().toString() ?? 'Null');
      shipmentDetails = result.data!;
      emit(ShipmentDetailsState.success(result.data!));
    } else {
      emit(ShipmentDetailsState.error(result.error!));
    }
  }

  int currentProductIndex = 0;
  void changeProductIndex(int index) {
    currentProductIndex = index;
    emit(ShipmentDetailsState.changeProductIndex(index));
  }

  void cancelShipment() async {
    emit(const ShipmentDetailsState.cancelShipmentLoading());
    final result =
        await _shipmentDetailsRepo.cancelShipment(shipmentDetails!.id);
    if (result.success) {
      emit(const ShipmentDetailsState.cancelShipmentSuccess());
    } else {
      emit(ShipmentDetailsState.cancelShipmentError(result.error!));
    }
  }

  final shippingCostContoller = TextEditingController();
  final priceForm = GlobalKey<FormState>();

  void updateShippingCost() async {
    if (priceForm.currentState!.validate()) {
      emit(const ShipmentDetailsState.updatePriceLoading());
      final result = await _shipmentDetailsRepo.updateShippingCost(
          shipmentDetails!.id, shippingCostContoller.text);
      if (result.success) {
        emit(const ShipmentDetailsState.updatePriceSuccess());
      } else {
        emit(ShipmentDetailsState.updatePriceError(result.error!));
      }
    }
  }

  void restoreCancelledShipment() async {
    emit(const ShipmentDetailsState.restoreCancelLoading());
    final result = await _shipmentDetailsRepo
        .restoreCancelledShipment(shipmentDetails!.id);
    if (result.success) {
      emit(const ShipmentDetailsState.restoreCancelSuccess());
    } else {
      emit(ShipmentDetailsState.restoreCancelError(result.error!));
    }
  }

  String shareLink = '';
  void shareWasully() async {
    String msg;
    StringBuffer sb = StringBuffer();
    sb.write(
        "اسم المنتج : ${shipmentDetails!.products[currentProductIndex].productInfo.name} \n");
    sb.write("مبلغ الشحنه : ${shipmentDetails?.amount} \n");
    sb.write(
        "تكلفة التوصيل : ${shipmentDetails!.expectedShippingCost ?? shipmentDetails!.agreedShippingCost ?? '0'} \n");
    sb.write(
        "من : ${shipmentDetails?.receivingStateModel} - ${shipmentDetails?.receivingCityModel}  إلي : ${shipmentDetails?.deliveringStateModel} - ${shipmentDetails?.deliveringCityModel}\n");
    sb.write(shareLink);
    msg = sb.toString();
    var request = await HttpClient().getUrl(Uri.parse(
        shipmentDetails!.products[currentProductIndex].productInfo.image));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    XFile? imageFile = XFile.fromData(bytes, name: 'amlog.jpg');
    await Share.shareXFiles([imageFile], text: msg);
  }

  String courierNationalId = '';
  String merchantNationalId = '';
  String locationId = '';
  String status = '';
  void streamShipmentStatus(BuildContext context) async {
    try {
      DocumentSnapshot courierToken = await FirebaseFirestore.instance
          .collection('courier_users')
          .doc(shipmentDetails?.courierId.toString())
          .get();
      courierNationalId = courierToken['national_id'];
      merchantNationalId = Preferences.instance.getPhoneNumber;
      log('location id: $merchantNationalId');
      if (merchantNationalId.hashCode >= courierNationalId.hashCode) {
        locationId =
            '$merchantNationalId-$courierNationalId-${shipmentDetails?.id}';
      } else {
        locationId =
            '$courierNationalId-$merchantNationalId-${shipmentDetails?.id}';
      }
      FirebaseFirestore.instance
          .collection('locations')
          .doc(locationId)
          .snapshots()
          .listen((event) {
        if (event.data() != null && event.data()!['status'] != null) {
          status = event.data()!['status'];
          if (status == 'delivered' && shipmentDetails!.status != 'delivered') {
            AuthProvider authProvider =
                Provider.of(navigator.currentContext!, listen: false);
            MagicRouter.navigateAndPopAll(
              RatingDialog(
                model: ShipmentTrackingModel(
                  courierNationalId: courierNationalId,
                  merchantNationalId: merchantNationalId,
                  shipmentId: shipmentDetails!.id,
                  deliveringState: shipmentDetails!.deliveringState.toString(),
                  deliveringCity: shipmentDetails!.deliveringCity.toString(),
                  receivingState: shipmentDetails!.receivingState.toString(),
                  receivingCity: shipmentDetails!.receivingCity.toString(),
                  deliveringLat: shipmentDetails!.deliveringLat,
                  clientPhone: shipmentDetails!.clientPhone,
                  hasChildren: 0,
                  status: shipmentDetails!.status,
                  deliveringLng: shipmentDetails!.deliveringLng,
                  receivingLng: shipmentDetails!.receivingLng,
                  receivingLat: shipmentDetails!.receivingLat,
                  merchantId: shipmentDetails!.merchantId,
                  merchantImage: authProvider.photo,
                  merchantPhone: authProvider.phone,
                  merchantName: authProvider.name,
                  courierId: shipmentDetails!.courierId,
                  paymentMethod: shipmentDetails!.paymentMethod,
                  courierImage: shipmentDetails!.courier?.photo,
                  courierName: shipmentDetails!.courier?.name,
                  courierPhone: shipmentDetails!.courier?.phone,
                  deliveringStreet: shipmentDetails!.deliveringStreet,
                  receivingStreet: shipmentDetails!.receivingStreet,
                ),
              ),
            );
          }
          getShipmentDetails(shipmentDetails!.id, clearShipment: false);
        }
      });
    } catch (e) {
      locationId = '';
    }
  }
}
