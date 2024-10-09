class WasullyDeliveryService {
  final List<int> validPlaces = [
    1,
    2,
    3,
  ];

  bool _isValidPlace(int placeId) => validPlaces.contains(placeId);

  bool isBothPlacesValid(int recieverPlaceId, int senderPlaceId) {
    return _isValidPlace(recieverPlaceId) && _isValidPlace(senderPlaceId);
  }

  bool isWithinAlexandriaOnly(int recieverPlaceId, int senderPlaceId) {
    return recieverPlaceId == 3 && senderPlaceId == 3;
  }

  bool isDeliveryToOrFromAlexandria(int recieverPlaceId, int senderPlaceId) =>
      recieverPlaceId == 3 || senderPlaceId == 3;
}
