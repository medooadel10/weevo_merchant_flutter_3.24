import '../../../../core/Models/placed_class.dart';

abstract class WasullyMapStates {}

class WasullyMapInitialState extends WasullyMapStates {}

class WasullyMapSearchLoadingState extends WasullyMapStates {}

class WasullyMapSearchSuccessState extends WasullyMapStates {
  final List<GetPlaceId> places;
  WasullyMapSearchSuccessState(this.places);
}

class WasullyMapSearchErrorState extends WasullyMapStates {
  final String error;
  WasullyMapSearchErrorState(this.error);
}

class WasullyMapChangeSearchContainerVisibilityState extends WasullyMapStates {
  final bool visibility;
  WasullyMapChangeSearchContainerVisibilityState(this.visibility);
}

class WasullyMapGetAddressLoadingState extends WasullyMapStates {}

class WasullyMapGetAddressSuccessState extends WasullyMapStates {
  final String address;
  WasullyMapGetAddressSuccessState(this.address);
}

class WasullyMapGetAddressErrorState extends WasullyMapStates {
  final String error;
  WasullyMapGetAddressErrorState(this.error);
}
