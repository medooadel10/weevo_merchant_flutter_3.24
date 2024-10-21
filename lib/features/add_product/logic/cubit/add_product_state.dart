part of 'add_product_cubit.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState.initial() = _Initial;

  const factory AddProductState.pickImage(File? image) = PickImage;
}
