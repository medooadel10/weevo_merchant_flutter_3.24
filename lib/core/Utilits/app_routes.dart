import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/Screens/Fragments/sign_up_phone_verification.dart';
import '../../features/Screens/add_address.dart';
import '../../features/Screens/add_product.dart';
import '../../features/Screens/add_shipment.dart';
import '../../features/Screens/after_choose_shipment.dart';
import '../../features/Screens/after_registration.dart';
import '../../features/Screens/before_registration.dart';
import '../../features/Screens/change_your_email.dart';
import '../../features/Screens/change_your_password.dart';
import '../../features/Screens/change_your_phone_number.dart';
import '../../features/Screens/chat_screen.dart';
import '../../features/Screens/child_shipment_details.dart';
import '../../features/Screens/choose_courier.dart';
import '../../features/Screens/end_payment.dart';
import '../../features/Screens/handle_shipment.dart';
import '../../features/Screens/home.dart';
import '../../features/Screens/image_display_screen.dart';
import '../../features/Screens/login.dart';
import '../../features/Screens/map.dart';
import '../../features/Screens/merchant_address.dart';
import '../../features/Screens/merchant_feedback.dart';
import '../../features/Screens/merchant_warehouse.dart';
import '../../features/Screens/messages.dart';
import '../../features/Screens/my_reviews.dart';
import '../../features/Screens/new_shipment_offer_based.dart';
import '../../features/Screens/onboarding_screens.dart';
import '../../features/Screens/product_details.dart';
import '../../features/Screens/profile_information.dart';
import '../../features/Screens/promo_code.dart';
import '../../features/Screens/reset_password.dart';
import '../../features/Screens/shipment_splash.dart';
import '../../features/Screens/shipment_tracking_map.dart';
import '../../features/Screens/sign_up.dart';
import '../../features/Screens/splash_screen.dart';
import '../../features/Screens/transaction_webview.dart';
import '../../features/Screens/video_preview_list.dart';
import '../../features/Screens/wallet.dart';
import '../../features/Screens/weevo_ads.dart';
import '../../features/Screens/weevo_payment.dart';
import '../../features/Screens/weevo_plus_plan_subscription.dart';
import '../../features/Screens/weevo_plus_screen.dart';
import '../../features/Screens/weevo_web_view_preview.dart';
import '../Models/add_product_arg.dart';
import '../Models/chat_data.dart';
import '../Models/connectivity_enum.dart';
import '../Models/feedback_data_arg.dart';
import '../Models/fill_address_arg.dart';
import '../Models/plus_plan.dart';
import '../Models/shipment_notification.dart';
import '../Models/shipment_tracking_model.dart';
import '../Models/transaction_webview_model.dart';
import '../Models/weevo_plus_payment.dart';
import '../Providers/add_shipment_provider.dart';
import '../Providers/auth_provider.dart';
import '../Providers/choose_captain_provider.dart';
import '../Providers/display_shipment_provider.dart';
import '../Providers/forget_password_provider.dart';
import '../Providers/freshchat_provider.dart';
import '../Providers/map_provider.dart';
import '../Providers/product_provider.dart';
import '../Providers/profile_provider.dart';
import '../Providers/shipment_tracking_provider.dart';
import '../Providers/update_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Providers/weevo_plus_provider.dart';
import 'connectivity_watcher.dart';

String initRoute = Splash.id;

Map<String, Widget Function(BuildContext)> getRoutes() => {
      MerchantAddress.id: (_) => const MerchantAddress(),
      WeevoPlusPlanSubscription.id: (_) => const WeevoPlusPlanSubscription(),
      Splash.id: (_) => const Splash(),
      VideoPreviewList.id: (_) => const VideoPreviewList(),
      OnBoarding.id: (_) => const OnBoarding(),
      NewShipmentHost.id: (_) => const NewShipmentHost(),
      Login.id: (_) => const Login(),
      ResetPassword.id: (_) => const ResetPassword(),
      BeforeRegistration.id: (_) => const BeforeRegistration(),
      AfterRegistration.id: (_) => const AfterRegistration(),
      MyReviews.id: (_) => const MyReviews(),
      SignUp.id: (_) => const SignUp(),
      SignUpPhoneVerification.id: (_) => const SignUpPhoneVerification(),
      Home.id: (_) => const Home(),
      PromoCode.id: (_) => const PromoCode(),
      // Shipment.id: (_) => Shipment(),
      ShipmentSplash.id: (_) => const ShipmentSplash(),
      Wallet.id: (_) => const Wallet(),
      WeevoAds.id: (_) => const WeevoAds(),
      AddShipment.id: (_) => const AddShipment(),
      MerchantWarehouse.id: (_) => const MerchantWarehouse(),
      AfterChooseShipment.id: (_) => const AfterChooseShipment(),
      ProfileInformation.id: (_) => const ProfileInformation(),
      ChangeYourEmail.id: (_) => const ChangeYourEmail(),
      ChangeYourPassword.id: (_) => const ChangeYourPassword(),
      ChangeYourPhone.id: (_) => const ChangeYourPhone(),
    };

Route<dynamic>? getOnGenerateRoute(RouteSettings settings) {
  if (settings.name == ProductDetails.id) {
    final int id = settings.arguments as int;
    return MaterialPageRoute(
      builder: (_) => ProductDetails(
        productId: id,
      ),
    );
  } else if (settings.name == MapScreen.id) {
    final bool fromShipment = settings.arguments as bool;
    return MaterialPageRoute(
      builder: (_) => MapScreen(
        fromShipment: fromShipment,
      ),
    );
  } else if (settings.name == MerchantFeedback.id) {
    final FeedbackDataArg v = settings.arguments as FeedbackDataArg;
    return MaterialPageRoute(
      builder: (context) => MerchantFeedback(arg: v),
    );
  } else if (settings.name == WeevoWebViewPreview.id) {
    final String v = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => WeevoWebViewPreview(url: v),
    );
  } else if (settings.name == EndPayment.id) {
    final WeevoPlusPaymentObject v =
        settings.arguments as WeevoPlusPaymentObject;
    return MaterialPageRoute(
      builder: (context) => EndPayment(value: v),
    );
  } else if (settings.name == TransactionWebView.id) {
    final TransactionWebViewModel v =
        settings.arguments as TransactionWebViewModel;
    return MaterialPageRoute(
      builder: (context) => TransactionWebView(model: v),
    );
  } else if (settings.name == HandleShipment.id) {
    final ShipmentTrackingModel v = settings.arguments as ShipmentTrackingModel;
    return MaterialPageRoute(
      builder: (context) => HandleShipment(model: v),
    );
  } else if (settings.name == WeevoPlusPayment.id) {
    final PlusPlan v = settings.arguments as PlusPlan;
    return MaterialPageRoute(
      builder: (context) => WeevoPlusPayment(plusPlan: v),
    );
  } else if (settings.name == ImageDisplayScreen.id) {
    final String imageUrl = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => ImageDisplayScreen(imageUrl: imageUrl),
    );
  } else if (settings.name == Messages.id) {
    final bool fromHome = settings.arguments as bool;
    return MaterialPageRoute(
      builder: (context) => Messages(fromHome: fromHome),
    );
  } else if (settings.name == ChatScreen.id) {
    final ChatData chatData = settings.arguments as ChatData;
    return MaterialPageRoute(
      builder: (context) => ChatScreen(chatData: chatData),
    );
  } else if (settings.name == WeevoPlus.id) {
    final bool v = settings.arguments as bool;
    return MaterialPageRoute(
      builder: (context) => WeevoPlus(isPreview: v),
    );
  } else if (settings.name == ShipmentTrackingMap.id) {
    final ShipmentTrackingModel v = settings.arguments as ShipmentTrackingModel;
    return MaterialPageRoute(
      builder: (context) => ShipmentTrackingMap(model: v),
    );
  } else if (settings.name == ChooseCourier.id) {
    final ShipmentNotification shipmentNotification =
        settings.arguments as ShipmentNotification;
    return MaterialPageRoute(
      builder: (context) =>
          ChooseCourier(shipmentNotification: shipmentNotification),
    );
  } else if (settings.name == AddProduct.id) {
    final AddProductArg arg = settings.arguments as AddProductArg;
    return MaterialPageRoute(
      builder: (_) => AddProduct(
        isUpdated: arg.isUpdated,
        isDuplicate: arg.isDuplicate,
        product: arg.product,
        from: arg.from ?? '',
      ),
    );
  } else if (settings.name == ChildShipmentDetails.id) {
    final int shipmentId = settings.arguments as int;
    return MaterialPageRoute(
      builder: (_) => ChildShipmentDetails(
        shipmentId: shipmentId,
      ),
    );
  } else if (settings.name == AddAddress.id) {
    final FillAddressArg arg = settings.arguments as FillAddressArg;
    return MaterialPageRoute(
      builder: (_) => AddAddress(
        isUpdated: arg.isUpdated,
        address: arg.address,
      ),
    );
  } else {
    return null;
  }
}

List<SingleChildWidget> providers = [
  StreamProvider(
      create: (ctx) => ConnectivityService().connectionStatusController.stream,
      initialData: ConnectivityStatus.offline),
  ChangeNotifierProvider(
    create: (context) => MapProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => FreshChatProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => ForgetPasswordProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => ShipmentTrackingProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => DisplayShipmentProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => WeevoPlusProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => UpdateProfileProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => WalletProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => ProductProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => ProfileProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => AuthProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => AddShipmentProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => ChooseCaptainProvider(),
  ),
];
