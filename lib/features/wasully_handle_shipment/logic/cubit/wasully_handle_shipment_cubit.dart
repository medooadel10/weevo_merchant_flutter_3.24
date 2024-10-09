import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/router/router.dart';
import '../../data/repos/wasully_handle_shipment_repo.dart';
import '../../ui/widgets/wasully_rating_dialog.dart';
import 'wasully_handle_shipment_state.dart';

class WasullyHandleShipmentCubit extends Cubit<WasullyHandleShipmentState> {
  final WasullyHandleShipmentRepo _wasullyHandleShipmentRepo;
  WasullyHandleShipmentCubit(this._wasullyHandleShipmentRepo)
      : super(WasullyHandleShipmentInitial());

  void listenToShipmentStatus(String locationId, ShipmentTrackingModel model) {
    FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        if (event.data()!['status'] != null) {
          String status = event.data()!['status'];
          if (status == 'delivered') {
            MagicRouter.navigateAndPopAll(WasullyRatingDialog(model: model));
          }
        }
      }
    });
  }

  Future<void> refreshHandoverQrCodeMerchantToCourier(int shipmentId) async {
    emit(WasullyHandleShipmentRefreshQrCodeStateLoading());
    final result = await _wasullyHandleShipmentRepo
        .refreshHandoverQrCodeMerchantToCourier(shipmentId);
    if (result.success!) {
      emit(
          WasullyHandleShipmentRefreshQrCodeStateSuccess(qrCode: result.data!));
    } else {
      emit(
        WasullyHandleShipmentRefreshQrCodeStateError(
          error: result.error ?? '',
        ),
      );
    }
  }

  Future<void> refreshHandoverQrCodeCourierToCustomer(int shipmentId) async {
    emit(WasullyHandleShipmentRefreshQrCodeStateLoading());
    final result = await _wasullyHandleShipmentRepo
        .refreshHandoverQrCodeCourierToCustomer(shipmentId);
    if (result.success!) {
      emit(
          WasullyHandleShipmentRefreshQrCodeStateSuccess(qrCode: result.data!));
    } else {
      emit(
        WasullyHandleShipmentRefreshQrCodeStateError(
          error: result.error!,
        ),
      );
    }
  }

  Future<void>
      handleReturnedShipmentByValidatingHandoverQrCodeCourierToMerchant(
          int shipmentId, int qrCode, String locationId) async {
    emit(WasullyHandleShipmentHandleReturnedShipmentStateLoading());
    final result = await _wasullyHandleShipmentRepo
        .handleReturnedShipmentByValidatingHandoverQrCodeCourierToMerchant(
            shipmentId, qrCode);
    if (result.success!) {
      try {
        await FirebaseFirestore.instance
            .collection('locations')
            .doc(locationId)
            .set({
          'status': 'returned',
        });
      } on FirebaseException catch (e) {
        emit(WasullyHandleShipmentHandleReturnedShipmentStateError(
            error: e.message!));
      }
      emit(WasullyHandleShipmentHandleReturnedShipmentStateSuccess());
    } else {
      emit(
        WasullyHandleShipmentHandleReturnedShipmentStateError(
          error: result.error!,
        ),
      );
    }
  }

  Future<void> reviewCourier({
    required int shipmentId,
    required int rating,
    required String title,
    required String body,
    required String recommend,
  }) async {
    emit(WasullyHandleShipmentReviewCourierLoading());
    final result = await _wasullyHandleShipmentRepo.reviewCourier(
      shipmentId: shipmentId,
      rating: rating,
      title: title,
      body: body,
      recommend: recommend,
    );
    if (result.success!) {
      emit(WasullyHandleShipmentReviewCourierSuccess());
    } else {
      emit(
        WasullyHandleShipmentReviewCourierError(
          error: result.error!,
        ),
      );
    }
  }
}
