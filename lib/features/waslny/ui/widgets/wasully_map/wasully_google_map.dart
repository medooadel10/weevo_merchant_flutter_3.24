import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../logic/wasully_map_cubit/wasully_map_cubit.dart';
import '../../../logic/wasully_map_cubit/wasully_map_states.dart';

class WasullyGoogleMap extends StatelessWidget {
  final LatLng? location;
  const WasullyGoogleMap({super.key, this.location});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyMapCubit, WasullyMapStates>(
      builder: (context, state) {
        WasullyMapCubit cubit = context.read();
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: location ?? const LatLng(0, 0),
            zoom: 14.0,
          ),
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) async {
            cubit.mapController = controller;
            await cubit.mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: location ?? const LatLng(0, 0),
                  zoom: 14.0,
                ),
              ),
            );
            cubit.getFullAddress();
          },
          onCameraIdle: () async {
            cubit.getFullAddress();
          },
          onCameraMove: (newPosition) {
            cubit.updateLocation(
              controller: cubit.mapController!,
              lat: newPosition.target.latitude,
              long: newPosition.target.longitude,
              state: WaslyMapState.movingCamera,
            );
          },
          onTap: (value) {
            if (cubit.isSearchContainerVisible) {
              cubit.changeSearchContainerVisibility(false);
            }
          },
        );
      },
    );
  }
}
