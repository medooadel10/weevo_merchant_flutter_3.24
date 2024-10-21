import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/helpers/constants.dart';
import '../../../../core_new/router/router.dart';
import '../../../wasully_handle_shipment/ui/widgets/wasully_rating_dialog.dart';
import '../../data/models/wasully_model.dart';
import '../../data/models/wasully_update_price_request_body.dart';
import '../../data/repos/wasully_details_repo.dart';
import 'wasully_details_state.dart';

class WasullyDetailsCubit extends Cubit<WasullyDetailsState> {
  final WasullyDetailsRepo _wasullyDetailsRepo;
  WasullyDetailsCubit(this._wasullyDetailsRepo)
      : super(WasullyDetailsInitialState());

  WasullyModel? wasullyModel;
  bool isNewShipmentAccepted = false;

  void setNewShipmentAccepted(bool value) {
    isNewShipmentAccepted = value;
    emit(WasullyUpdateAcceptNewShipmentState(isNewShipmentAccepted));
  }

  Future<void> getWassullyDetails(int id) async {
    wasullyModel = null;
    emit(WasullyDetailsLoadingState());
    final result = await _wasullyDetailsRepo.getWasullyDetails(id);
    if (result.success) {
      wasullyModel = result.data;
      await _createDynamicLink(id);
      emit(WasullyDetailsSuccessState(wasullyModel!));
    } else {
      emit(WasullyDetailsErrorState(result.error ?? ''));
    }
  }

  String courierNationalId = '';
  String merchantNationalId = '';
  String locationId = '';
  String status = '';
  void streamShipmentStatus(BuildContext context) async {
    try {
      DocumentSnapshot courierToken = await FirebaseFirestore.instance
          .collection('courier_users')
          .doc(wasullyModel?.courierId.toString())
          .get();
      courierNationalId = courierToken['national_id'];
      log('courier national id: $courierNationalId');

      merchantNationalId = Preferences.instance.getPhoneNumber;
      log('location id: $merchantNationalId');
      if (merchantNationalId.hashCode >= courierNationalId.hashCode) {
        locationId =
            '$merchantNationalId-$courierNationalId-${wasullyModel?.id}';
      } else {
        locationId =
            '$courierNationalId-$merchantNationalId-${wasullyModel?.id}';
      }
      FirebaseFirestore.instance
          .collection('locations')
          .doc(locationId)
          .snapshots()
          .listen((event) {
        if (event.data() != null && event.data()!['status'] != null) {
          status = event.data()!['status'];
          log(wasullyModel!.toJson().toString());
          if (status == 'delivered' && wasullyModel!.status != 'delivered') {
            AuthProvider authProvider =
                Provider.of(navigator.currentContext!, listen: false);
            log('Data: ${wasullyModel!.toJson()}');
            MagicRouter.navigateAndPopAll(
              WasullyRatingDialog(
                model: ShipmentTrackingModel(
                  courierNationalId: courierNationalId,
                  merchantNationalId: merchantNationalId,
                  shipmentId: wasullyModel!.id,
                  deliveringState: wasullyModel!.deliveringState.toString(),
                  deliveringCity: wasullyModel!.deliveringCity.toString(),
                  receivingState: wasullyModel!.receivingState.toString(),
                  receivingCity: wasullyModel!.receivingCity.toString(),
                  deliveringLat: wasullyModel!.deliveringLat,
                  clientPhone: wasullyModel!.clientPhone,
                  hasChildren: 0,
                  status: wasullyModel!.status,
                  deliveringLng: wasullyModel!.deliveringLng,
                  receivingLng: wasullyModel!.receivingLng,
                  receivingLat: wasullyModel!.receivingLat,
                  merchantId: wasullyModel!.merchantId,
                  merchantImage: authProvider.photo,
                  merchantPhone: authProvider.phone,
                  merchantName: authProvider.name,
                  courierId: wasullyModel!.courierId,
                  paymentMethod: wasullyModel!.paymentMethod,
                  courierImage: wasullyModel!.courier?.photo,
                  courierName: wasullyModel!.courier?.name,
                  courierPhone: wasullyModel!.courier?.phone,
                  deliveringStreet: wasullyModel!.deliveringStreet,
                  receivingStreet: wasullyModel!.receivingStreet,
                  wasullyModel: wasullyModel,
                ),
              ),
            );
          }
          getWassullyDetails(wasullyModel!.id);
        }
      });
    } catch (e) {
      locationId = '';
    }
  }

  String? shareLink;
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
    shareLink = url.toString();
    emit(CreateDynamicLinkSuccessState(shareLink ?? ''));
  }

  void shareWasully() async {
    String msg;
    StringBuffer sb = StringBuffer();
    sb.write("اسم المنتج : ${wasullyModel?.title} \n");
    sb.write("مبلغ الشحنه : ${wasullyModel?.amount} \n");
    sb.write("تكلفة التوصيل : ${wasullyModel?.price} \n");
    sb.write(
        "من : ${wasullyModel?.receivingStateModel} - ${wasullyModel?.receivingCityModel}  إلي : ${wasullyModel?.deliveringStateModel} - ${wasullyModel?.deliveringCityModel}\n");
    sb.write(shareLink);
    msg = sb.toString();
    var request =
        await HttpClient().getUrl(Uri.parse(wasullyModel?.image ?? ''));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    XFile? imageFile = XFile.fromData(bytes, name: 'amlog.jpg');
    await Share.shareXFiles([imageFile], text: msg);
  }

  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void updateWasullyPrice() async {
    if (formKey.currentState!.validate()) {
      emit(WasullyUpdatePriceLoadingState());
      final result = await _wasullyDetailsRepo.updateWasullyPrice(
        id: wasullyModel!.id,
        body: WasullyUpdatePriceRequestBody(price: priceController.text),
      );
      if (result.success) {
        wasullyModel = result.data;
        emit(WasullyUpdatePriceSuccessState(result.data!));
      } else {
        emit(WasullyUpdatePriceErrorState(result.error ?? ''));
      }
    }
  }

  void updateWasully(WasullyModel wasully) {
    wasullyModel = null;
    emit(WasullyDetailsLoadingState());
    Future.delayed(const Duration(milliseconds: 1000), () {
      wasullyModel = wasully;
      emit(WasullyDetailsSuccessState(wasullyModel!));
    });
  }

  void cancelWasully() async {
    emit(WasullyCancelLoadingState());
    final result = await _wasullyDetailsRepo.cancelWasully(wasullyModel!.id,
        AppConstants.cancellationReasons[selectedCancellationReasonIndex!]);
    if (result.success) {
      if (wasullyModel?.courier != null) {
        String merchantPhoneNumber = Preferences.instance.getPhoneNumber;
        String? courierPhoneNumber = wasullyModel!.courier?.phone;
        String locationId = '';
        if (merchantPhoneNumber.hashCode >= courierPhoneNumber.hashCode) {
          locationId =
              '$merchantPhoneNumber-$courierPhoneNumber-${wasullyModel!.id}';
        } else {
          locationId =
              '$courierPhoneNumber-$merchantPhoneNumber-${wasullyModel!.id}';
        }

        if (courierPhoneNumber != null) {
          FirebaseFirestore.instance
              .collection('locations')
              .doc(locationId)
              .set(
            {
              'status': 'closed',
              'shipmentId': wasullyModel!.slug,
            },
          );
        }
      }
      emit(WasullyCancelSuccessState());
    } else {
      emit(WasullyCancelErrorState(result.error!));
    }
  }

  int? selectedCancellationReasonIndex;

  void selectCancellationReason(int? index) {
    selectedCancellationReasonIndex = index;
    emit(WasullyDetailsChangeCancellationReasonState(index));
  }

  void restoreWasully() async {
    emit(WasullyRestoreLoadingState());
    int id = wasullyModel!.id;
    final result = await _wasullyDetailsRepo.restoreWasully(id);
    if (result.success) {
      FirebaseFirestore.instance
          .collection('locations')
          .where('shipmentId', isEqualTo: wasullyModel!.slug)
          .get()
          .then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance
              .collection('locations')
              .doc(element.id)
              .delete();
        }
      });
      emit(WasullyRestoreSuccessState());
    } else {
      emit(WasullyRestoreErrorState(result.error ?? ''));
    }
  }
}
