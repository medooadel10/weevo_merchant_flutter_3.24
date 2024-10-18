class ApiConstants {
  static const String baseUrl = 'https://eg.api.weevoapp.com'; // Production
  //static const String baseUrl = 'https://api-dev-mobile.weevoapp.com'; // Debug
  static const String addressUrl = '$baseUrl/api/v1/merchant/address-book';
  static const String registerUrl = '$baseUrl/api/v1/merchant/register';
  static const String deliveryPriceUrl =
      '$baseUrl/api/v1/merchant/shipments/calculate-distance-price';
  static const String createWasully =
      '$baseUrl/api/v1/merchant/wasuliy/create-wasuliy';

  static const String uploadImage =
      '$baseUrl/api/v1/merchant/products/upload-image';

  static const String shipmentsUrl = '$baseUrl/api/v1/merchant/shipments';

  static const String wasullyDetailsUrl =
      '$baseUrl/api/v1/merchant/wasuliy/show-wasuliy';

  static const String updateWasullyUrl =
      '$baseUrl/api/v1/merchant/wasuliy/update-wasuliy';

  static const String deleteImageUrl =
      "$baseUrl/api/v1/merchant/products/delete-image";

  static const String cancelWasullyUrl = '$baseUrl/api/v1/merchant/wasuliy';

  static const String restoreWasullyUrl = '$baseUrl/api/v1/merchant/wasuliy';

  static const String shippingOffers =
      '$baseUrl/api/v1/merchant/wasuliy/shipping-offers';

  static const String acceptShippingOffers =
      '$baseUrl/api/v1/merchant/wasuliy/shipping-offers/accept';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
