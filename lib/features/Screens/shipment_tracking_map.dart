import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/tracking_dialog.dart';
import '../../core/Models/shipment_tracking_model.dart';
import '../../core/Providers/shipment_tracking_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';

class ShipmentTrackingMap extends StatefulWidget {
  static const String id = 'Shipment_Tracking';
  final ShipmentTrackingModel model;

  const ShipmentTrackingMap({
    super.key,
    required this.model,
  });

  @override
  State<ShipmentTrackingMap> createState() => _ShipmentTrackingMapState();
}

class _ShipmentTrackingMapState extends State<ShipmentTrackingMap> {
  GoogleMapController? _googleMapController;
  String? _mapStyle;
  String? _locationId;

  @override
  void initState() {
    super.initState();
    if (widget.model.merchantId.hashCode >= widget.model.courierId.hashCode) {
      _locationId = '${widget.model.merchantId}-${widget.model.courierId}';
    } else {
      _locationId = '${widget.model.courierId}-${widget.model.merchantId}';
    }
    rootBundle.loadString('assets/images/map_style.txt').then((string) {
      _mapStyle = string;
    });
    FirebaseFirestore.instance
        .collection('locations')
        .doc(_locationId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShipmentTrackingProvider>(
      builder: (ctx, data, ch) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: navigator.currentContext!,
                enableDrag: true,
                builder: (ctx) => TrackingDialog(
                      model: widget.model,
                    ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )));
          },
          backgroundColor: weevoPrimaryBlueColor,
          child: const Icon(
            Icons.arrow_upward_outlined,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              mapToolbarEnabled: false,
              markers: data.markers,
              compassEnabled: false,
              buildingsEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(widget.model.deliveringLat!),
                      double.parse(widget.model.deliveringLng!)),
                  zoom: 15.0),
              onMapCreated: (GoogleMapController controller) async {
                _googleMapController = controller;
                // ignore: deprecated_member_use
                await _googleMapController?.setMapStyle(_mapStyle);
                // await data.getDirections(
                //   navigator.currentContext!,
                //   controller: controller,
                //   directionFrom: LatLng(widget.model.fromLat, widget.model.fromLng),
                //   directionTo: LatLng(double.parse(widget.model.deliveringLat),
                //       double.parse(widget.model.deliveringLng)),
                // );
                // FirebaseFirestore.instance.collection('locations').doc(_locationId)
                // log('${snapshot.data['current_lat']}');
                // log('${snapshot.data['status']}');
                // log('${snapshot.data['current_lng']}');
                // if (snapshot.data['status'] == 'none') {
                //   data.getDirections(
                //     context: ctx,
                //     controller: _googleMapController,
                //     directionFrom: LatLng(snapshot.data['current_lat'],
                //         snapshot.data['current_lng']),
                //     directionTo: LatLng(30.5, 31.5),
                //   );
                // } else if (snapshot.data['status'] == 'ready_to_track') {
                // } else if (snapshot.data['status'] == 'tracking') {
                //   data.trackUser(
                //     navigator.currentContext!,
                //     controller: _googleMapController,
                //     newLocation:
                //         LatLng(snapshot.data['lat'], snapshot.data['lng']),
                //   );
                // } else if (snapshot.data['status'] == 'arrived') {
                //   data.markers.clear();
                //   data.polyLines.clear();
                // }
              },
              polylines: data.polyLines,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
            ),
            data.directions?.totalDistance != null ||
                    data.directions?.totalDuration != null
                ? SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: weevoPrimaryBlueColor,
                      ),
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        '${data.directions?.totalDistance}  ${data.directions?.totalDuration}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  )
                : Container(),
          ],
        )
        //       : Center(
        //   child: Text(
        //   'لم يبدأ الكابتن التوصيل بعد',
        //   style: TextStyle(
        //     fontSize: 16.0,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),)
        ,
      ),
    );
  }
}
// ** user information dialog in tracking **
