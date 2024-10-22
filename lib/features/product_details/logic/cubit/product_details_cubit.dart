import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';

import '../../data/repos/product_details_repo.dart';

part 'product_details_cubit.freezed.dart';
part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsRepo _productDetailsRepo;
  ProductDetailsCubit(this._productDetailsRepo)
      : super(const ProductDetailsState.initial());

  ProductModel? product;
  Future<void> getProductDetails(int id) async {
    product = null;
    emit(const ProductDetailsState.loading());
    final result = await _productDetailsRepo.getProductDetails(id);
    if (result.success) {
      product = result.data;
      emit(ProductDetailsState.success(result.data!));
    } else {
      emit(ProductDetailsState.error(result.error ?? ''));
    }
  }

  Future<void> deleteProduct(int id) async {
    emit(const ProductDetailsState.cancelLoading());
    final result = await _productDetailsRepo.deleteProduct(id);
    if (result.success) {
      emit(const ProductDetailsState.cancelSuccess());
    } else {
      emit(ProductDetailsState.cancelFailure(result.error ?? ''));
    }
  }
}
