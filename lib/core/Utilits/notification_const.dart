import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/ui/bulk_shipment_details_screen.dart';

import '../../features/Screens/chat_screen.dart';
import '../../features/Screens/choose_courier.dart';
import '../../features/Screens/handle_shipment.dart';
import '../../features/Screens/merchant_warehouse.dart';
import '../../features/Screens/shipment_splash.dart';
import '../../features/Screens/wallet.dart';
import '../../features/Screens/weevo_plus_screen.dart';
import '../../features/shipment_details/ui/shipment_details_screen.dart';
import '../Dialogs/loading.dart';
import '../Dialogs/wallet_dialog.dart';
import '../Models/chat_data.dart';
import '../Models/shipment_notification.dart';
import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Storage/shared_preference.dart';
import '../router/router.dart';
import 'constants.dart';

const String shipmentScreen = 'shipment_screen';
const String homeScreen = 'home_screen';
const String shipmentOffers = 'shipment_offers';
const String shipmentDecline = 'shipment_decline';
const String walletScreen = 'wallet_screen';
const String chatScreen = 'chat_screen';
const String cancelShipment = 'cancel_shipment';
const String productScreen = 'product_screen';
const String wallet = 'wallet';
const String handleShipmentScreen = 'handle_shipment_screen';
const String weevoPlusScreen = 'weevo_plus_screen';
const String createShipmentScreen = 'create_shipment_screen';

void whereTo(BuildContext ctx, String link) {
  switch (link) {
    case 'screen://warehouse_screen?source=home-banner':
      Navigator.pushNamed(ctx, MerchantWarehouse.id);
      break;
    case 'screen://weevo_plus_screen?source=home-banner':
      if (Preferences.instance.getWeevoPlusPlanId.isNotEmpty) {
        Navigator.pushNamed(ctx, WeevoPlus.id, arguments: true);
      } else {
        Navigator.pushNamed(ctx, WeevoPlus.id, arguments: false);
      }
      break;
    case 'screen://create_shipment_screen?source=home-banner':
      Navigator.pushNamed(ctx, ShipmentSplash.id);
      break;
  }
}

void notificationNavigation(
    {required BuildContext ctx,
    required AuthProvider auth,
    String? type,
    required Map<String, dynamic> data}) async {
  switch (type) {
    case 'cancel_shipment':
      if (ShipmentTrackingModel.fromJson(data).hasChildren == 0) {
        MagicRouter.navigateTo(ShipmentDetailsScreen(
          id: ShipmentTrackingModel.fromJson(data).shipmentId!,
        ));
      } else {
        MagicRouter.navigateTo(
          BulkShipmentDetailsScreen(
              shipmentId: ShipmentTrackingModel.fromJson(data).shipmentId!),
        );
      }
      break;
    case 'tracking':
      Navigator.pushNamed(ctx, HandleShipment.id,
          arguments: ShipmentTrackingModel.fromJson(data));
      break;
    case 'wallet':
      Navigator.pushNamed(
        ctx,
        Wallet.id,
      );
      break;
    case 'chat':
      Navigator.pushNamed(ctx, ChatScreen.id,
          arguments: ChatData.fromJson(data));
      break;
    case '':
      showDialog(
          context: ctx,
          barrierDismissible: false,
          builder: (_) => const LoadingDialog());
      await auth.getShipmentStatus(
          ShipmentNotification.fromMap(data).shipmentId ?? 0);
      if (auth.shipmentStatusState == NetworkState.SUCCESS) {
        Navigator.pop(navigator.currentContext!);
        if (auth.canGoInside) {
          Navigator.pushNamed(
            navigator.currentContext!,
            ChooseCourier.id,
            arguments: ShipmentNotification.fromMap(data),
          );
        } else {
          if (ShipmentNotification.fromMap(data).childrenShipment == 0) {
            MagicRouter.navigateTo(ShipmentDetailsScreen(
              id: ShipmentTrackingModel.fromJson(data).shipmentId!,
            ));
          } else {
            MagicRouter.navigateTo(
              BulkShipmentDetailsScreen(
                  shipmentId: ShipmentNotification.fromMap(data).shipmentId!),
            );
          }
        }
      } else if (auth.shipmentStatusState == NetworkState.ERROR) {
        Navigator.pop(navigator.currentContext!);
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
      break;
    case 'decline_offer':
      Navigator.pushNamed(
        ctx,
        ChooseCourier.id,
        arguments: ShipmentNotification.fromMap(data),
      );
      break;
    case 'shipment':
      if (data['has_children'] == 0) {
        MagicRouter.navigateTo(ShipmentDetailsScreen(
          id: data['shipment_id'],
        ));
      } else {
        MagicRouter.navigateTo(
          BulkShipmentDetailsScreen(shipmentId: data['shipment_id']),
        );
      }
      break;
  }
}
