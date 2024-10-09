import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Dialogs/shipment_to_public_dialog.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/choose_captain_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/loading_widget.dart';
import 'choose_courier.dart';
import 'home.dart';

class AfterChooseShipment extends StatefulWidget {
  static String id = 'AfterChooseShipment';

  const AfterChooseShipment({super.key});

  @override
  State<AfterChooseShipment> createState() => _AfterChooseShipmentState();
}

class _AfterChooseShipmentState extends State<AfterChooseShipment> {
  @override
  Widget build(BuildContext context) {
    final ChooseCaptainProvider chooseCaptainProvider =
        Provider.of<ChooseCaptainProvider>(context);
    final AddShipmentProvider addShipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (addShipmentProvider.shipmentFromInside) {
          addShipmentProvider.setShipmentFromInside(false);
          MagicRouter.pop();
        } else {
          showDialog(
            context: navigator.currentContext!,
            barrierDismissible: false,
            builder: (context) => ActionDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              title: 'الخروج',
              content: 'لن يتم نشر شحنتك للمناديب\nهل تود ذلك ؟',
              onApproveClick: () {
                MagicRouter.pop();
                showDialog(
                  context: navigator.currentContext!,
                  barrierDismissible: false,
                  builder: (context) => ActionDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    content:
                        'يمكنك شحن شحنتك للمناديب مرة اخري من تفاصيل الشحنة',
                    onCancelClick: () {
                      MagicRouter.pop();
                      Navigator.pushNamedAndRemoveUntil(
                          context, Home.id, (route) => false);
                    },
                    cancelAction: 'حسنا',
                  ),
                );
              },
              onCancelClick: () {
                MagicRouter.pop();
              },
              approveAction: 'نعم',
              cancelAction: 'لا',
            ),
          );
        }

        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (addShipmentProvider.shipmentFromInside) {
                  addShipmentProvider.setShipmentFromInside(false);
                  MagicRouter.pop();
                } else {
                  showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      title: 'الخروج',
                      content: 'لن يتم نشر شحنتك للمناديب\nهل تود ذلك ؟',
                      onApproveClick: () {
                        MagicRouter.pop();
                        showDialog(
                          context: navigator.currentContext!,
                          barrierDismissible: false,
                          builder: (context) => ActionDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                            content:
                                'يمكنك شحن شحنتك للمناديب مرة اخري من تفاصيل الشحنة',
                            onCancelClick: () {
                              MagicRouter.pop();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Home.id, (route) => false);
                            },
                            cancelAction: 'حسنا',
                          ),
                        );
                      },
                      onCancelClick: () {
                        MagicRouter.pop();
                      },
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
              ),
            ),
          ),
          body: LoadingWidget(
            isLoading: chooseCaptainProvider.state == NetworkState.WAITING,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/bicycle_guy_1500px_resized.png',
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await chooseCaptainProvider
                                  .postShipmentToGetOffers(
                                      shipmentId: addShipmentProvider
                                          .captainShipmentId!);
                              if (chooseCaptainProvider.state ==
                                  NetworkState.SUCCESS) {
                                addShipmentProvider
                                    .setShipmentFromInside(false);
                                Navigator.pushReplacementNamed(
                                  navigator.currentContext!,
                                  ChooseCourier.id,
                                  arguments:
                                      addShipmentProvider.shipmentNotification,
                                );
                              } else if (chooseCaptainProvider.state ==
                                  NetworkState.LOGOUT) {
                                check(
                                    ctx: navigator.currentContext!,
                                    auth: authProvider,
                                    state: chooseCaptainProvider.state!);
                              } else {
                                showDialog(
                                  context: navigator.currentContext!,
                                  builder: (context) => ActionDialog(
                                    content: 'تأكد من الاتصال بشبكة الانترنت',
                                    cancelAction: 'حسناً',
                                    onCancelClick: () {
                                      MagicRouter.pop();
                                    },
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4.0),
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              decoration: BoxDecoration(
                                color: const Color(0xffFEF0E5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'عروض الشحن',
                                          style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            height: 1.18,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(
                                          height: 2.0.h,
                                        ),
                                        // ابدأ في استقبال عروض الشحن من الكباتن واختار العرض المناسب يدوياً
                                        Text(
                                          'ابدأ في استقبال عروض الشحن من الكباتن واختار العرض المناسب يدوياً',
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: Colors.grey[600],
                                            height: 1.18,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      'assets/images/walking_guy_1500px_resized.png',
                                      height: 100.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await chooseCaptainProvider
                                  .postShipmentToCouriers(
                                shipmentId:
                                    addShipmentProvider.captainShipmentId!,
                              );
                              if (chooseCaptainProvider.state ==
                                  NetworkState.SUCCESS) {
                                addShipmentProvider
                                    .setShipmentFromInside(false);
                                showDialog(
                                  context: navigator.currentContext!,
                                  barrierDismissible: true,
                                  builder: (context) =>
                                      const ShipmentToPublicDialog(),
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 700),
                                  () {
                                    MagicRouter.pop();
                                    Navigator.pushNamedAndRemoveUntil(
                                        navigator.currentContext!,
                                        Home.id,
                                        (route) => false);
                                  },
                                );
                              } else if (chooseCaptainProvider.state ==
                                  NetworkState.LOGOUT) {
                                check(
                                    ctx: navigator.currentContext!,
                                    auth: authProvider,
                                    state: chooseCaptainProvider.state!);
                              } else {
                                showDialog(
                                  context: navigator.currentContext!,
                                  builder: (context) => ActionDialog(
                                    content: 'تأكد من الاتصال بشبكة الانترنت',
                                    cancelAction: 'حسناً',
                                    onCancelClick: () {
                                      MagicRouter.pop();
                                    },
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4.0),
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              decoration: BoxDecoration(
                                color: const Color(0xffE2F5F3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ويفو دايركت',
                                          style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            height: 1.18,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(
                                          height: 2.0.h,
                                        ),
                                        Text(
                                          'قدم طلب الشحن وهيتم قبول عروض الشحن تلقائياً بنفس تكلفة الشحن المحددة',
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: Colors.grey[600],
                                            height: 1.18,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      'assets/images/weevo_direct_icon.png',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
