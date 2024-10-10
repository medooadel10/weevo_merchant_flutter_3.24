import 'dart:developer';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';
import 'package:weevo_merchant_upgrade/firebase_options.dart';

import 'core/Storage/shared_preference.dart';
import 'core/Utilits/app_routes.dart';
import 'core/Utilits/firebase_notification.dart';
import 'core_new/di/dependency_injection.dart';
import 'core_new/networking/dio_factory.dart';
import 'core_new/style/app_theme.dart';
import 'features/wasully_details/logic/cubit/wasully_details_cubit.dart';
import 'features/wasully_handle_shipment/logic/cubit/wasully_handle_shipment_cubit.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message,
    {BuildContext? context}) async {
  log("Entered background handler");
  if (await Freshchat.isFreshchatNotification(message.data)) {
    log("Handling a freshchat message: ${message.data}");
    Freshchat.handlePushNotification(message.data);
  }
  if (message.notification != null) {
    log("Handling a background message: ${message.notification?.title}");
    log("Handling a background message: ${message.notification?.body}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Freshchat.init(
    '2540a172-9d87-4e8d-a28d-05b2fcef08fb',
    '90f02877-838c-42d2-876a-ef1b94346565',
    'msdk.freshchat.com',
    teamMemberInfoVisible: true,
    cameraCaptureEnabled: true,
    gallerySelectionEnabled: true,
    responseExpectationEnabled: true,
  );
  FirebaseMessaging.instance.setAutoInitEnabled(true);
  Freshchat.setPushRegistrationToken(
      await FirebaseMessaging.instance.getToken() ?? '');

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseNotification.iOSPermission();

  setupGetIt();
  await Preferences.initPref();
  DioFactory.init();
  log('Token ->> ${Preferences.instance.getAccessToken}');
  log('Fcm access token -> ${Preferences.instance.getFCMAccessToken}');
  runApp(const Weevo());
}

class Weevo extends StatelessWidget {
  static final facebookAppEvents = FacebookAppEvents();

  const Weevo({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (BuildContext context, Widget? w) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WasullyDetailsCubit(getIt()),
          ),
          BlocProvider(
            create: (context) => ShipmentDetailsCubit(getIt()),
          ),
          BlocProvider(
            create: (context) => WasullyHandleShipmentCubit(getIt()),
          ),
        ],
        child: MultiProvider(
          providers: providers,
          child: MaterialApp(
            navigatorKey: navigator,
            theme: AppTheme.lightTheme(context),
            title: 'Weevo | تطبيق',
            debugShowCheckedModeBanner: false,
            initialRoute: initRoute,
            routes: getRoutes(),
            onGenerateRoute: getOnGenerateRoute,
            supportedLocales: const [
              Locale('ar'),
            ],
            locale: const Locale('ar'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        ),
      ),
    );
  }
}
