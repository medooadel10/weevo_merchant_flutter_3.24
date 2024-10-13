import 'dart:io';

import '../../../../core/Models/address_fill.dart';
import '../../data/models/delivery_price_response_body.dart';

abstract class WasullyStates {}

class WasullyInitialState extends WasullyStates {}

class WasullyChangeWhoPaidState extends WasullyStates {
  final int whichUserPay;
  WasullyChangeWhoPaidState({this.whichUserPay = 0});
}

class WasullyChangeImageState extends WasullyStates {
  final File? image;
  WasullyChangeImageState(this.image);
}

class WasullyChangeRecieverAddressState extends WasullyStates {
  final AddressFill address;
  WasullyChangeRecieverAddressState(this.address);
}

class WasullyChangeSenderAddressState extends WasullyStates {
  final AddressFill address;
  WasullyChangeSenderAddressState(this.address);
}

class WasullyCalculateDeliveryPriceLoadingState extends WasullyStates {}

class WasullyCalculateDeliveryPriceSuccessState extends WasullyStates {
  final DeliveryPriceResponseBody deliveryPriceModel;
  WasullyCalculateDeliveryPriceSuccessState(this.deliveryPriceModel);
}

class WasullyCalculateDeliveryPriceErrorState extends WasullyStates {
  final String error;
  WasullyCalculateDeliveryPriceErrorState(this.error);
}

class WasullyCreateWasullyLoadingState extends WasullyStates {}

class WasullyCreateWasullySuccessState extends WasullyStates {
  final String message;
  WasullyCreateWasullySuccessState(this.message);
}

class WasullyCreateWasullyErrorState extends WasullyStates {
  final String error;
  WasullyCreateWasullyErrorState(this.error);
}

class WasullyGetInitDataSuccessState extends WasullyStates {}

class WasullyChangeTipPriceState extends WasullyStates {
  final String tipPrice;
  WasullyChangeTipPriceState(this.tipPrice);
}
