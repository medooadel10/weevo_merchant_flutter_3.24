// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// class OnDeliveryShipmentHost extends StatefulWidget {
//   const OnDeliveryShipmentHost({
//     super.key,
//   });

//   @override
//   State<> createState() => _OnDeliveryShipmentHostState();
// }

// class _OnDeliveryShipmentHostState extends State<OnDeliveryShipmentHost> {
//   DisplayShipmentProvider _displayShipment;
//   ScrollController _scrollController;
//   AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _displayShipment =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _displayShipment.getOnDeliveryShipment(
//         isPagination: false, isFirstTime: true, isRefreshing: false);
//     check(
//         auth: _authProvider,
//         state: _displayShipment.onDeliveryState,
//         ctx: context);
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_displayShipment.onDeliveryNextPageLoading) {
//           _displayShipment.onDeliveryNextPage();
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final displayShipment = Provider.of<DisplayShipmentProvider>(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         body: RefreshIndicator(
//           onRefresh: () => displayShipment.clearOnDeliveryShipmentList(),
//           child: displayShipment.onDeliveryState == NetworkState.WAITING
//               ? Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       weevoPrimaryOrangeColor,
//                     ),
//                   ),
//                 )
//               : displayShipment.onDeliveryState == NetworkState.SUCCESS
//                   ? displayShipment.onDeliveryShipmentIsEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 'assets/images/shipment_details_icon.png',
//                                 width: 40.0,
//                                 height: 40.0,
//                               ),
//                               SizedBox(
//                                 height: 10.0.h,
//                               ),
//                               const Text(
//                                 'لا يوجد لديك طلبات قيد التوصيل',
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Stack(
//                           alignment: Alignment.bottomCenter,
//                           children: [
//                             ListView.builder(
//                               controller: _scrollController,
//                               padding: EdgeInsets.only(
//                                 top: size.height * 0.03,
//                               ),
//                               itemBuilder: (BuildContext ctx, int i) =>
//                                   BulkItem(
//                                 bulkShipment:
//                                     displayShipment.onDeliveryShipments[i],
//                                 onItemPressed: () => displayShipment
//                                         .onDeliveryShipments[i]
//                                         .children
//                                         .isNotEmpty
//                                     ? Navigator.pushNamed(
//                                         context,
//                                         ChildShipmentDetails.id,
//                                         arguments: displayShipment
//                                             .onDeliveryShipments[i].id,
//                                       )
//                                     : Navigator.pushNamed(
//                                         context,
//                                         ShipmentDetailsDisplay.id,
//                                         arguments: displayShipment
//                                             .onDeliveryShipments[i].id,
//                                       ),
//                               ),
//                               itemCount:
//                                   displayShipment.onDeliveryShipments.length,
//                             ),
//                             displayShipment.onDeliveryNextPageLoading
//                                 ? Container(
//                                     height: 50.0,
//                                     color: Colors.white.withOpacity(0.2),
//                                     child: Center(
//                                         child: SpinKitThreeBounce(
//                                       color: weevoPrimaryOrangeColor,
//                                       size: 30.0,
//                                     )),
//                                   )
//                                 : Container()
//                           ],
//                         )
//                   : NetworkErrorWidget(
//                       onRetryCallback: () async {
//                         await displayShipment.getOnDeliveryShipment(
//                             isPagination: false,
//                             isFirstTime: false,
//                             isRefreshing: false);
//                       },
//                     ),
//         ),
//       ),
//     );
//   }
// }
