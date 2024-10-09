import '../../../../core/Models/refresh_qr_code.dart';

abstract class WasullyHandleShipmentState {}

class WasullyHandleShipmentInitial extends WasullyHandleShipmentState {}

class WasullyHandleShipmentRefreshQrCodeStateLoading
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentRefreshQrCodeStateSuccess
    extends WasullyHandleShipmentState {
  final RefreshQrcode qrCode;

  WasullyHandleShipmentRefreshQrCodeStateSuccess({required this.qrCode});
}

class WasullyHandleShipmentRefreshQrCodeStateError
    extends WasullyHandleShipmentState {
  final String error;

  WasullyHandleShipmentRefreshQrCodeStateError({required this.error});
}

class WasullyHandleShipmentHandleReturnedShipmentStateLoading
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentHandleReturnedShipmentStateSuccess
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentHandleReturnedShipmentStateError
    extends WasullyHandleShipmentState {
  final String error;

  WasullyHandleShipmentHandleReturnedShipmentStateError({required this.error});
}

class WasullyHandleShipmentReviewCourierLoading
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentReviewCourierSuccess
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentReviewCourierError
    extends WasullyHandleShipmentState {
  final String error;

  WasullyHandleShipmentReviewCourierError({required this.error});
}
