part of 'products_cubit.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState.initial() = _Initial;

  const factory ProductsState.loading() = Loading;

  const factory ProductsState.pagingLoading(List<ProductModel> products) =
      PagingLoading;

  const factory ProductsState.success(List<ProductModel> products) = Success;

  const factory ProductsState.failure(String message) = Failure;

  const factory ProductsState.deleteProductLoading() = DeleteProductLoading;

  const factory ProductsState.deleteProductSuccess() = DeleteProductSuccess;

  const factory ProductsState.deleteProductFailure(String message) =
      DeleteProductFailure;
}
