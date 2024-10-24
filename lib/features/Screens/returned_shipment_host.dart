// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:weevo/core/Providers/auth_provider.dart';
// import 'package:weevo/core/Providers/display_shipment_provider.dart';
// import 'package:weevo/core/Utilits/colors.dart';
// import 'package:weevo/core/Utilits/constants.dart';
// import 'package:weevo/features/Screens/child_shipment_details.dart';
// import 'package:weevo/features/Screens/shipment_details_display.dart';
// import 'package:weevo/features/Widgets/bulk_item.dart';
// import 'package:weevo/features/Widgets/network_error_widget.dart';

// class ReturnedShipmentHost extends StatefulWidget {


//   ReturnedShipmentHost({
//     Key key,
//   }) : super(key: key);

//   @override
//   _ReturnedShipmentHostState createState() => _ReturnedShipmentHostState();
// }

// class _ReturnedShipmentHostState extends State<ReturnedShipmentHost> {
//   DisplayShipmentProvider _displayShipment;
//   ScrollController _scrollController;
//   AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _displayShipment =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _displayShipment.getReturnedShipment(
//         isPagination: false, isFirstTime: true, isRefreshing: false);
//     check(
//         auth: _authProvider,
//         state: _displayShipment.returnedState,
//         ctx: context);
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_displayShipment.returnedNextPageLoading) {
//           _displayShipment.returnedNextPage();
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
//           onRefresh: () => displayShipment.clearReturnedShipmentList(),
//           child: displayShipment.returnedState == NetworkState.WAITING
//               ? Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       weevoPrimaryOrangeColor,
//                     ),
//                   ),
//                 )
//               : displayShipment.returnedState == NetworkState.SUCCESS ? displayShipment.returnedShipmentIsEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/images/shipment_details_icon.png',
//                             width: 40.0,
//                             height: 40.0,
//                           ),
//                           SizedBox(
//                             height: 10.0.h,
//                           ),
//                           Text(
//                             'لا يوجد لديك طلبات مرتجعة',
//                             style: TextStyle(
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         ListView.builder(
//                           controller: _scrollController,
//                           padding: EdgeInsets.only(
//                             top: size.height * 0.03,
//                           ),
//                           itemBuilder: (BuildContext ctx, int i) =>
//                               displayShipment.returnedShipments[i].children
//                                       .isNotEmpty
//                                   ? displayShipment
//                                           .returnedShipments[i].children
//                                           .any((e) => e.status == 'returned')
//                                       ? BulkItem(
//                                           bulkShipment: displayShipment
//                                               .returnedShipments[i],
//                                           onItemPressed: () => displayShipment
//                                                   .returnedShipments[i]
//                                                   .children
//                                                   .isNotEmpty
//                                               ? Navigator.pushNamed(
//                                                   context,
//                                                   ChildShipmentDetails.id,
//                                                   arguments: displayShipment
//                                                       .returnedShipments[i]
//                                                       .id,
//                                                 )
//                                               : Navigator.pushNamed(
//                                                   context,
//                                                   ShipmentDetailsDisplay.id,
//                                                   arguments: displayShipment
//                                                       .returnedShipments[i]
//                                                       .id,
//                                                 ),
//                                         )
//                                       : Container()
//                                   : BulkItem(
//                                       bulkShipment: displayShipment
//                                           .returnedShipments[i],
//                                       onItemPressed: () => displayShipment
//                                               .returnedShipments[i]
//                                               .children
//                                               .isNotEmpty
//                                           ? Navigator.pushNamed(
//                                               context,
//                                               ChildShipmentDetails.id,
//                                               arguments: displayShipment
//                                                   .returnedShipments[i].id,
//                                             )
//                                           : Navigator.pushNamed(
//                                               context,
//                                               ShipmentDetailsDisplay.id,
//                                               arguments: displayShipment
//                                                   .returnedShipments[i].id,
//                                             ),
//                                     ),
//                           itemCount: displayShipment.returnedShipments.length,
//                         ),
//                         displayShipment.returnedNextPageLoading
//                             ? Container(
//                                 height: 50.0,
//                                 color: Colors.white.withOpacity(0.2),
//                                 child: Center(
//                                     child: SpinKitThreeBounce(
//                                   color: weevoPrimaryOrangeColor,
//                                   size: 30.0,
//                                 )),
//                               )
//                             : Container()
//                       ],
//                     ): NetworkErrorWidget(
//             onRetryCallback: () async {
//               await displayShipment.getReturnedShipment(
//                   isPagination: false,
//                   isFirstTime: false,
//                   isRefreshing: false);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
