part of 'add_product_cubit.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState.initial() = _Initial;

  const factory AddProductState.pickImage(File? image) = PickImage;

  const factory AddProductState.loading() = Loading;

  const factory AddProductState.success(AddProductResponseModel product) =
      Success;

  const factory AddProductState.error(String error) = Error;
}
