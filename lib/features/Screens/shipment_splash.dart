import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../../core_new/helpers/spacing.dart';
import '../waslny/ui/screens/wasully_screen.dart';
import 'add_shipment.dart';

class ShipmentSplash extends StatefulWidget {
  static const String id = 'SHIPMENT_SPLASH';

  const ShipmentSplash({super.key});

  @override
  State<ShipmentSplash> createState() => _ShipmentSplashState();
}

class _ShipmentSplashState extends State<ShipmentSplash> {
  @override
  Widget build(BuildContext context) {
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              MagicRouter.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
            ),
          ),
          title: const Text(
            'إضافة طلب',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(10),
                    Text(
                      'عندك طرد شخصي و محتاج توصله !',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w700,
                        color: weevoPrimaryBlueColor,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        MagicRouter.navigateTo(const WasullyScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                          top: 10.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20.0.r,
                          ),
                          color: weevoPrimaryOrangeColorWithOpacity,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'خدمة وصلي',
                                    style: TextStyle(
                                      fontSize: 25.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0.h,
                                  ),
                                  Text(
                                    'وصل أي حاجة من أي مكان لأي مكان',
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5.0.w,
                            ),
                            Image.asset(
                              'assets/images/bicycle_guy_1500px.png',
                              fit: BoxFit.cover,
                              height: 150.0.h,
                              width: 150.0.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'تاجر و عندك شحنات !',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w700,
                        color: weevoPrimaryBlueColor,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        shipmentProvider.setShipmentFromWhere(oneShipment);
                        Navigator.pushNamed(
                          context,
                          AddShipment.id,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                          top: 10.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20.0.r,
                          ),
                          color: const Color(0xffF5F5F5),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'شحنة واحدة',
                                    style: TextStyle(
                                      fontSize: 25.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0.h,
                                  ),
                                  Text(
                                    'شحنة واحدة يتم توصيلها بواسطة كابتن واحد',
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10.0.w,
                            ),
                            Image.asset(
                              'assets/images/alarm_guy_1500px_resized.png',
                              height: 150.0.h,
                              width: 150.0.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        shipmentProvider
                            .setShipmentFromWhere(moreThanOneShipment);
                        Navigator.pushNamed(context, AddShipment.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                          top: 10.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20.0.r,
                          ),
                          color: const Color(0xffF5F5F5),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'أكثر من شحنة',
                                    style: TextStyle(
                                      fontSize: 25.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0.h,
                                  ),
                                  Text(
                                    'مجموعة شحنات يتم توصيلها بواسطة كابتن واحد في نفس المحافظة او المنطقة',
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10.0.w,
                            ),
                            Image.asset(
                              'assets/images/box_holder_guy_1500px_resized.png',
                              height: 150.0.h,
                              width: 150.0.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // Expanded(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       shipmentProvider.setShipmentFromWhere(
                    //           giftShipment);
                    //       Navigator.pushNamed(
                    //         context,
                    //         AddShipment.id,
                    //       );
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.fromLTRB(
                    //         0.0,
                    //         8.0,
                    //         8.0,
                    //         0.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(
                    //           20.0.r,
                    //         ),
                    //         color:
                    //             weevoPrimaryOrangeColorWithOpacity,
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //             flex: 1,
                    //             child: Column(
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.start,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.center,
                    //               children: [
                    //                 Text(
                    //                   'طرد شخصي',
                    //                   style: TextStyle(
                    //                     fontSize: 20.0.sp,
                    //                     fontWeight:
                    //                         FontWeight.w700,
                    //                     color: Colors.black,
                    //                   ),
                    //                 ),
                    //                 Expanded(
                    //                   child: Text(
                    //                     'طرد شخصي يتم توصيله بواسطة كابتن واحد',
                    //                     textAlign:
                    //                         TextAlign.start,
                    //                     style: TextStyle(
                    //                       fontSize: 14.0.sp,
                    //                       fontWeight:
                    //                           FontWeight.w500,
                    //                       color:
                    //                           Colors.grey[800],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 5.0.w,
                    //           ),
                    //           Expanded(
                    //             flex: 1,
                    //             child: Image.asset(
                    //               'assets/images/gift_box.png',
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // Expanded(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       Navigator.pushNamed(
                    //         context,
                    //         ShipmentFromExcel.id,
                    //       );
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.fromLTRB(
                    //         0.0,
                    //         8.0,
                    //         8.0,
                    //         0.0,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(
                    //           20.0.r,
                    //         ),
                    //         color:
                    //         weevoExcelBackgroundColor.withOpacity(0.1),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //             flex: 1,
                    //             child: Column(
                    //               crossAxisAlignment:
                    //               CrossAxisAlignment.start,
                    //               mainAxisAlignment:
                    //               MainAxisAlignment.center,
                    //               children: [
                    //                 Text(
                    //                   'ملف اكسل',
                    //                   style: TextStyle(
                    //                     fontSize: 20.0.sp,
                    //                     fontWeight:
                    //                     FontWeight.w700,
                    //                     color: Colors.black,
                    //                   ),
                    //                 ),
                    //                 Expanded(
                    //                   child: Text(
                    //                     'مجموعة شحنات يتم أضافتها من ملف اكسل',
                    //                     textAlign:
                    //                     TextAlign.start,
                    //                     style: TextStyle(
                    //                       fontSize: 14.0.sp,
                    //                       fontWeight:
                    //                       FontWeight.w500,
                    //                       color:
                    //                       Colors.grey[800],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 5.0.w,
                    //           ),
                    //           Expanded(
                    //             flex: 1,
                    //             child: Image.asset(
                    //               'assets/images/excel_logo.png',
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
