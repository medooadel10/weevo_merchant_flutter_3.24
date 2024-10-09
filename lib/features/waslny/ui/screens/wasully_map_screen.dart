import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core_new/di/dependency_injection.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../logic/wasully_map_cubit/wasully_map_cubit.dart';
import '../widgets/wasully_map/wasully_google_map.dart';
import '../widgets/wasully_map/wasully_map_confirm_button.dart';
import '../widgets/wasully_map/wasully_map_search_bar.dart';
import 'wasully_map_mark.dart';

class WasullyMapScreen extends StatelessWidget {
  final LatLng? location;
  const WasullyMapScreen({super.key, this.location});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WasullyMapCubit(getIt())..addSearchControllerListener(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              WasullyGoogleMap(
                location: location ?? const LatLng(0, 0),
              ),
              const Positioned(
                child: WasullyMapSearchBar(),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      verticalSpace(10),
                      const WasullyMapConfirmButton(),
                    ],
                  )),
              const Align(
                alignment: Alignment.center,
                child: WasullyMapMark(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
