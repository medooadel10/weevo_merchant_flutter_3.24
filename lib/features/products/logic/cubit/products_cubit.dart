import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/toasts.dart';
import 'package:weevo_merchant_upgrade/features/products/data/models/products_response_body_model.dart';
import 'package:weevo_merchant_upgrade/features/products/data/repos/products_repo.dart';

part 'products_cubit.freezed.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo _productsRepo;
  ProductsCubit(this._productsRepo) : super(const ProductsState.initial());
  int currentPage = 1;
  bool hasMoreData = true;
  List<ProductModel>? products;
  ProductsResponseBodyModel? data;

  Future<void> getProducts({bool isPaging = false}) async {
    if (state is Loading || state is PagingLoading) {
      return;
    }
    if (isPaging) {
      if (!hasMoreData) return;
      emit(PagingLoading(products ?? []));
    } else {
      currentPage = 1;
      products = [];
      hasMoreData = true;
      emit(const Loading());
    }
    final result = await _productsRepo.getProducts(currentPage);
    if (result.success) {
      hasMoreData = result.data?.data.length == result.data?.perPage;
      data = result.data;
      products?.addAll(result.data!.data);
      if ((isPaging && hasMoreData) || currentPage == 1) currentPage++;
      emit(Success(products ?? []));
    } else {
      hasMoreData = false;
      emit(Failure(result.error ?? ''));
    }
  }

  void searchProductByTitle(String title) {
    if (title.isEmpty) {
      emit(Success(products ?? []));
      return;
    }
    showToast('asd');
    List<ProductModel>? finalProducts = products
        ?.where(
          (element) =>
              element.name.toLowerCase().contains(title.toLowerCase()) ||
              (element.description
                      ?.toLowerCase()
                      .contains(title.toLowerCase()) ??
                  false),
        )
        .toList();
    emit(Success(finalProducts ?? []));
  }

  void deleteProduct(int id) async {
    emit(const DeleteProductLoading());
    final result = await _productsRepo.deleteProduct(id);
    if (result.success) {
      products?.removeWhere((element) => element.id == id);
      emit(Success(products ?? []));
      emit(const DeleteProductSuccess());
    } else {
      emit(DeleteProductFailure(result.error ?? ''));
    }
  }
}
