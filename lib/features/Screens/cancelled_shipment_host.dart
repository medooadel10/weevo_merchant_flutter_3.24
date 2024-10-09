// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// import '../../core/Providers/auth_provider.dart';
// import '../../core/Providers/display_shipment_provider.dart';
// import '../../core/Utilits/constants.dart';

// class CancelledShipmentHost extends StatefulWidget {
//   static const String id = 'Cancelled_Shipment_Host';

//   const CancelledShipmentHost({
//     super.key,
//   });

//   @override
//   State<CancelledShipmentHost> createState() => _CancelledShipmentHostState();
// }

// class _CancelledShipmentHostState extends State<CancelledShipmentHost> {
//   late DisplayShipmentProvider _displayShipment;
//   late ScrollController _scrollController;
//   late AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _displayShipment =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);

//     check(
//         auth: _authProvider,
//         state: _displayShipment.cancelledState!,
//         ctx: context);
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_displayShipment.cancelledNextPageLoading) {}
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
//           onRefresh: () => displayShipment.clearCancelledShipmentList(),
//           child: displayShipment.cancelledState == NetworkState.WAITING
//               ? Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       weevoPrimaryOrangeColor,
//                     ),
//                   ),
//                 )
//               : displayShipment.cancelledState == NetworkState.SUCCESS
//                   ? displayShipment.cancelledShipmentIsEmpty
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
//                                 'لا يوجد لديك شحنات ملغية',
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
//                                     displayShipment.cancelledShipments[i],
//                                 onItemPressed: () => displayShipment
//                                         .cancelledShipments[i]
//                                         .children
//                                         .isNotEmpty
//                                     ? Navigator.pushNamed(
//                                         context,
//                                         ChildShipmentDetails.id,
//                                         arguments: displayShipment
//                                             .cancelledShipments[i].id,
//                                       )
//                                     : Navigator.pushNamed(
//                                         context,
//                                         ShipmentDetailsDisplay.id,
//                                         arguments: displayShipment
//                                             .cancelledShipments[i].id,
//                                       ),
//                               ),
//                               itemCount:
//                                   displayShipment.cancelledShipments.length,
//                             ),
//                             _displayShipment.cancelledNextPageLoading
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
//                         await _displayShipment.getCancelledShipment(
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
