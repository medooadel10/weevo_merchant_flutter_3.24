// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:weevo/core/Providers/add_shipment_provider.dart';
// import 'package:weevo/core/Providers/auth_provider.dart';
// import 'package:weevo/core/Providers/display_shipment_provider.dart';
// import 'package:weevo/core/Utilits/colors.dart';
// import 'package:weevo/core/Utilits/constants.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../Widgets/shipment_status_item.dart';

// class Shipment extends StatefulWidget {
//   static const String id = 'Shipment';

//   @override
//   _ShipmentState createState() => _ShipmentState();
// }

// class _ShipmentState extends State<Shipment> {
//   DisplayShipmentProvider _displayShipmentProvider;
//   AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();
//     _displayShipmentProvider =
//         Provider.of<DisplayShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _displayShipmentProvider.changePortion(0, true);
//     _displayShipmentProvider.getShipmentStatus();
//     check(
//         auth: _authProvider,
//         state: _displayShipmentProvider.shipmentStatusState,
//         ctx: context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     AddShipmentProvider addShipmentProvider =
//         Provider.of<AddShipmentProvider>(context);
//     return Consumer<DisplayShipmentProvider>(
//       builder: (context, data, child) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//             appBar: AppBar(
//               leading: IconButton(
//                 onPressed: () {
//   MagicRouter.pop();//                 },
//                 icon: Icon(
//                   Icons.arrow_back_ios_outlined,
//                 ),
//               ),
//               title: Text(
//                 'حالة الطلبات',
//               ),
//             ),
//             body: data.shipmentStatusState == NetworkState.WAITING ||
//                     addShipmentProvider.countriesState ==
//                         NetworkState.WAITING ||
//                     addShipmentProvider.states == null
//                 ? Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                           weevoPrimaryOrangeColor),
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Wrap(
//                         alignment: WrapAlignment.center,
//                         crossAxisAlignment: WrapCrossAlignment.center,
//                         spacing: 10.0,
//                         runSpacing: 10.0,
//                         children: List.generate(
//                           tabs.length,
//                           (i) => ShipmentStatusItem(
//                             data: tabs[i],
//                             index: i,
//                             selectedItem: data.currentSelectedShipmentIndex,
//                             onItemClick: (int i) {
//                               data.changePortion(i, false);
//                             },
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: data.currentShipmentWidget,
//                       ),
//                     ],
//                   )),
//       ),
//     );
//   }
// }
