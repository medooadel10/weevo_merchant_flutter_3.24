// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// class MerchantAcceptedShipmentHost extends StatefulWidget {
//   const MerchantAcceptedShipmentHost({
//     super.key,
//   });

//   @override
//   State<MerchantAcceptedShipmentHost> createState() =>
//       _MerchantAcceptedShipmentHostState();
// }

// class _MerchantAcceptedShipmentHostState
//     extends State<MerchantAcceptedShipmentHost> {
//   DisplayShipmentProvider _displayShipment;
//   ScrollController _scrollController;
//   AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _displayShipment =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _displayShipment.getMerchantAcceptedShipment(
//         isPagination: false, isFirstTime: true, isRefreshing: false);
//     check(
//         auth: _authProvider,
//         state: _displayShipment.merchantAcceptedShipmentState,
//         ctx: context);
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_displayShipment.merchantAcceptedNextPageLoading) {
//           _displayShipment.merchantAcceptedNextPage();
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
//           onRefresh: () => displayShipment.clearMerchantAcceptedShipmentList(),
//           child: displayShipment.merchantAcceptedShipmentState ==
//                   NetworkState.WAITING
//               ? Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       weevoPrimaryOrangeColor,
//                     ),
//                   ),
//                 )
//               : displayShipment.merchantAcceptedShipmentState ==
//                       NetworkState.SUCCESS
//                   ? displayShipment.merchantAcceptedShipmentIsEmpty
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
//                                 'لا يوجد لديك شحنات في انتظار التوصيل',
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
//                                 bulkShipment: displayShipment
//                                     .merchantAcceptedShipments[i],
//                                 onItemPressed: () => displayShipment
//                                         .merchantAcceptedShipments[i]
//                                         .children
//                                         .isNotEmpty
//                                     ? Navigator.pushNamed(
//                                         context,
//                                         ChildShipmentDetails.id,
//                                         arguments: displayShipment
//                                             .merchantAcceptedShipments[i].id,
//                                       )
//                                     : Navigator.pushNamed(
//                                         context,
//                                         ShipmentDetailsDisplay.id,
//                                         arguments: displayShipment
//                                             .merchantAcceptedShipments[i].id,
//                                       ),
//                               ),
//                               itemCount: displayShipment
//                                   .merchantAcceptedShipments.length,
//                             ),
//                             displayShipment.merchantAcceptedNextPageLoading
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
//                         await displayShipment.getMerchantAcceptedShipment(
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
