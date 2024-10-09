// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// import '../Widgets/network_error_widget.dart';
// import 'child_shipment_details.dart';

// class CourierOnHisWayToGetShipmentHost extends StatefulWidget {
//   const CourierOnHisWayToGetShipmentHost({
//     super.key,
//   });

//   @override
//   State<CourierOnHisWayToGetShipmentHost> createState() =>
//       _CourierOnHisWayToGetShipmentHostState();
// }

// class _CourierOnHisWayToGetShipmentHostState
//     extends State<CourierOnHisWayToGetShipmentHost> {
//   TextEditingController _editTextController;
//   DisplayShipmentProvider _shipmentProvider;
//   ScrollController _scrollController;
//   AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _editTextController = TextEditingController();
//     _shipmentProvider =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _shipmentProvider.getCourierOnHisWayToGetShipment(
//         isPagination: false, isFirstTime: true, isRefreshing: false);
//     check(
//         auth: _authProvider,
//         state: _shipmentProvider.courierOnHisWayToGetShipmentState,
//         ctx: context);
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_shipmentProvider.courierOnHisWayToGetShipmentNextPageLoading) {
//           _shipmentProvider.courierOnHisWayToGetShipmentNextPage();
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _editTextController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         body: Consumer<DisplayShipmentProvider>(
//           builder: (context, data, child) => RefreshIndicator(
//             onRefresh: () =>
//                 data.clearCourierOnHisWayToGetShipmentShipmentList(),
//             child: data.courierOnHisWayToGetShipmentState ==
//                     NetworkState.WAITING
//                 ? Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         weevoPrimaryOrangeColor,
//                       ),
//                     ),
//                   )
//                 : data.courierOnHisWayToGetShipmentState == NetworkState.SUCCESS
//                     ? data.courierOnHisWayToGetShipmentShipmentIsEmpty
//                         ? Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   'لا يوجد لديك شحنات في الطريق',
//                                   strutStyle: StrutStyle(
//                                     forceStrutHeight: true,
//                                   ),
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16.0,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 6.w,
//                                 ),
//                                 Image.asset(
//                                   'assets/images/shipment_details_icon.png',
//                                   width: 30.0,
//                                   height: 30.0,
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Stack(
//                             alignment: Alignment.bottomCenter,
//                             children: [
//                               ListView.builder(
//                                 controller: _scrollController,
//                                 padding:
//                                     EdgeInsets.only(top: size.height * 0.03),
//                                 itemBuilder: (BuildContext ctx, int i) =>
//                                     BulkItem(
//                                   onItemPressed: () => data
//                                           .courierOnHisWayToGetShipmentShipments[
//                                               i]
//                                           .children
//                                           .isNotEmpty
//                                       ? Navigator.pushNamed(
//                                           context,
//                                           ChildShipmentDetails.id,
//                                           arguments: data
//                                               .courierOnHisWayToGetShipmentShipments[
//                                                   i]
//                                               .id,
//                                         )
//                                       : Navigator.pushNamed(
//                                           context, ShipmentDetailsDisplay.id,
//                                           arguments: data
//                                               .courierOnHisWayToGetShipmentShipments[
//                                                   i]
//                                               .id),
//                                   bulkShipment: data
//                                       .courierOnHisWayToGetShipmentShipments[i],
//                                 ),
//                                 itemCount: data
//                                     .courierOnHisWayToGetShipmentShipments
//                                     .length,
//                               ),
//                               data.courierOnHisWayToGetShipmentNextPageLoading
//                                   ? Container(
//                                       height: 50.0,
//                                       color: Colors.white.withOpacity(0.2),
//                                       child: Center(
//                                         child: SpinKitThreeBounce(
//                                           color: weevoPrimaryOrangeColor,
//                                           size: 30.0,
//                                         ),
//                                       ),
//                                     )
//                                   : Container()
//                             ],
//                           )
//                     : NetworkErrorWidget(
//                         onRetryCallback: () async {
//                           await data.getCourierOnHisWayToGetShipment(
//                               isPagination: false,
//                               isFirstTime: false,
//                               isRefreshing: false);
//                         },
//                       ),
//           ),
//         ),
//       ),
//     );
//   }
// }
