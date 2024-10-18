import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../core/Models/address.dart';
import '../../../../core/Models/address_fill.dart';
import '../../../../core/Providers/add_shipment_provider.dart';
import '../../../../core/Providers/map_provider.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/constants.dart';
import '../../../../core_new/helpers/wasully_delivery_service.dart';
import '../../../wasully_details/data/models/wasully_model.dart';
import '../../data/models/create_wasully_request_body.dart';
import '../../data/models/delivery_price_request_body.dart';
import '../../data/models/delivery_price_response_body.dart';
import '../../data/repos/waslny_repo.dart';
import 'wasully_states.dart';

class WasullyCubit extends Cubit<WasullyStates> {
  final WaslnyRepo _waslnyRepo;
  final WasullyDeliveryService _wasullyDeliveryService;
  WasullyCubit(this._waslnyRepo, this._wasullyDeliveryService)
      : super(WasullyInitialState());

  final formKey = GlobalKey<FormState>();
  final orderDetailsController = TextEditingController();
  final senderPhoneController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final insuranceAmountController = TextEditingController();
  final deliveryPriceContoller = TextEditingController();
  final tipController = TextEditingController();

  int whoPayDeliveryPrice = 0;
  void changeWhoPayDeliveryPrice(int value) {
    whoPayDeliveryPrice = value;
    emit(WasullyChangeWhoPaidState(whichUserPay: value));
  }

  List<String> tipPrices = ['0', '5', '10', '20', 'مبلغ أخر'];
  List<String> states = ['القاهرة', 'الجيزة', 'الأسكندرية'];

  int tipPriceSelected = 0;
  void selectTipPrice(int index) {
    tipPriceSelected = index;
    emit(WasullyChangeTipPriceState(tipPrices[index]));
  }

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
    emit(WasullyChangeImageState(image!));
  }

  void removeImage() {
    image = null;
    emit(WasullyChangeImageState(image));
  }

  WasullyModel? wasullyModel;
  void getInitData(WasullyModel? wasully, BuildContext context) async {
    senderPhoneController.text = Preferences.instance.getPhoneNumber;
    if (wasully == null) {
      getAddress(context);
      return;
    }
    wasullyModel = wasully;
    recieverAddressFill = AddressFill(
      street: wasullyModel?.receivingStreet ?? '',
      lat: double.parse(wasullyModel?.receivingLat ?? '0.0'),
      long: double.parse(wasullyModel?.receivingLng ?? '0.0'),
      administrativeArea: wasullyModel?.receivingStateModel?.name ?? '',
      subAdministrativeArea: wasullyModel?.receivingCityModel?.name ?? '',
    );
    senderAddressFill = AddressFill(
      street: wasullyModel?.deliveringStreet ?? '',
      lat: double.parse(wasullyModel?.deliveringLat ?? '0.0'),
      long: double.parse(wasullyModel?.deliveringLng ?? '0.0'),
      administrativeArea: wasullyModel?.deliveringStateModel?.name ?? '',
      subAdministrativeArea: wasullyModel?.deliveringCityModel?.name ?? '',
    );
    orderDetailsController.text = wasullyModel?.title ?? '';
    receiverPhoneController.text = wasullyModel?.clientPhone ?? '';
    deliveryPriceContoller.text = wasullyModel?.price ?? '0.0';
    insuranceAmountController.text = wasullyModel?.amount ?? '0.0';
    whoPayDeliveryPrice = wasullyModel?.whoPay == 'me' ? 0 : 1;
    if (wasullyModel?.tip != null) {
      int index = tipPrices.indexOf(wasullyModel?.tip.toString() ?? '0');
      if (index == -1) {
        selectTipPrice(tipPrices.length - 1);
        tipController.text = wasullyModel?.tip.toString() ?? '0';
      } else {
        selectTipPrice(index);
      }
    }
    await getDeliveryPrice(context);
    emit(WasullyGetInitDataSuccessState());
  }

  Address? _address;
  AddressFill? recieverAddressFill;
  AddressFill? senderAddressFill;

  void getAddress(context) async {
    _address = Provider.of<MapProvider>(context, listen: false).fullAddress;
    recieverAddressFill = AddressFill(
      street: _address?.name ?? '',
      lat: double.parse(_address?.lat ?? '0.0'),
      long: double.parse(_address?.lng ?? '0.0'),
      administrativeArea: _address?.state ?? '',
      subAdministrativeArea: _address?.city ?? '',
    );
  }

  void changeRecieverAddress(AddressFill address) {
    address.administrativeArea = states.firstWhere(
      (element) {
        if (element.split(' ').length > 1) {
          return address.administrativeArea
              .split(' ')
              .last
              .noramlizeText()
              .contains(element.noramlizeText());
        }
        return address.administrativeArea
            .noramlizeText()
            .contains(element.noramlizeText());
      },
      orElse: () => 'إختار محافظة أخرى',
    );
    recieverAddressFill = address;
    emit(WasullyChangeRecieverAddressState(recieverAddressFill!));
  }

  void changeSenderAddress(AddressFill address) {
    address.administrativeArea = states.firstWhere(
      (element) {
        if (element.split(' ').length > 1) {
          return address.administrativeArea
              .split(' ')
              .last
              .noramlizeText()
              .contains(element.noramlizeText());
        }
        return address.administrativeArea
            .noramlizeText()
            .contains(element.noramlizeText());
      },
      orElse: () => 'إختار محافظة أخرى',
    );
    senderAddressFill = address;
    emit(WasullyChangeSenderAddressState(senderAddressFill!));
  }

  DeliveryPriceResponseBody? deliveryPriceModel;
  String addressError = '';
  Future<void> getDeliveryPrice(BuildContext context) async {
    deliveryPriceModel = null;
    emit(WasullyCalculateDeliveryPriceLoadingState());
    AddShipmentProvider addShipmentProvider =
        Provider.of(context, listen: false);
    int? receiverPlaceId = addShipmentProvider
        .getStateIdByName(recieverAddressFill?.administrativeArea ?? '');
    int? senderPlaceId = addShipmentProvider
        .getStateIdByName(senderAddressFill?.administrativeArea ?? '');

    if (receiverPlaceId == null || senderPlaceId == null) {
      addressError = 'التوصيل متاح فقط في القاهرة والجيزة والأسكندرية';
      emit(WasullyCalculateDeliveryPriceErrorState(
          'التوصيل متاح فقط في القاهرة والجيزة والأسكندرية'));
      return;
    }
    if (!_wasullyDeliveryService.isBothPlacesValid(
      receiverPlaceId,
      senderPlaceId,
    )) {
      addressError = 'التوصيل متاح فقط في القاهرة والجيزة والأسكندرية';
      emit(WasullyCalculateDeliveryPriceErrorState(
          'التوصيل متاح فقط في القاهرة والجيزة والأسكندرية'));
      return;
    }
    if (_wasullyDeliveryService.isDeliveryToOrFromAlexandria(
      receiverPlaceId,
      senderPlaceId,
    )) {
      if (!_wasullyDeliveryService.isWithinAlexandriaOnly(
          receiverPlaceId, senderPlaceId)) {
        addressError = 'يجب أن يكون التوصيل في الإسكندرية';
        emit(WasullyCalculateDeliveryPriceErrorState(
            'يجب أن يكون التوصيل في الإسكندرية'));
        return;
      }
    }
    addressError = '';
    DeliveryPriceRequestBody body = DeliveryPriceRequestBody(
      recievingLat: recieverAddressFill!.lat.toString(),
      recievingLng: recieverAddressFill!.long.toString(),
      sendingLat: senderAddressFill!.lat.toString(),
      sendingLng: senderAddressFill!.long.toString(),
    );
    final result = await _waslnyRepo.calculateDeliveryPrice(body);
    if (result.success) {
      deliveryPriceModel = result.data;
      deliveryPriceContoller.text = result.data!.price;
      emit(WasullyCalculateDeliveryPriceSuccessState(result.data!));
    } else {
      addressError = result.error!;
      emit(WasullyCalculateDeliveryPriceErrorState(result.error!));
    }
  }

  void createWasully() async {
    emit(WasullyCreateWasullyLoadingState());

    if (orderDetailsController.text.isEmpty) {
      emit(WasullyCreateWasullyErrorState('الرجاء أدخال تفاصيل الطلب'));
      return;
    }
    if (formKey.currentState!.validate() && validateAddress()) {
      final String? imagePath = await uploadAndGetImage();
      if (imagePath == null) {
        emit(WasullyCreateWasullyErrorState('الرجاء أختيار الصورة'));
        return;
      }
      CreateWasullyRequestBody body = createWassalyBody(imagePath);
      final result = await _waslnyRepo.createWasully(body);
      if (result.success) {
        emit(WasullyCreateWasullySuccessState(result.data!.message));
      } else {
        emit(WasullyCreateWasullyErrorState(result.error!));
      }
    }
  }

  bool validateAddress() {
    if (addressError.isNotEmpty) {
      emit(WasullyCreateWasullyErrorState(addressError));
      return false;
    }
    return true;
  }

  void updateWasully() async {
    emit(WasullyCreateWasullyLoadingState());
    if (orderDetailsController.text.isEmpty) {
      emit(WasullyCreateWasullyErrorState('الرجاء أدخال تفاصيل الطلب'));
      return;
    }
    if (image == null && wasullyModel?.image == null) {
      emit(WasullyCreateWasullyErrorState('الرجاء إختيار الصورة'));
      return null;
    }
    if (formKey.currentState!.validate() && validateAddress()) {
      String? imageUrl = wasullyModel?.image;
      final String? imagePath = await uploadAndGetImage();
      if (imagePath != null) imageUrl = imagePath;
      CreateWasullyRequestBody body = createWassalyBody(imageUrl!);
      final result = await _waslnyRepo.updateWasully(wasullyModel!.id, body);
      if (result.success) {
        await _deleteImage();
        wasullyModel = result.data!;
        emit(WasullyCreateWasullySuccessState('تم تحديث الطلب بنجاح'));
      } else {
        emit(WasullyCreateWasullyErrorState(result.error!));
      }
    }
  }

  Future<void> _deleteImage() async {
    if (wasullyModel?.image == null) return;
    await _waslnyRepo.deleteImage(wasullyModel!.image!);
  }

  Future<String?> uploadAndGetImage() async {
    if (image == null) return null;
    File? compressedImage = await convertAndCompressImage(image!);
    if (compressedImage == null) return null;
    final result = await _waslnyRepo.uploadImage(
      base64Encode(
        await compressedImage.readAsBytes(),
      ),
      compressedImage.path.split('/').last,
    );
    if (result.success) return result.data!;
    emit(WasullyCreateWasullyErrorState(result.error ?? ''));
    return null;
  }

  int? getTipPrice() {
    if (tipPriceSelected == 0) {
      return null;
    } else if (tipPriceSelected == tipPrices.length - 1) {
      if (tipController.text.isEmpty) {
        return null;
      }
      return int.parse(tipController.text);
    }
    return int.parse(tipPrices[tipPriceSelected]);
  }

  CreateWasullyRequestBody createWassalyBody(String imagePath) =>
      CreateWasullyRequestBody(
        title: orderDetailsController.text,
        description: orderDetailsController.text,
        receivingLat: recieverAddressFill!.lat.toString(),
        receivingLng: recieverAddressFill!.long.toString(),
        deliveringLat: senderAddressFill!.lat.toString(),
        deliveringLng: senderAddressFill!.long.toString(),
        price: double.parse(
            deliveryPriceContoller.text.convertArabicToEnglishNumbers()),
        amount: double.parse(
            insuranceAmountController.text.convertArabicToEnglishNumbers()),
        tip: getTipPrice() ?? 0,
        phoneUser: senderPhoneController.text,
        clientPhone: receiverPhoneController.text,
        receivingState: recieverAddressFill!.administrativeArea,
        receivingCity: recieverAddressFill!.subAdministrativeArea,
        receivingStreet: recieverAddressFill!.street,
        deliveringState: senderAddressFill!.administrativeArea,
        deliveringCity: senderAddressFill!.subAdministrativeArea,
        deliveringStreet: senderAddressFill!.street,
        paymentMethod: 'online',
        whoPay: whoPayDeliveryPrice == 0 ? 'me' : 'client',
        image: imagePath,
      );
}
