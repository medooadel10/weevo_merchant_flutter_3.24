import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';

class Splash extends StatefulWidget {
  static String id = 'Splash';

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late AuthProvider _authProvider;
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: weevoPrimaryOrangeColor));
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    mainInit();
  }

  void mainInit() async {
    if (await _authProvider.checkConnection()) {
      packageInfo = await PackageInfo.fromPlatform();
      setState(() {});
      await _authProvider.initPreferences();
      await _authProvider.merchantUpdate(packageInfo!.version);
      if (_authProvider.merchantCriticalUpdateState == NetworkState.SUCCESS) {
        if (_authProvider.merchantCriticalUpdate?.shouldUpdate ?? false) {
          showDialog(
            context: navigator.currentContext!,
            barrierDismissible: false,
            builder: (ctx) => ActionDialog(
              content: 'عليك تحديث الاصدار الحالي',
              cancelAction: 'الخروج',
              approveAction: 'تحديث',
              onApproveClick: () async {
                MagicRouter.pop();
                Platform.isIOS
                    ? OpenStore.instance.open(
                        appStoreId: '6535652912',
                      )
                    : OpenStore.instance.open(
                        androidAppBundleId: packageInfo?.packageName,
                      );
              },
              onCancelClick: () {
                SystemNavigator.pop();
              },
            ),
          );
        } else {
          await _authProvider.getInitMessage();
          _authProvider.setAppVersion(appVersion: packageInfo?.version);
        }
      } else if (_authProvider.merchantCriticalUpdateState ==
          NetworkState.ERROR) {
        showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (ctx) => ActionDialog(
            content: 'تأكد من الاتصال بشبكة الانترنت',
            cancelAction: 'حسناً',
            approveAction: 'حاول مرة اخري',
            onApproveClick: () async {
              MagicRouter.pop();
              mainInit();
            },
            onCancelClick: () {
              MagicRouter.pop();
            },
          ),
        );
      }
    } else {
      showDialog(
        context: navigator.currentContext!,
        barrierDismissible: false,
        builder: (ctx) => ActionDialog(
          content: 'تأكد من الاتصال بشبكة الانترنت',
          cancelAction: 'حسناً',
          approveAction: 'حاول مرة اخري',
          onApproveClick: () async {
            MagicRouter.pop();
            mainInit();
          },
          onCancelClick: () {
            MagicRouter.pop();
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    if (!_authProvider.isValid) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Color(0xFFFFF5F1)));
    } else {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.white));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: weevoPrimaryOrangeColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            'assets/images/weevo_splash_screen_icon.gif',
            width: size.width,
            height: size.height,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  packageInfo != null
                      ? 'رقم الأصدار ${packageInfo?.version}'
                      : '',
                  style: TextStyle(fontSize: 14.0.sp, color: Colors.black),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
