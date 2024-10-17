// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:weevo/core/Providers/auth_provider.dart';
// import 'package:weevo/core/Providers/display_shipment_provider.dart';
// import 'package:weevo/core/Utilits/colors.dart';
// import 'package:weevo/features/Screens/child_shipment_details.dart';
// import 'package:weevo/features/Screens/shipment.dart';
// import 'package:weevo/core/Utilits/constants.dart';
// import 'package:weevo/features/Screens/shipment_details_display.dart';
// import 'package:weevo/features/Widgets/bulk_item.dart';
// import 'package:weevo/features/Widgets/network_error_widget.dart';

// class DeliveredShipmentHost extends StatefulWidget {
//   DeliveredShipmentHost({
//     Key key,
//   }) : super(key: key);

//   @override
//   _DeliveredShipmentHostState createState() => _DeliveredShipmentHostState();
// }

// class _DeliveredShipmentHostState extends State<DeliveredShipmentHost> {
//   DisplayShipmentProvider _displayShipment;
//   ScrollController _scrollController;
//   AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _displayShipment =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _displayShipment.getDeliveryShipment(
//         isPagination: false, isFirstTime: true, isRefreshing: false);
//     check(
//         auth: _authProvider,
//         state: _displayShipment.deliveredState,
//         ctx: context);
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_displayShipment.deliveredNextPageLoading) {
//           _displayShipment.deliveredNextPage();
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
//           onRefresh: () => displayShipment.clearDeliveredShipmentList(),
//           child: displayShipment.deliveredState == NetworkState.WAITING
//               ? Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       weevoPrimaryOrangeColor,
//                     ),
//                   ),
//                 )
//               : displayShipment.deliveredState == NetworkState.SUCCESS
//                   ? displayShipment.deliveredShipmentIsEmpty
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
//                               Text(
//                                 'لا يوجد لديك طلبات تم توصيلها',
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
//                                   displayShipment.deliveredShipments[i].children
//                                           .isNotEmpty
//                                       ? displayShipment
//                                               .deliveredShipments[i].children
//                                               .any((e) =>
//                                                   e.status == 'delivered')
//                                           ? BulkItem(
//                                               bulkShipment: displayShipment
//                                                   .deliveredShipments[i],
//                                               onItemPressed: () =>
//                                                   displayShipment
//                                                           .deliveredShipments[i]
//                                                           .children
//                                                           .isNotEmpty
//                                                       ? Navigator.pushNamed(
//                                                           context,
//                                                           ChildShipmentDetails
//                                                               .id,
//                                                           arguments: displayShipment
//                                                               .deliveredShipments[
//                                                                   i]
//                                                               .id,
//                                                         )
//                                                       : Navigator.pushNamed(
//                                                           context,
//                                                           ShipmentDetailsDisplay
//                                                               .id,
//                                                           arguments: displayShipment
//                                                               .deliveredShipments[
//                                                                   i]
//                                                               .id,
//                                                         ),
//                                             )
//                                           : Container()
//                                       : BulkItem(
//                                           bulkShipment: displayShipment
//                                               .deliveredShipments[i],
//                                           onItemPressed: () => displayShipment
//                                                   .deliveredShipments[i]
//                                                   .children
//                                                   .isNotEmpty
//                                               ? Navigator.pushNamed(
//                                                   context,
//                                                   ChildShipmentDetails.id,
//                                                   arguments: displayShipment
//                                                       .deliveredShipments[i].id,
//                                                 )
//                                               : Navigator.pushNamed(
//                                                   context,
//                                                   ShipmentDetailsDisplay.id,
//                                                   arguments: displayShipment
//                                                       .deliveredShipments[i].id,
//                                                 ),
//                                         ),
//                               itemCount:
//                                   displayShipment.deliveredShipments.length,
//                             ),
//                             displayShipment.deliveredNextPageLoading
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
//                         await displayShipment.getDeliveryShipment(
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
