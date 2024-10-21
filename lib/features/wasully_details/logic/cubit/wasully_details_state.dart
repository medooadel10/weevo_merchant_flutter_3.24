import '../../data/models/wasully_model.dart';

abstract class WasullyDetailsState {}

class WasullyDetailsInitialState extends WasullyDetailsState {}

class WasullyDetailsLoadingState extends WasullyDetailsState {}

class WasullyDetailsSuccessState extends WasullyDetailsState {
  final WasullyModel wasullyModel;

  WasullyDetailsSuccessState(this.wasullyModel);
}

class WasullyDetailsErrorState extends WasullyDetailsState {
  final String error;
  WasullyDetailsErrorState(this.error);
}

class CreateDynamicLinkSuccessState extends WasullyDetailsState {
  final String link;
  CreateDynamicLinkSuccessState(this.link);
}

class WasullyUpdatePriceLoadingState extends WasullyDetailsState {}

class WasullyUpdatePriceSuccessState extends WasullyDetailsState {
  final WasullyModel wasullyModel;

  WasullyUpdatePriceSuccessState(this.wasullyModel);
}

class WasullyUpdatePriceErrorState extends WasullyDetailsState {
  final String error;
  WasullyUpdatePriceErrorState(this.error);
}

class WasullyCancelLoadingState extends WasullyDetailsState {}

class WasullyCancelSuccessState extends WasullyDetailsState {}

class WasullyCancelErrorState extends WasullyDetailsState {
  final String error;
  WasullyCancelErrorState(this.error);
}

class WasullyRestoreLoadingState extends WasullyDetailsState {}

class WasullyRestoreSuccessState extends WasullyDetailsState {}

class WasullyRestoreErrorState extends WasullyDetailsState {
  final String error;
  WasullyRestoreErrorState(this.error);
}

class WasullyUpdateAcceptNewShipmentState extends WasullyDetailsState {
  final bool value;

  WasullyUpdateAcceptNewShipmentState(this.value);
}

class WasullyDetailsListenToShipmentStatusState extends WasullyDetailsState {
  final String locationId;

  WasullyDetailsListenToShipmentStatusState(this.locationId);
}

class WasullyDetailsChangeCancellationReasonState extends WasullyDetailsState {
  final int? value;

  WasullyDetailsChangeCancellationReasonState(this.value);
}
