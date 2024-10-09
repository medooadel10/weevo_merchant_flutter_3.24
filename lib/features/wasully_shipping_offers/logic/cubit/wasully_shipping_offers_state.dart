import '../../data/models/accept_offer_response_body.dart';
import '../../data/models/courier_response_body.dart';

abstract class WasullyShippingOffersState {}

class WasullyShippingOffersInitialState extends WasullyShippingOffersState {}

class WasullyShippingOffersLoadingState extends WasullyShippingOffersState {}

class WasullyShippingOffersSuccessState extends WasullyShippingOffersState {
  final List<ShippingOfferResponseBody> data;

  WasullyShippingOffersSuccessState(this.data);
}

class WasullyShippingOffersErrorState extends WasullyShippingOffersState {}

class WasullyShippingOfferAcceptSuccessState
    extends WasullyShippingOffersState {
  final AcceptOfferResponseBody data;

  WasullyShippingOfferAcceptSuccessState(this.data);
}

class WasullyShippingOfferAcceptErrorState extends WasullyShippingOffersState {
  final String message;

  WasullyShippingOfferAcceptErrorState(this.message);
}

class WasullyShippingOfferAcceptLoadingState
    extends WasullyShippingOffersState {}
