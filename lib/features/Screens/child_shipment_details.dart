// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:weevo_merchant_upgrade/core_new/networking/api_constants.dart';

// import '../../core/Dialogs/action_dialog.dart';
// import '../../core/Dialogs/cancel_shipment_dialog.dart';
// import '../../core/Dialogs/loading.dart';
// import '../../core/Models/shipment_notification.dart';
// import '../../core/Models/shipment_tracking_model.dart';
// import '../../core/Providers/add_shipment_provider.dart';
// import '../../core/Providers/auth_provider.dart';
// import '../../core/Providers/choose_captain_provider.dart';
// import '../../core/Providers/display_shipment_provider.dart';
// import '../../core/Storage/shared_preference.dart';
// import '../../core/Utilits/colors.dart';
// import '../../core/Utilits/constants.dart';
// import '../../core/router/router.dart';
// import '../Widgets/child_shipment_item.dart';
// import '../Widgets/weevo_button.dart';
// import '../shipment_details/ui/shipment_details_screen.dart';
// import '../shipments/ui/screens/shipments_screen.dart';
// import 'choose_courier.dart';
// import 'handle_shipment.dart';
// import 'home.dart';

// class ChildShipmentDetails extends StatefulWidget {
//   static const String id = 'ShipmentSummery';
//   final int shipmentId;

//   const ChildShipmentDetails({
//     super.key,
//     required this.shipmentId,
//   });

//   @override
//   State<ChildShipmentDetails> createState() => _ChildShipmentDetailsState();
// }

// class _ChildShipmentDetailsState extends State<ChildShipmentDetails> {
//   late DisplayShipmentProvider _displayShipmentProvider;
//   late AuthProvider _authProvider;
//   final Preferences _preferences = Preferences.instance;

//   @override
//   void initState() {
//     super.initState();
//     _displayShipmentProvider =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _displayShipmentProvider.getBulkShipmentById(widget.shipmentId);
//     check(
//         auth: _authProvider,
//         state: _displayShipmentProvider.bulkShipmentByIdState!,
//         ctx: context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final shipmentProvider = Provider.of<AddShipmentProvider>(context);
//     final DisplayShipmentProvider displayShipmentProvider =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     final AddShipmentProvider addShipmentProvider =
//         Provider.of<AddShipmentProvider>(context);
//     final AuthProvider authProvider =
//         Provider.of<AuthProvider>(context, listen: false);
//     final chooseCaptainProvider = Provider.of<ChooseCaptainProvider>(context);
//     return WillPopScope(
//       onWillPop: () async {
//         if (displayShipmentProvider.fromNewShipment) {
//           MagicRouter.navigateAndPop(const ShipmentsScreen());
//         } else if (displayShipmentProvider.acceptNewShipment &&
//             displayShipmentProvider.fromChildrenReview) {
//           displayShipmentProvider.setAcceptNewShipment(false);
//           displayShipmentProvider.setFromChildrenReview(false);
//           Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
//         } else if (authProvider.fromOutsideNotification) {
//           authProvider.setFromOutsideNotification(false);
//           Navigator.pushReplacementNamed(context, Home.id);
//         } else {
//           MagicRouter.pop();
//         }
//         return false;
//       },
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Consumer<DisplayShipmentProvider>(
//           builder: (context, data, child) => Scaffold(
//             appBar: AppBar(
//               leading: IconButton(
//                 onPressed: () {
//                   if (displayShipmentProvider.fromNewShipment) {
//                     MagicRouter.navigateAndPop(const ShipmentsScreen());
//                   } else if (displayShipmentProvider.acceptNewShipment &&
//                       displayShipmentProvider.fromChildrenReview) {
//                     displayShipmentProvider.setAcceptNewShipment(false);
//                     displayShipmentProvider.setFromChildrenReview(false);
//                     Navigator.pushNamedAndRemoveUntil(
//                         context, Home.id, (route) => false);
//                   } else if (authProvider.fromOutsideNotification) {
//                     authProvider.setFromOutsideNotification(false);
//                     Navigator.pushReplacementNamed(context, Home.id);
//                   } else {
//                     MagicRouter.pop();
//                   }
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back_ios_outlined,
//                 ),
//               ),
//               title: Row(
//                 children: [
//                   const Expanded(
//                     child: Center(
//                       child: Text(
//                         'ملخص الطلبات',
//                       ),
//                     ),
//                   ),
//                   data.bulkShipmentByIdState == NetworkState.WAITING ||
//                           addShipmentProvider.state == NetworkState.WAITING ||
//                           data.merchantAcceptedShipmentState ==
//                               NetworkState.WAITING ||
//                           data.offerBasedState == NetworkState.WAITING ||
//                           data.availableState == NetworkState.WAITING ||
//                           data.onDeliveryState == NetworkState.WAITING ||
//                           data.unCompletedState == NetworkState.WAITING ||
//                           data.cancelledState == NetworkState.WAITING
//                       ? Container()
//                       : (data.bulkShipmentById!.status == 'available' &&
//                               data.bulkShipmentById!.isOfferBased == 1)
//                           ? GestureDetector(
//                               onTap: () {
//                                 Navigator.pushReplacementNamed(
//                                   context,
//                                   ChooseCourier.id,
//                                   arguments: ShipmentNotification(
//                                     merchantName: authProvider.name,
//                                     merchantImage: authProvider.photo,
//                                     merchantFcmToken: authProvider.fcmToken,
//                                     receivingState:
//                                         data.bulkShipmentById!.receivingState,
//                                     receivingCity: null,
//                                     deliveryCity: null,
//                                     childrenShipment:
//                                         data.bulkShipmentById!.children!.length,
//                                     deliveryState:
//                                         data.bulkShipmentById!.deliveringState,
//                                     shipmentId: data.bulkShipmentById!.id,
//                                     shippingCost: data
//                                         .bulkShipmentById!.expectedShippingCost,
//                                     totalShipmentCost:
//                                         data.bulkShipmentById!.amount,
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(
//                                     20.0,
//                                   ),
//                                   color:
//                                       _preferences.getWeevoShipmentOfferCount(
//                                                   data.bulkShipmentById!.id
//                                                       .toString()) <=
//                                               0
//                                           ? weevoPrimaryOrangeColor
//                                           : weevoPrimaryBlueColor,
//                                 ),
//                                 padding: const EdgeInsets.all(
//                                   12.0,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       _preferences.getWeevoShipmentOfferCount(
//                                                   data.bulkShipmentById!.id
//                                                       .toString()) <=
//                                               0
//                                           ? 'في انتظار العروض'
//                                           : 'لديك ${_preferences.getWeevoShipmentOfferCount(data.bulkShipmentById!.id.toString())} عرض',
//                                       style: const TextStyle(
//                                         fontSize: 12.0,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 4.0.w,
//                                     ),
//                                     const SpinKitThreeBounce(
//                                       color: Colors.white,
//                                       size: 10.0,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : Container(),
//                 ],
//               ),
//             ),
//             body: data.bulkShipmentByIdState == NetworkState.WAITING ||
//                     addShipmentProvider.state == NetworkState.WAITING ||
//                     data.merchantAcceptedShipmentState ==
//                         NetworkState.WAITING ||
//                     data.offerBasedState == NetworkState.WAITING ||
//                     data.availableState == NetworkState.WAITING ||
//                     data.onDeliveryState == NetworkState.WAITING ||
//                     data.unCompletedState == NetworkState.WAITING ||
//                     data.cancelledState == NetworkState.WAITING
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                           weevoPrimaryOrangeColor),
//                     ),
//                   )
//                 : Column(
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: data.bulkShipmentById!.children!.length,
//                           itemBuilder: (context, i) => ChildShipmentItem(
//                             shipment: data.bulkShipmentById!.children![i],
//                             onItemClick: () {
//                               MagicRouter.navigateTo(ShipmentDetailsScreen(
//                                 id: data.bulkShipmentById!.children![i].id!,
//                               ));
//                             },
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(
//                           8.0,
//                         ),
//                         child: Row(
//                           children: [
//                             data.bulkShipmentById!.status ==
//                                         'merchant-accepted-shipping-offer' ||
//                                     data.bulkShipmentById!.status ==
//                                         'courier-applied-to-shipment' ||
//                                     data.bulkShipmentById!.status ==
//                                         'on-the-way-to-get-shipment-from-merchant'
//                                 ? Expanded(
//                                     child: WeevoButton(
//                                       isStable: true,
//                                       color: weevoPrimaryOrangeColor,
//                                       onTap: () async {
//                                         DocumentSnapshot courierToken =
//                                             await FirebaseFirestore.instance
//                                                 .collection('courier_users')
//                                                 .doc(data
//                                                     .bulkShipmentById!.courierId
//                                                     .toString()
//                                                     .toString())
//                                                 .get();
//                                         String courierNationalId =
//                                             courierToken['national_id'];

//                                         Navigator.pushNamed(
//                                             navigator.currentContext!,
//                                             HandleShipment.id,
//                                             arguments: ShipmentTrackingModel(
//                                                 courierNationalId:
//                                                     courierNationalId,
//                                                 merchantNationalId:
//                                                     authProvider.getNationalId,
//                                                 shipmentId:
//                                                     data.bulkShipmentById!.id,
//                                                 deliveringState: data
//                                                     .bulkShipmentById!
//                                                     .children![0]
//                                                     .deliveringState,
//                                                 deliveringCity: data
//                                                     .bulkShipmentById!
//                                                     .children![0]
//                                                     .deliveringCity,
//                                                 receivingState: data
//                                                     .bulkShipmentById!
//                                                     .children![0]
//                                                     .receivingState,
//                                                 receivingCity: data
//                                                     .bulkShipmentById!
//                                                     .children![0]
//                                                     .receivingCity,
//                                                 deliveringLat: data
//                                                     .bulkShipmentById!
//                                                     .children![0]
//                                                     .deliveringLat,
//                                                 clientPhone: data
//                                                     .bulkShipmentById!
//                                                     .clientPhone,
//                                                 hasChildren: 1,
//                                                 status: data.bulkShipmentById!.status,
//                                                 deliveringLng: data.bulkShipmentById!.children![0].deliveringLng,
//                                                 receivingLng: data.bulkShipmentById!.children![0].receivingLng,
//                                                 receivingLat: data.bulkShipmentById!.children![0].receivingLat,
//                                                 merchantId: data.bulkShipmentById!.merchantId,
//                                                 merchantImage: authProvider.photo,
//                                                 merchantPhone: authProvider.phone,
//                                                 merchantName: authProvider.name,
//                                                 courierId: data.bulkShipmentById!.courierId,
//                                                 paymentMethod: data.bulkShipmentById!.paymentMethod,
//                                                 courierImage: data.bulkShipmentById!.courier!.photo,
//                                                 courierName: data.bulkShipmentById!.courier!.name,
//                                                 courierPhone: data.bulkShipmentById!.courier!.phone));
//                                       },
//                                       title: 'تتبع الطلب',
//                                     ),
//                                   )
//                                 : Container(),
//                             data.bulkShipmentById!.status == 'new'
//                                 ? Expanded(
//                                     child: WeevoButton(
//                                       isStable: true,
//                                       color: weevoPrimaryBlueColor,
//                                       onTap: () async {
//                                         showDialog(
//                                             context: navigator.currentContext!,
//                                             barrierDismissible: false,
//                                             builder: (_) =>
//                                                 const LoadingDialog());
//                                         addShipmentProvider
//                                             .setShipmentFromInside(true);
//                                         addShipmentProvider
//                                             .setCaptainShipmentId(
//                                                 data.bulkShipmentById!.id!);
//                                         addShipmentProvider
//                                             .setShipmentNotification(
//                                                 ShipmentNotification(
//                                                     receivingState: data
//                                                         .bulkShipmentById!
//                                                         .children![0]
//                                                         .receivingState,
//                                                     deliveryState:
//                                                         data
//                                                             .bulkShipmentById!
//                                                             .children![0]
//                                                             .deliveringState,
//                                                     shipmentId:
//                                                         data.bulkShipmentById!
//                                                             .id,
//                                                     shippingCost: data
//                                                         .bulkShipmentById!
//                                                         .children!
//                                                         .map((e) =>
//                                                             double.parse(e
//                                                                 .shippingCost!))
//                                                         .reduce(
//                                                             (value, element) =>
//                                                                 value + element)
//                                                         .toString()));
//                                         await chooseCaptainProvider
//                                             .postShipmentToGetOffers(
//                                                 shipmentId: shipmentProvider
//                                                     .captainShipmentId!);
//                                         if (chooseCaptainProvider.state ==
//                                             NetworkState.SUCCESS) {
//                                           Navigator.pop(
//                                               navigator.currentContext!);
//                                           shipmentProvider
//                                               .setShipmentFromInside(false);
//                                           Navigator.pushReplacementNamed(
//                                             navigator.currentContext!,
//                                             ChooseCourier.id,
//                                             arguments: shipmentProvider
//                                                 .shipmentNotification,
//                                           );
//                                           shipmentProvider.setIndex(0);
//                                           shipmentProvider.shipments.clear();
//                                         } else if (chooseCaptainProvider
//                                                 .state ==
//                                             NetworkState.LOGOUT) {
//                                           Navigator.pop(
//                                               navigator.currentContext!);
//                                           check(
//                                               ctx: navigator.currentContext!,
//                                               auth: authProvider,
//                                               state:
//                                                   chooseCaptainProvider.state!);
//                                         } else {
//                                           Navigator.pop(
//                                               navigator.currentContext!);
//                                           showDialog(
//                                             context: navigator.currentContext!,
//                                             builder: (context) => ActionDialog(
//                                               content:
//                                                   'تأكد من الاتصال بشبكة الانترنت',
//                                               cancelAction: 'حسناً',
//                                               onCancelClick: () {
//                                                 MagicRouter.pop();
//                                               },
//                                             ),
//                                           );
//                                         }
//                                       },
//                                       title: 'اشحن الاوردر',
//                                     ),
//                                   )
//                                 : Container(),
//                             data.bulkShipmentById?.status == 'available' ||
//                                     data.bulkShipmentById?.status == 'new' ||
//                                     data.bulkShipmentById?.status ==
//                                         'merchant-accepted-shipping-offer' ||
//                                     data.bulkShipmentById?.status ==
//                                         'courier-applied-to-shipment' ||
//                                     data.bulkShipmentById?.status ==
//                                         'on-the-way-to-get-shipment-from-merchant'
//                                 ? SizedBox(width: 10.h)
//                                 : Container(),
//                             data.bulkShipmentById?.status == 'available' ||
//                                     data.bulkShipmentById?.status == 'new' ||
//                                     data.bulkShipmentById?.status ==
//                                         'merchant-accepted-shipping-offer' ||
//                                     data.bulkShipmentById?.status ==
//                                         'courier-applied-to-shipment' ||
//                                     data.bulkShipmentById?.status ==
//                                         'on-the-way-to-get-shipment-from-merchant'
//                                 ? Expanded(
//                                     child: WeevoButton(
//                                       isStable: true,
//                                       color: Colors.red,
//                                       onTap: () async {
//                                         if (await authProvider
//                                             .checkConnection()) {
//                                           await cancelShippingCallback(
//                                               data,
//                                               addShipmentProvider,
//                                               authProvider);
//                                         } else {
//                                           showDialog(
//                                             context: navigator.currentContext!,
//                                             builder: (ctx) => ActionDialog(
//                                               content:
//                                                   'تأكد من الاتصال بشبكة الانترنت',
//                                               cancelAction: 'حسناً',
//                                               approveAction: 'حاول مرة اخري',
//                                               onApproveClick: () async {
//                                                 MagicRouter.pop();
//                                                 await cancelShippingCallback(
//                                                     data,
//                                                     addShipmentProvider,
//                                                     authProvider);
//                                               },
//                                               onCancelClick: () {
//                                                 MagicRouter.pop();
//                                               },
//                                             ),
//                                           );
//                                         }
//                                       },
//                                       title: 'إلغاءالطلب',
//                                     ),
//                                   )
//                                 : Container(),
//                             data.bulkShipmentById?.status ==
//                                     'bulk-shipment-cancelled'
//                                 ? Expanded(
//                                     child: WeevoButton(
//                                       isStable: true,
//                                       color: weevoPrimaryOrangeColor,
//                                       onTap: () async {
//                                         await addShipmentProvider
//                                             .restoreCancelShipment(
//                                                 shipmentId:
//                                                     data.bulkShipmentById!.id!);
//                                         if (addShipmentProvider
//                                                 .restoreShipmentState ==
//                                             NetworkState.SUCCESS) {
//                                           MagicRouter.pop();
//                                         } else if (addShipmentProvider
//                                                 .restoreShipmentState ==
//                                             NetworkState.LOGOUT) {
//                                           check(
//                                               auth: authProvider,
//                                               state: addShipmentProvider
//                                                   .restoreShipmentState!,
//                                               ctx: navigator.currentContext!);
//                                         }
//                                       },
//                                       title: 'أضافة الطلب',
//                                     ),
//                                   )
//                                 : Container(),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> cancelShippingCallback(
//       DisplayShipmentProvider data,
//       AddShipmentProvider addShipmentProvider,
//       AuthProvider authProvider) async {
//     showDialog(
//         context: navigator.currentContext!,
//         barrierDismissible: false,
//         builder: (ctx) => CancelShipmentDialog(onOkPressed: () async {
//               String status = data.bulkShipmentById!.status!;
//               Navigator.pop(navigator.currentContext!);
//               showDialog(
//                   context: navigator.currentContext!,
//                   barrierDismissible: false,
//                   builder: (context) => const LoadingDialog());
//               await addShipmentProvider.cancelShipment(
//                   shipmentId: data.bulkShipmentById!.id!);
//               if (addShipmentProvider.cancelShipmentState ==
//                   NetworkState.SUCCESS) {
//                 Navigator.pop(navigator.currentContext!);
//                 await showDialog(
//                     context: navigator.currentContext!,
//                     barrierDismissible: false,
//                     builder: (_) => ActionDialog(
//                           content: addShipmentProvider.cancelMessage,
//                           onApproveClick: () {
//                             Navigator.pop(navigator.currentContext!);
//                           },
//                           approveAction: 'حسناً',
//                         ));
//                 showDialog(
//                     context: navigator.currentContext!,
//                     barrierDismissible: false,
//                     builder: (context) => const LoadingDialog());

//                 if (status != 'available' && status != 'new') {
//                   DocumentSnapshot userToken = await FirebaseFirestore.instance
//                       .collection('courier_users')
//                       .doc(data.bulkShipmentById!.courierId.toString())
//                       .get();
//                   String token = userToken['fcmToken'];
//                   FirebaseFirestore.instance
//                       .collection('courier_notifications')
//                       .doc(data.bulkShipmentById!.courierId.toString())
//                       .collection(data.bulkShipmentById!.courierId.toString())
//                       .add({
//                     'read': false,
//                     'date_time': DateTime.now().toIso8601String(),
//                     'type': 'cancel_shipment',
//                     'title': 'تم إلغاء الطلب',
//                     'body':
//                         'قام التاجر ${authProvider.name} بالغاء الطلب يمكنك الذهاب للطلبات المتاحة والتقديم علي طلبات اخري',
//                     'user_icon': authProvider.photo != null &&
//                             authProvider.photo!.isNotEmpty
//                         ? authProvider.photo!.contains(ApiConstants.baseUrl)
//                             ? authProvider.photo
//                             : '${ApiConstants.baseUrl}${authProvider.photo}'
//                         : '',
//                     'screen_to': 'no_screen',
//                     'data': {
//                       'shipment_id': data.bulkShipmentById!.id,
//                     },
//                   });

//                   await Provider.of<AuthProvider>(navigator.currentContext!,
//                           listen: false)
//                       .sendNotification(
//                     title: 'تم إلغاء الطلب',
//                     body:
//                         'قام التاجر ${authProvider.name} بالغاء الطلب يمكنك الذهاب للطلبات المتاحة والتقديم علي طلبات اخري',
//                     image: authProvider.photo != null &&
//                             authProvider.photo!.isNotEmpty
//                         ? authProvider.photo!.contains(ApiConstants.baseUrl)
//                             ? authProvider.photo
//                             : '${ApiConstants.baseUrl}${authProvider.photo}'
//                         : '',
//                     screenTo: 'no_screen',
//                     type: 'cancel_shipment',
//                     data: {
//                       'shipment_id': data.bulkShipmentById!.id,
//                     },
//                     toToken: token,
//                   );
//                 }
//                 if (data.bulkShipmentById!.courier != null) {
//                   String merchantPhoneNumber =
//                       Preferences.instance.getPhoneNumber;
//                   String courierPhoneNumber =
//                       data.bulkShipmentById!.courier!.phone!;

//                   String locationId = '';
//                   if (merchantPhoneNumber.hashCode >=
//                       courierPhoneNumber.hashCode) {
//                     locationId =
//                         '$merchantPhoneNumber-$courierPhoneNumber-${data.bulkShipmentById!.id}';
//                   } else {
//                     locationId =
//                         '$courierPhoneNumber-$merchantPhoneNumber-${data.bulkShipmentById!.id}';
//                   }

//                                     FirebaseFirestore.instance
//                       .collection('locations')
//                       .doc(locationId)
//                       .set(
//                     {
//                       'status': 'closed',
//                       'shipmentId': '${data.bulkShipmentById!.id}'
//                     },
//                   );
//                 }

//                 Navigator.pop(navigator.currentContext!);
//                 Navigator.pop(navigator.currentContext!);
//               } else if (addShipmentProvider.cancelShipmentState ==
//                   NetworkState.LOGOUT) {
//                 check(
//                     auth: _authProvider,
//                     state: addShipmentProvider.cancelShipmentState!,
//                     ctx: navigator.currentContext!);
//               } else if (addShipmentProvider.cancelShipmentState ==
//                   NetworkState.ERROR) {
//                 MagicRouter.pop();
//                 showDialog(
//                     context: navigator.currentContext!,
//                     barrierDismissible: false,
//                     builder: (context) => ActionDialog(
//                           content: 'حدث خطأ من فضلك حاول مرة اخري',
//                           cancelAction: 'حسناً',
//                           onCancelClick: () {
//                             MagicRouter.pop();
//                           },
//                         ));
//               }
//             }, onCancelPressed: () {
//               MagicRouter.pop();
//             }));
//   }
// }
