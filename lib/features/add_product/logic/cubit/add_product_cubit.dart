import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weevo_merchant_upgrade/core/Models/category_data.dart';
import 'package:weevo_merchant_upgrade/core_new/networking/data_result.dart';

import '../../../../core/Utilits/constants.dart';
import '../../../products/data/models/products_response_body_model.dart';
import '../../data/models/add_product_request_model.dart';
import '../../data/models/add_product_response_model.dart';
import '../../data/repos/add_product_repo.dart';

part 'add_product_cubit.freezed.dart';
part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final AddProductRepo _addProductRepo;
  AddProductCubit(this._addProductRepo)
      : super(const AddProductState.initial());

  File? image;
  bool isDuplicate = false;
  void pickImage(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    XFile? imagePicked;
    if (isCamera) {
      imagePicked = await picker.pickImage(source: ImageSource.camera);
    } else {
      imagePicked = await picker.pickImage(source: ImageSource.gallery);
    }
    if (imagePicked == null) return;
    image = File(imagePicked.path);
    emit(AddProductState.pickImage(image));
  }

  final formKey = GlobalKey<FormState>();
  final productTitleController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productTypeController = TextEditingController();
  final productPriceController = TextEditingController();
  final productHeightController = TextEditingController();
  final productWeightController = TextEditingController();
  final productWidthController = TextEditingController();
  final productLengthController = TextEditingController();
  CategoryData? selectedCategory;

  void selectCategory(CategoryData category) {
    selectedCategory = category;
  }

  Future<String?> uploadAndGetImage() async {
    if (image == null) return null;
    File? compressedImage = await convertAndCompressImage(image!);
    if (compressedImage == null) return null;
    final result = await _addProductRepo.uploadImage(
      base64Encode(
        compressedImage.readAsBytesSync(),
      ),
      compressedImage.path.split('/').last,
    );
    if (result.success) return result.data!;
    emit(Error(result.error ?? ''));
    return null;
  }

  void addProduct() async {
    if (formKey.currentState!.validate()) {
      emit(const AddProductState.loading());
      final String? image = await uploadAndGetImage();
      final data = AddProductRequestModel(
        name: productTitleController.text,
        description: productDescriptionController.text,
        price: double.parse(productPriceController.text),
        height: productHeightController.text,
        weight: productWeightController.text,
        width: productWidthController.text,
        length: productLengthController.text,
        categoryId: selectedCategory!.id ?? 0,
        image: image ?? product?.image ?? '',
      );
      DataResult<AddProductResponseModel> result;
      if (isDuplicate || product == null) {
        result = await _addProductRepo.addProduct(data);
      } else {
        result = await _addProductRepo.updateProduct(
          data,
          product!.id,
        );
      }

      if (result.success) {
        emit(AddProductState.success(result.data!));
      } else {
        emit(AddProductState.error(result.error ?? ''));
      }
    }
  }

  ProductModel? product;
  void init(ProductModel? productModel, bool isDuplicate) {
    if (productModel != null) {
      productTitleController.text = productModel.name;
      productDescriptionController.text = productModel.description ?? '';
      productTypeController.text = productModel.category.name ?? '';
      productPriceController.text = productModel.price.toString();
      productHeightController.text = productModel.height;
      productWeightController.text = productModel.weight;
      productWidthController.text = productModel.width;
      productLengthController.text = productModel.length;
      selectedCategory = CategoryData(
        id: productModel.categoryId,
        name: productModel.category.name,
      );
      product = productModel;
      this.isDuplicate = isDuplicate;
    }
  }
}
