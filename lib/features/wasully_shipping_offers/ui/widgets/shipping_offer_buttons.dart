import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/Dialogs/loading.dart';
import '../../../../core/Models/accept_merchant_offer.dart';
import '../../../../core/Models/shipment_notification.dart';
import '../../../../core/Providers/auth_provider.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/helpers/toasts.dart';
import '../../../../core_new/networking/api_constants.dart';
import '../../../Widgets/weevo_button.dart';
import '../../../wasully_details/logic/cubit/wasully_details_cubit.dart';
import '../../../wasully_details/ui/screens/wasully_details_screen.dart';
import '../../data/models/courier_response_body.dart';
import '../../logic/cubit/wasully_shipping_offers_cubit.dart';
import '../../logic/cubit/wasully_shipping_offers_state.dart';

class ShippingOfferButtons extends StatelessWidget {
  final ShippingOfferResponseBody data;
  final ShipmentNotification shipmentNotification;
  const ShippingOfferButtons(
      {super.key, required this.data, required this.shipmentNotification});

  @override
  Widget build(BuildContext context) {
    WasullyShippingOffersCubit cubit = context.read();
    WasullyDetailsCubit detailsCubit = context.read();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return BlocConsumer<WasullyShippingOffersCubit, WasullyShippingOffersState>(
      listener: (context, state) async {
        if (state is WasullyShippingOfferAcceptSuccessState) {
          showToast(state.data.message);
          FirebaseFirestore.instance
              .collection('courier_notifications')
              .doc(data.driverId.toString())
              .collection(data.driverId.toString())
              .add({
            'read': false,
            'date_time': DateTime.now().toIso8601String(),
            'type': '',
            'title': 'تم قبول العرض الخاص بك',
            'body':
                'التاجر ${authProvider.name}تم قبول العرض الخاص بك من قِبل ',
            'user_icon':
                authProvider.photo != null && authProvider.photo!.isNotEmpty
                    ? authProvider.photo!.contains(ApiConstants.baseUrl)
                        ? authProvider.photo
                        : '${ApiConstants.baseUrl}${authProvider.photo}'
                    : '',
            'screen_to': 'shipment_details_screen',
            'data': AcceptMerchantOffer(
              shipmentId: shipmentNotification.shipmentId!,
              childrenShipment: shipmentNotification.childrenShipment ?? 0,
            ).toMap(),
          });
          DocumentSnapshot userToken = await FirebaseFirestore.instance
              .collection('courier_users')
              .doc(data.driverId.toString())
              .get();
          String token = userToken['fcmToken'];
          authProvider.sendNotification(
            title: 'تم قبول العرض الخاص بك',
            body: 'التاجر ${authProvider.name}تم قبول العرض الخاص بك من قِبل ',
            toToken: token,
            image: authProvider.photo != null && authProvider.photo!.isNotEmpty
                ? authProvider.photo!.contains(ApiConstants.baseUrl)
                    ? authProvider.photo
                    : '${ApiConstants.baseUrl}${authProvider.photo}'
                : '',
            screenTo: 'shipment_details_screen',
            type: '',
            data: AcceptMerchantOffer(
                    shipmentId: shipmentNotification.shipmentId!,
                    childrenShipment: 0)
                .toMap(),
          );
          detailsCubit.setNewShipmentAccepted(true);
          MagicRouter.pop();
          MagicRouter.navigateAndPop(WasullyDetailsScreen(id: data.shipmentId));
        }
        if (state is WasullyShippingOfferAcceptErrorState) {
          showToast(state.message, isError: true);
        }
      },
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: WeevoButton(
                onTap: () async {
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => PopScope(
                      onPopInvokedWithResult: (value, result) async => false,
                      child: const Loading(),
                    ),
                    barrierDismissible: false,
                  );
                  int offerId = data.id;
                  await cubit.acceptOffer(offerId);
                },
                color: weevoPrimaryOrangeColor,
                isStable: true,
                title: 'قبول العرض',
              ),
            ),
            horizontalSpace(10),
            Expanded(
              child: WeevoButton(
                onTap: () async {
                  DocumentSnapshot userToken = await FirebaseFirestore.instance
                      .collection('courier_users')
                      .doc(data.driverId.toString())
                      .get();
                  String token = userToken['fcmToken'];
                  showDialog(
                      context: navigator.currentContext!,
                      builder: (context) => const Loading(),
                      barrierDismissible: false);
                  FirebaseFirestore.instance
                      .collection('courier_notifications')
                      .doc(data.driverId.toString())
                      .collection(data.driverId.toString())
                      .add({
                    'read': false,
                    'date_time': DateTime.now().toIso8601String(),
                    'title': 'عرض أفضل',
                    'body':
                        'التاجر ${authProvider.name}يريد منك تقديم عرض أفضل ',
                    'user_icon': authProvider.photo != null &&
                            authProvider.photo!.isNotEmpty
                        ? authProvider.photo!.contains(ApiConstants.baseUrl)
                            ? authProvider.photo
                            : '${ApiConstants.baseUrl}${authProvider.photo}'
                        : '',
                    'screen_to': '',
                    'type': 'wasully',
                    'data': ShipmentNotification(
                      merchantName: shipmentNotification.merchantName,
                      merchantImage: shipmentNotification.merchantImage,
                      merchantFcmToken: shipmentNotification.merchantFcmToken,
                      receivingState: shipmentNotification.receivingState,
                      deliveryState: shipmentNotification.deliveryState,
                      deliveryCity: shipmentNotification.deliveryCity,
                      receivingCity: shipmentNotification.receivingCity,
                      totalShipmentCost: shipmentNotification.totalShipmentCost,
                      shippingCost: shipmentNotification.shippingCost,
                      childrenShipment: shipmentNotification.childrenShipment,
                      offerId: data.id,
                      shipmentId: shipmentNotification.shipmentId,
                      isWasully: 1,
                    ).toMap(),
                  });
                  authProvider.sendBetterOfferNotification(
                      title: 'عرض أفضل',
                      body:
                          'التاجر ${authProvider.name}يريد منك تقديم عرض أفضل ',
                      toToken: token,
                      image: authProvider.photo != null &&
                              authProvider.photo!.isNotEmpty
                          ? authProvider.photo!.contains(ApiConstants.baseUrl)
                              ? authProvider.photo
                              : '${ApiConstants.baseUrl}${authProvider.photo}'
                          : '',
                      screenTo: '',
                      type: '',
                      betterOffer: 1,
                      hasOffer: 1,
                      data: ShipmentNotification(
                        merchantName: shipmentNotification.merchantName,
                        merchantImage: shipmentNotification.merchantImage,
                        merchantId: authProvider.id,
                        merchantFcmToken: shipmentNotification.merchantFcmToken,
                        receivingState: shipmentNotification.receivingState,
                        deliveryState: shipmentNotification.deliveryState,
                        deliveryCity: shipmentNotification.deliveryCity,
                        receivingCity: shipmentNotification.receivingCity,
                        totalShipmentCost:
                            shipmentNotification.totalShipmentCost,
                        shippingCost: shipmentNotification.shippingCost,
                        childrenShipment: shipmentNotification.childrenShipment,
                        offerId: data.id,
                        shipmentId: shipmentNotification.shipmentId,
                        isWasully: 1,
                      ).toMap());
                  MagicRouter.pop();
                },
                color: weevoDarkGrey,
                isStable: true,
                title: 'عرض أفضل',
              ),
            ),
          ],
        );
      },
    );
  }
}
