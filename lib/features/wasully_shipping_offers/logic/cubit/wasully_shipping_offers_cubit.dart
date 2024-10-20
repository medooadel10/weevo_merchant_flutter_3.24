import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/Dialogs/action_dialog.dart';
import '../../../../core/Models/shipment_notification.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core_new/router/router.dart';
import '../../../wasully_details/ui/screens/wasully_details_screen.dart';
import '../../data/models/courier_response_body.dart';
import '../../data/repos/wasully_shipping_offers_repo.dart';
import 'wasully_shipping_offers_state.dart';

class WasullyShippingOffersCubit extends Cubit<WasullyShippingOffersState> {
  final WasullyShippingOffersRepo _couriersRepo;
  WasullyShippingOffersCubit(this._couriersRepo)
      : super(WasullyShippingOffersInitialState());

  List<ShippingOfferResponseBody>? shippingOffers;
  bool isFirstTime = true;
  bool courierAppliedToShipment = false;
  StreamSubscription? subscription;

  bool _dialogOpened = false;
  final ScrollController scrollController = ScrollController();
  Future<void> init({
    required int id,
    required ShipmentNotification shipmentNotification,
    required BuildContext context,
  }) async {
    await _getShippingOffers(id);
    subscription = null;
    subscription =
        Stream.periodic(const Duration(seconds: 5)).listen((timer) async {
      await getShipmentStatus(id);
      if (courierAppliedToShipment) {
        // showToast('Applied');
        if (!_dialogOpened) {
          _dialogOpened = true;
          // showToast('Dialog opened');
          try {
            showDialog(
                context: navigator.currentContext!,
                barrierDismissible: false,
                builder: (cx) => ActionDialog(
                      content: 'قام احد المناديب بقبول طلبك و دفع مقدم الشحن',
                      approveAction: 'الذهاب للطلب',
                      onApproveClick: () {
                        MagicRouter.pop();
                        _dialogOpened = false;
                        MagicRouter.navigateAndPop(
                          WasullyDetailsScreen(id: id),
                        );
                      },
                    ));
            closeTimer();
          } on Exception catch (_) {
            // showToast('Dialog Error: ${e.toString()}');
          }
        }
      } else {
        _getShippingOffers(
          shipmentNotification.shipmentId!,
        );
        if (shippingOffers!.isNotEmpty) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(seconds: 5),
              curve: Curves.fastOutSlowIn);
        }
      }
    });
  }

  Future<void> _getShippingOffers(int id) async {
    emit(WasullyShippingOffersLoadingState());

    final result = await _couriersRepo.getCouriers(id);
    // Initialize shippingOffers as an empty list if it's null
    shippingOffers ??= [];
    if (result.success) {
      List<ShippingOfferResponseBody> offers =
          result.data!.where((offer) => offer.shipmentId == id).toList();
      DateTime now = DateTime.now();
      // Filter offers that are still valid (not expired and added within the last 15 minutes)
      List<ShippingOfferResponseBody> validOffers = offers.where((offer) {
        DateTime expiresAt = DateTime.parse(offer.expiresAt);
        return now.isBefore(expiresAt) &&
            now.difference(DateTime.parse(offer.updatedAt)).inMinutes <= 15;
      }).toList();

      // Update and add offers
      List<ShippingOfferResponseBody> updatedOffers = [];
      for (var newOffer in validOffers) {
        int index = shippingOffers!
            .indexWhere((existingOffer) => existingOffer.id == newOffer.id);
        if (index != -1) {
          // Check if the offer has been updated
          if (DateTime.parse(newOffer.updatedAt)
              .isAfter(DateTime.parse(shippingOffers![index].updatedAt))) {
            shippingOffers![index] =
                newOffer; // Update the existing offer with the new data
          }
        } else {
          updatedOffers.add(newOffer); // Add new offers not already in the list
        }
      }

      // Add newly identified offers to the main list
      shippingOffers?.addAll(updatedOffers);

      // Remove offers that are no longer valid
      shippingOffers?.removeWhere((existingOffer) =>
          !validOffers.any((validOffer) => validOffer.id == existingOffer.id));

      // Sorting the offers by updatedAt timestamp
      shippingOffers?.sort((a, b) =>
          DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt)));

      if (!isClosed) emit(WasullyShippingOffersSuccessState(shippingOffers!));
    } else {
      log('OffersError: ${result.error}');
      if (!isClosed) emit(WasullyShippingOffersErrorState());
    }
  }

  Future<void> acceptOffer(int id) async {
    emit(WasullyShippingOfferAcceptLoadingState());
    final result = await _couriersRepo.acceptOffer(id);
    if (result.success) {
      shippingOffers?.removeWhere((element) => element.id == id);
      emit(WasullyShippingOfferAcceptSuccessState(result.data!));
    } else {
      emit(WasullyShippingOfferAcceptErrorState(result.error ?? ''));
    }
  }

  Future<void> getShipmentStatus(int id) async {
    emit(WasullyShippingOffersLoadingState());
    final result = await _couriersRepo.getShipmentStatus(id);
    if (result.success) {
      courierAppliedToShipment = result.data == 'courier-applied-to-shipment';
      if (!courierAppliedToShipment) {
        // showToast('courierAppliedToShipment: $courierAppliedToShipment');
      }
      emit(WasullyShippingOffersSuccessState(shippingOffers!));
    } else {
      emit(WasullyShippingOffersErrorState());
    }
  }

  void closeTimer() {
    subscription?.cancel();
  }

  @override
  Future<void> close() {
    closeTimer();
    return super.close();
  }
}
