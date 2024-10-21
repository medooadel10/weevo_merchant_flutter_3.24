import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'add_product_cubit.freezed.dart';
part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(const AddProductState.initial());

  File? image;
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
}
