part of 'product_details_cubit.dart';

@freezed
class ProductDetailsState with _$ProductDetailsState {
  const factory ProductDetailsState.initial() = _Initial;

  const factory ProductDetailsState.loading() = Loading;

  const factory ProductDetailsState.success(ProductModel data) = Success;

  const factory ProductDetailsState.error(String error) = Error;

  const factory ProductDetailsState.cancelLoading() = CancelLoading;

  const factory ProductDetailsState.cancelSuccess() = CancelSuccess;

  const factory ProductDetailsState.cancelFailure(String error) = CancelFailure;
}
