import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/router/router.dart';
import '../Widgets/weevo_button.dart';
import 'login.dart';
import 'sign_up.dart';

class BeforeRegistration extends StatefulWidget {
  static const String id = 'BEFORE_REGISTRATION';

  const BeforeRegistration({super.key});

  @override
  State<BeforeRegistration> createState() => _BeforeRegistrationState();
}

class _BeforeRegistrationState extends State<BeforeRegistration> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: navigator.currentContext!,
          builder: (context) => ActionDialog(
            title: 'الخروج من التطبيق',
            content: 'هل تود الخروج من التطبيق',
            approveAction: 'نعم',
            cancelAction: 'لا',
            onApproveClick: () {
              MagicRouter.pop();
              SystemNavigator.pop();
            },
            onCancelClick: () {
              MagicRouter.pop();
            },
          ),
        );
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/intro_background.jpg'),
                  fit: BoxFit.fill),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(child: Container()),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/res_and_log_icon.png',
                                      height: 50.h,
                                    ),
                                    SizedBox(
                                      width: 20.0.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'أهلاً بيك في ويفو',
                                            style: TextStyle(
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            'يمكنك تسجيل الدخول او انشاء حساب',
                                            style: TextStyle(
                                                fontSize: 16.0.sp,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: WeevoButton(
                                  radius: 20.0,
                                  isStable: true,
                                  color: weevoPrimaryOrangeColor,
                                  title: 'تسجيل الدخول',
                                  onTap: () {
                                    Navigator.pushNamed(context, Login.id);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: WeevoButton(
                                  radius: 20.0,
                                  isStable: false,
                                  color: Colors.white,
                                  title: 'انشاء حساب',
                                  onTap: () {
                                    log('login');
                                    Navigator.pushNamed(context, SignUp.id);
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (Platform.isAndroid)
                            SizedBox(
                              height: 5.h,
                            ),
                          TextButton(
                            onPressed: () async {
                              String url = Platform.isAndroid
                                  ? 'https://play.google.com/store/apps/details?id=org.emarketingo.courier'
                                  : 'https://apps.apple.com/eg/app/%D9%88%D9%8A%DA%A4%D9%88-%D9%83%D8%A7%D8%A8%D8%AA%D9%86-weevo-captain/id6670524179';
                              await launchUrlString(url);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'لو انت كابتن حمل',
                                  style: TextStyle(
                                      fontSize: 16.0.sp, color: Colors.white),
                                ),
                                Text(
                                  ' تطبيق الكابتن',
                                  style: TextStyle(
                                      fontSize: 16.0.sp,
                                      color: weevoPrimaryOrangeColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
