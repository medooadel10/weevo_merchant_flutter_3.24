import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';

import '../../../core/Dialogs/action_dialog.dart';
import '../../../core/Dialogs/delete_account_dialog.dart';
import '../../../core/Dialogs/loading.dart';
import '../../../core/Dialogs/toggle_dialog.dart';
import '../../../core/Models/drawer_model.dart';
import '../../../core/Providers/auth_provider.dart';
import '../../../core/Providers/display_shipment_provider.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../../../core_new/widgets/custom_image.dart';
import '../change_your_email.dart';
import '../change_your_password.dart';
import '../change_your_phone_number.dart';
import '../merchant_address.dart';
import '../my_reviews.dart';
import '../profile_information.dart';
import '../wallet.dart';
import '../weevo_web_view_preview.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isLoading = false;
  final List<DrawerModel> _names = const [
    DrawerModel(
      image: 'assets/images/weevo_account_settings_icon.png',
      title: 'تعديل الحساب',
      color: Color(0xffED7230),
    ),
    DrawerModel(
      image: 'assets/images/weevo_my_address_icon.png',
      title: 'عناوينك',
      color: Color(0xff1DA4EA),
    ),
    DrawerModel(
      image: 'assets/images/weevo_wallet_icon.png',
      title: 'المحفظة',
      color: Color(0xff5532EB),
    ),
    DrawerModel(
      image: 'assets/images/technical_support.png',
      title: 'تحدث معنا',
      color: Color(0xffDE2D56),
    ),
    DrawerModel(
      image: 'assets/images/weevo_notification_icon.png',
      title: 'الأشعارات',
      color: Color(0xffED7230),
    ),
    // const DrawerModel(image: Icons.language, title: 'اللغة'),
    DrawerModel(
      image: 'assets/images/weevo_feedback.png',
      title: 'ملاحظات المستخدمين',
      color: Color(0xff1DA4EA),
    ),
    DrawerModel(
      image: 'assets/images/weevo_change_email_icon.png',
      title: 'تغيير البريد الالكتروني',
      color: Color(0xff5532EB),
    ),
    DrawerModel(
      image: 'assets/images/weevo_change_phone_icon.png',
      title: 'تغير رقم الهاتف',
      color: Color(0xffDE2D56),
    ),
    DrawerModel(
      image: 'assets/images/weevo_change_password_icon.png',
      title: 'تغير كلمة السر',
      color: Color(0xffED7230),
    ),
    DrawerModel(
      image: 'assets/images/facebook_icon.png',
      title: 'تابعنا علي فيس بوك',
      color: Color(0xff1DA4EA),
    ),
    DrawerModel(
      image: 'assets/images/weevo_who_are_we_icon.png',
      title: 'الشروط والاحكام',
      color: Color(0xff5532EB),
    ),
    DrawerModel(
      image: 'assets/images/weevo_how_to_use_icon.png',
      title: 'سياسة الخصوصية',
      color: Color(0xffDE2D56),
    ),
    DrawerModel(
      image: 'assets/images/weevo_exit_icon.png',
      title: 'تسجيل الخروج',
      color: Color(0xffED7230),
    ),
  ];
  String currentLang = 'English';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 35.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الحساب',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'تاجر',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      auth.photo!.isEmpty
                          ? const Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                              size: 110.0,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: CustomImage(
                                imageUrl: auth.photo,
                                height: 80.0,
                                width: 80.0,
                              ),
                            ),
                      SizedBox(
                        width: 20.0.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              auth.name!,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              auth.phone!,
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              auth.email!,
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (auth.getRating!.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            double.parse(auth.getRating!),
                                        minRating: 1,
                                        ignoreGestures: true,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 18.0,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: weevoLightYellow,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        auth.getRating
                                            .toString()
                                            .substring(0, 3),
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الشحنات',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Consumer<DisplayShipmentProvider>(
                        builder: (ctx, data, ch) =>
                            data.deliveredState == NetworkState.WAITING
                                ? const SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          weevoPrimaryOrangeColor),
                                    ),
                                  )
                                : Text(
                                    '${data.deliveredTotalItems}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ..._names.map(
              (item) => Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: _names.indexOf(item) == 4
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _isLoading
                                ? Container(
                                    margin: const EdgeInsetsDirectional.only(
                                      end: 10,
                                    ),
                                    height: 15.h,
                                    width: 15.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          weevoPrimaryOrangeColor),
                                    ))
                                : Container(),
                            Switch(
                              activeColor: weevoPrimaryOrangeColor,
                              value: auth.isOn ?? true,
                              onChanged: (bool value) async {
                                if (!_isLoading) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (value == true) {
                                    await auth.notificationOn();
                                  } else {
                                    await auth.notificationOff();
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  auth.setIsOn(value);
                                }
                              },
                            ),
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF6F5F8),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          height: 50.0.h,
                          width: 50.0.h,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 18.0,
                          ),
                        ),
                  leading: Container(
                    height: 50.0.h,
                    width: 50.0.h,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      item.image,
                      height: 30.0.h,
                      width: 30.0.h,
                      fit: BoxFit.contain,
                      color: item.color,
                    ),
                  ),
                  onTap: () async {
                    switch (_names.indexOf(item)) {
                      case 0:
                        Navigator.pushNamed(context, ProfileInformation.id);
                        break;
                      case 1:
                        Navigator.pushNamed(context, MerchantAddress.id);
                        break;
                      case 2:
                        if (await auth.authenticateWithBiometrics()) {
                          Navigator.pushNamed(
                              navigator.currentContext!, Wallet.id);
                        }
                        break;
                      case 3:
                        Freshchat.showConversations();
                        break;
                      case 5:
                        Navigator.pushNamed(context, MyReviews.id);

                        break;
                      case 6:
                        Navigator.pushNamed(context, ChangeYourEmail.id);
                        break;
                      case 7:
                        Navigator.pushNamed(context, ChangeYourPhone.id,
                            arguments: false);

                        break;
                      case 8:
                        Navigator.pushNamed(context, ChangeYourPassword.id);
                        break;
                      case 9:
                        await launchUrlString(
                            'https://www.facebook.com/weevosupport?mibextid=LQQJ4d');
                        break;
                      case 10:
                        Navigator.pushNamed(context, WeevoWebViewPreview.id,
                            arguments: 'https://weevo.net/terms-conditions/');
                        break;
                      case 11:
                        Navigator.pushNamed(context, WeevoWebViewPreview.id,
                            arguments: 'https://weevo.net/privacy-policy/');
                        break;
                      case 12:
                        showDialog(
                            context: navigator.currentContext!,
                            barrierDismissible: false,
                            builder: (ctx) {
                              bool allDevices = false;
                              return ToggleDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ),
                                ),
                                title: 'تسجيل خروج',
                                content: 'هل تود تسجيل الخروج من التطبيق',
                                approveAction: 'نعم',
                                toggleCallback: (bool v) {
                                  allDevices = v;
                                  log('$allDevices');
                                },
                                onApproveClick: () async {
                                  if (await auth.checkConnection()) {
                                    Navigator.pop(navigator.currentContext!);
                                    logoutUser(auth, allDevices);
                                  } else {
                                    Navigator.pop(navigator.currentContext!);
                                    showDialog(
                                      context: navigator.currentContext!,
                                      barrierDismissible: false,
                                      builder: (c) => ActionDialog(
                                        content:
                                            'تأكد من الاتصال بشبكة الانترنت',
                                        cancelAction: 'حسناً',
                                        approveAction: 'حاول مرة اخري',
                                        onApproveClick: () async {
                                          Navigator.pop(c);
                                          logoutUser(auth, allDevices);
                                        },
                                        onCancelClick: () {
                                          Navigator.pop(c);
                                        },
                                      ),
                                    );
                                  }
                                },
                                cancelAction: 'لا',
                                onCancelClick: () {
                                  Navigator.pop(ctx);
                                },
                              );
                            });
                        break;
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'رقم الأصدار ${auth.appVersion}',
                    style: TextStyle(
                      fontSize: 14.0.sp,
                    ),
                  )
                ],
              ),
            ),
            if (Platform.isIOS)
              SizedBox(
                height: 10.h,
              ),
            if (Platform.isIOS)
              InkWell(
                onTap: () {
                  showDialog(
                      context: navigator.currentContext!,
                      builder: (_) => const DeleteAccountDialog());
                },
                child: Container(
                  margin:
                      EdgeInsets.only(right: 20.w, left: 20.w, bottom: 20.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      color: weevoRedColor,
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'حذف الحساب',
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void logoutUser(AuthProvider auth, bool allDevices) async {
    showDialog(
        context: navigator.currentContext!,
        barrierDismissible: false,
        builder: (_) => const LoadingDialog());
    await auth.logout(allDevices);
  }
}
