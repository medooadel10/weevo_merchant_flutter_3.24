import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../../core/Dialogs/action_dialog.dart';
import '../../../core/Dialogs/add_shipment_bottom_sheet.dart';
import '../../../core/Models/child_shipment.dart';
import '../../../core/Models/product_model.dart';
import '../../../core/Providers/add_shipment_provider.dart';
import '../../../core/Providers/map_provider.dart';
import '../../../core/Providers/product_provider.dart';
import '../../../core/Storage/shared_preference.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../../../core_new/router/router.dart';
import '../../Widgets/edit_text.dart';
import '../../Widgets/expanded_product_item.dart';
import '../../Widgets/main_text.dart';
import '../../Widgets/payment_method_list.dart';

class AddShipment3 extends StatefulWidget {
  const AddShipment3({super.key});

  @override
  State<AddShipment3> createState() => _AddShipment3State();
}

class _AddShipment3State extends State<AddShipment3>
    with SingleTickerProviderStateMixin {
  late FocusNode _shipmentPriceNode;
  late TextEditingController _shipmentPriceController;
  bool _shipmentPriceFocused = false;
  bool _shipmentPriceEmpty = true;
  bool _shipmentPriceError = false;
  bool _codError = false;
  bool _validate = false;
  bool _isOpen = false;
  int? _selectedItem;
  late AddShipmentProvider _shipmentProvider;
  late ProductProvider _productProvider;
  bool isExpanded = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _shipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    _productProvider = Provider.of<ProductProvider>(context, listen: false);

    _shipmentPriceNode = FocusNode();
    _shipmentPriceController = TextEditingController();
    if (_shipmentProvider.isUpdated || _shipmentProvider.isUpdateFromServer) {
      _selectedItem = paymentList.indexOf(paymentList
          .where((item) =>
              item.paymentMethodTitle == _shipmentProvider.paymentMethod)
          .toList()[0]);
    }
    _shipmentPriceNode.addListener(() {
      _shipmentPriceFocused = _shipmentPriceNode.hasFocus;
    });
    if (_shipmentProvider.shipmentFee != null) {
      _shipmentPriceController.text = _shipmentProvider.shipmentFee.toString();
    }
    populateProductList();
  }

  void populateProductList() {
    List<Product> list = [];
    for (var i in _productProvider.products) {
      Product? p = _shipmentProvider.chosenProducts
          .firstWhereOrNull((c) => c.id == i.id);
      if (p != null) {
        list.add(p);
      } else {
        list.add(i);
      }
    }
    _shipmentProvider.addShipmentProducts(list);
  }

  @override
  void dispose() {
    _shipmentPriceNode.dispose();
    _shipmentPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shipmentProvider = AddShipmentProvider.get(context);
    final mapProvider = Provider.of<MapProvider>(context);
    log(Preferences.instance.getUserId);
    log(Preferences.instance.getAccessToken);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              await showModalBottomSheet(
                context: navigator.currentContext!,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      20.0,
                    ),
                    topRight: Radius.circular(
                      20.0,
                    ),
                  ),
                ),
                builder: (context) {
                  populateProductList();
                  return const AddShipmentBottomSheet();
                },
                isDismissible: false,
                enableDrag: false,
                isScrollControlled: true,
              );
            },
            child: Container(
              height: size.height * 0.07,
              width: size.width,
              decoration: BoxDecoration(
                color: weevoGreyColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر من قائمة المنتجات',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Icon(
                      Icons.expand_more_rounded,
                      color: weevoPrimaryOrangeColor,
                      size: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _validate && !shipmentProvider.isNotEmpty
              ? SizedBox(
                  height: size.height * 0.01,
                )
              : Container(),
          _validate && !shipmentProvider.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                  ),
                  child: Text(
                    'من فضلك اختر المنتجات المراد شحنها',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 12.0,
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: size.height * .03,
          ),
          shipmentProvider.isNotEmpty
              ? Form(
                  key: _formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'عدد المنتجات   ${shipmentProvider.chosenProducts.length}',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: weevoPrimaryOrangeColor,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * .01,
                              ),
                              AnimatedContainer(
                                duration: const Duration(
                                  milliseconds: 400,
                                ),
                                height: isExpanded
                                    ? shipmentProvider.chosenProducts.length ==
                                            1
                                        ? size.height * 0.16
                                        : size.height * 0.16 * 2
                                    : size.height * 0.0,
                                width: size.width,
                                child: ListView.builder(
                                  itemBuilder: (context, i) =>
                                      ExpandedProductItem(
                                    product: shipmentProvider.chosenProducts[i],
                                  ),
                                  itemCount:
                                      shipmentProvider.chosenProducts.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'مبلغ مقدم الطلب',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: weevoGreyColor,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${shipmentProvider.total}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0.w,
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Text(
                                          'جنية',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      if (!(shipmentProvider.shipmentFromWhere == giftShipment))
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isOpen = true;
                            });
                            await showModalBottomSheet(
                              context: navigator.currentContext!,
                              builder: (context) => PaymentMethodList(
                                onItemClick: (String title, int i) {
                                  MagicRouter.pop();
                                  shipmentProvider.setPaymentMethod(title);
                                  setState(() {
                                    _selectedItem = i;
                                    // if(!(shipmentProvider.shipmentFromWhere == giftShipment))
                                    //   _selectedItem=
                                    log(_selectedItem.toString());
                                  });
                                },
                                selectedItem: _selectedItem ?? 0,
                                paymentMethods: paymentList,
                              ),
                              backgroundColor: weevoWhiteWithSilver,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    20.0,
                                  ),
                                  topRight: Radius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                            );
                            setState(() {
                              _isOpen = false;
                            });
                          },
                          child: Container(
                            height: size.height * 0.07,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: weevoGreyColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'طريقة الدفع',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  Row(
                                    children: [
                                      shipmentProvider.paymentMethod != null
                                          ? Text(
                                              shipmentProvider.paymentMethod!,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                color: weevoGreyWithBlack,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Icon(
                                        _isOpen
                                            ? Icons.keyboard_arrow_up
                                            : Icons.expand_more_rounded,
                                        color: weevoPrimaryOrangeColor,
                                        size: 30.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      _codError
                          ? SizedBox(
                              height: size.height * 0.01,
                            )
                          : Container(),
                      if (!(shipmentProvider.shipmentFromWhere == giftShipment))
                        _codError
                            ? Text(
                                'من فضلك ادخل طريقة الدفع',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600),
                              )
                            : Container(),
                      if (shipmentProvider.couponModel != null)
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      if (shipmentProvider.couponModel != null)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'لديك خصم ${shipmentProvider.couponModel!.couponDiscountValue} ${shipmentProvider.couponModel!.couponDiscountType == 'amount' ? 'جنية' : '%'} علي سعر التوصيل يطبق عند الموفقة علي عرض احد الكباتن',
                                textAlign: TextAlign.start,
                                maxLines: 3,
                                style: const TextStyle(
                                    color: weevoPrimaryBlueColor,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      if (!(shipmentProvider.shipmentFromWhere == giftShipment))
                        SizedBox(
                          height: size.height * .01,
                        ),
                      if (!shipmentProvider.couponFound)
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'كود الخصم',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: EditText(
                                controller:
                                    shipmentProvider.couponCodeController,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                upperTitle: false,
                                action: TextInputAction.done,
                                type: TextInputType.text,
                                labelText: 'كود الخصم',
                                suffix: InkWell(
                                  onTap: () async {
                                    if (shipmentProvider
                                        .couponCodeController.text.isNotEmpty) {
                                      await shipmentProvider.checkCoupons();
                                    } else {
                                      showDialog(
                                          context: navigator.currentContext!,
                                          builder: (_) => ActionDialog(
                                                content:
                                                    'من فضلك أدخل كود صحيح',
                                                approveAction: 'حسناً',
                                                onApproveClick: () {
                                                  MagicRouter.pop();
                                                },
                                              ));
                                    }
                                  },
                                  child: Container(
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                        color: weevoPrimaryOrangeColor,
                                        borderRadius:
                                            BorderRadius.circular(12.r)),
                                    child: Center(
                                      child: MainText(
                                        text: 'تطبيق',
                                        color: Colors.white,
                                        font: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (!shipmentProvider.couponFound)
                        SizedBox(
                          height: 20.h,
                        ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'مبلغ الشحن',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                EditText(
                                  readOnly: false,
                                  controller: _shipmentPriceController,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  upperTitle: false,
                                  align: TextAlign.left,
                                  focusNode: _shipmentPriceNode,
                                  action: TextInputAction.done,
                                  onFieldSubmit: (_) {
                                    _shipmentPriceNode.unfocus();
                                  },
                                  isFocus: _shipmentPriceFocused,
                                  radius: 20.0,
                                  isPhoneNumber: false,
                                  shouldDisappear: !_shipmentPriceFocused &&
                                      !_shipmentPriceEmpty,
                                  onSave: (String? value) {},
                                  onChange: (String? value) {
                                    setState(() {
                                      _shipmentPriceEmpty = value!.isEmpty;
                                    });
                                  },
                                  type: TextInputType.number,
                                  validator: (String? value) {
                                    if (value!.isEmpty ||
                                        num.parse(value) <
                                            num.parse(shipmentProvider
                                                    .priceFromDistanceModel!
                                                    .price!)
                                                .toInt()) {
                                      _shipmentPriceError = true;
                                      shipmentProvider.setShipmentFee(null);
                                    } else {
                                      _shipmentPriceError = false;
                                      shipmentProvider.setShipmentFee(value);
                                    }
                                    return null;
                                  },
                                  labelText: '',
                                  suffix: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Text(
                                          'جنية',
                                        ),
                                      ),
                                    ],
                                  ),
                                  isPassword: false,
                                ),
                                _shipmentPriceError
                                    ? SizedBox(
                                        height: size.height * 0.01,
                                      )
                                    : Container(),
                                _shipmentPriceError
                                    ? Text(
                                        'يجب الا يقل سعر الشحن عن الحد الادني للشحن',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.red[800],
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (shipmentProvider.priceFromDistanceModel != null)
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      if (shipmentProvider.priceFromDistanceModel != null)
                        Row(
                          children: [
                            Text(
                              'الحد الادني لسعر الشحن (${num.parse(shipmentProvider.priceFromDistanceModel!.price!).roundToDouble().toInt()}) جنية',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  color: weevoPrimaryBlueColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: size.height * .03,
                      ),
                    ],
                  ),
                )
              : Container(),
          TextButton(
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all<Size>(
                Size(
                  size.width,
                  size.height * 0.07,
                ),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                weevoPrimaryBlueColor,
              ),
            ),
            onPressed: () {
              if ((_shipmentProvider.shipmentFromWhere == giftShipment)) {
                _shipmentProvider.setPaymentMethod('online');
              }
              if (shipmentProvider.test) {
                shipmentProvider.setIndex(3);
              } else {
                setState(() {
                  _validate = true;
                });
                if (shipmentProvider.isNotEmpty) {
                  if (_formState.currentState!.validate() &&
                      shipmentProvider.shipmentFee != null &&
                      shipmentProvider.paymentMethod != null) {
                    log('${shipmentProvider.total}');
                    log('${shipmentProvider.paymentMethod}');
                    setState(() {
                      _shipmentPriceError = false;
                      _codError = false;
                    });
                    _formState.currentState!.save();
                    if (shipmentProvider.isUpdated) {
                      shipmentProvider.setIsUpdated(false);
                      ChildShipment shipment = ChildShipment(
                        deliveringState: shipmentProvider
                            .getStateIdByName(shipmentProvider.stateName!)
                            .toString(),
                        deliveringCity: shipmentProvider
                            .getCityIdByName(shipmentProvider.stateName!,
                                shipmentProvider.cityName!)
                            .toString(),
                        deliveringStreet: shipmentProvider.clientAddress,
                        deliveringLandmark: shipmentProvider.landmark,
                        deliveringBuildingNumber:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider
                                    .merchantAddress!.buildingNumber
                                : mapProvider.fullAddress!.buildingNumber,
                        deliveringFloor:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider.merchantAddress!.floor
                                : mapProvider.fullAddress!.floor,
                        deliveringApartment:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider.merchantAddress!.apartment
                                : mapProvider.fullAddress!.apartment,
                        deliveringLat:
                            shipmentProvider.receiveLocationLatController.text,
                        deliveringLng:
                            shipmentProvider.receiveLocationLangController.text,
                        receivingLat: shipmentProvider.merchantAddress != null
                            ? shipmentProvider.merchantAddress!.lat
                            : mapProvider.fullAddress!.lat,
                        receivingLng: shipmentProvider.merchantAddress != null
                            ? shipmentProvider.merchantAddress!.lng
                            : mapProvider.fullAddress!.lng,
                        coupon: shipmentProvider.couponModel?.id,
                        dateToDeliverShipment:
                            intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                DateTime.parse(
                                    shipmentProvider.realReceiveDateTime!)),
                        dateToReceiveShipment:
                            intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                DateTime.parse(
                                    shipmentProvider.realDeliveryDateTime!)),
                        //2021-03-30 20:58:23
                        receivingStreet:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider.merchantAddress!.street
                                : mapProvider.fullAddress!.street,
                        paymentMethod:
                            _shipmentProvider.shipmentFromWhere == giftShipment
                                ? 'online'
                                : shipmentProvider.paymentMethod ==
                                        paymentList[0].paymentMethodTitle
                                    ? 'online'
                                    : 'cod',
                        clientPhone: shipmentProvider.clientPhoneNumber,
                        clientName: shipmentProvider.clientName,
                        products: [...shipmentProvider.chosenProducts],
                        shippingCost: shipmentProvider.shipmentFee.toString(),
                        receivingCity: shipmentProvider.merchantAddress != null
                            ? shipmentProvider
                                .getCityIdByName(
                                    shipmentProvider.merchantAddress!.state!,
                                    shipmentProvider.merchantAddress!.city!)
                                .toString()
                            : shipmentProvider
                                .getCityIdByName(
                                    mapProvider.fullAddress!.state!,
                                    mapProvider.fullAddress!.city!)
                                .toString(),
                        receivingState: shipmentProvider.merchantAddress != null
                            ? shipmentProvider
                                .getStateIdByName(
                                    shipmentProvider.merchantAddress!.state!)
                                .toString()
                            : shipmentProvider
                                .getStateIdByName(
                                    mapProvider.fullAddress!.state!)
                                .toString(),
                        receivingLandmark:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider.merchantAddress!.landmark
                                : mapProvider.fullAddress!.landmark,
                        notes: shipmentProvider.otherDetails,
                        amount: shipmentProvider.total.toString(),
                      );
                      shipmentProvider.updateShipment(
                        shipment,
                        shipmentProvider.previousIndex!,
                      );
                    } else {
                      ChildShipment shipment = ChildShipment(
                        deliveringState: shipmentProvider
                            .getStateIdByName(shipmentProvider.stateName!)
                            .toString(),
                        deliveringCity: shipmentProvider
                            .getCityIdByName(shipmentProvider.stateName!,
                                shipmentProvider.cityName!)
                            .toString(),
                        deliveringStreet: shipmentProvider.clientAddress,
                        deliveringLandmark: shipmentProvider.landmark,
                        deliveringBuildingNumber:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider
                                    .merchantAddress!.buildingNumber
                                : mapProvider.fullAddress!.buildingNumber,
                        deliveringFloor:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider.merchantAddress!.floor
                                : mapProvider.fullAddress!.floor,
                        deliveringApartment:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider.merchantAddress!.apartment
                                : mapProvider.fullAddress!.apartment,
                        receivingLat: shipmentProvider.merchantAddress != null
                            ? shipmentProvider.merchantAddress!.lat
                            : mapProvider.fullAddress!.lat,
                        receivingLng: shipmentProvider.merchantAddress != null
                            ? shipmentProvider.merchantAddress!.lng
                            : mapProvider.fullAddress!.lng,
                        deliveringLat:
                            shipmentProvider.receiveLocationLatController.text,
                        deliveringLng:
                            shipmentProvider.receiveLocationLangController.text,
                        dateToDeliverShipment:
                            intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                DateTime.parse(
                                    shipmentProvider.realReceiveDateTime!)),
                        dateToReceiveShipment:
                            intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                DateTime.parse(
                                    shipmentProvider.realDeliveryDateTime!)),
                        //2021-03-30 20:58:23
                        coupon: shipmentProvider.couponModel?.id,
                        receivingStreet:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider.merchantAddress!.street
                                : mapProvider.fullAddress!.street,
                        paymentMethod:
                            _shipmentProvider.shipmentFromWhere == giftShipment
                                ? 'online'
                                : shipmentProvider.paymentMethod ==
                                        paymentList[0].paymentMethodTitle
                                    ? 'online'
                                    : 'cod',
                        clientPhone: shipmentProvider.clientPhoneNumber,
                        clientName: shipmentProvider.clientName,
                        products: [...shipmentProvider.chosenProducts],
                        shippingCost: shipmentProvider.shipmentFee.toString(),
                        receivingCity: shipmentProvider.merchantAddress != null
                            ? shipmentProvider
                                .getCityIdByName(
                                    shipmentProvider.merchantAddress!.state!,
                                    shipmentProvider.merchantAddress!.city!)
                                .toString()
                            : shipmentProvider
                                .getCityIdByName(
                                    mapProvider.fullAddress!.state!,
                                    mapProvider.fullAddress!.city!)
                                .toString(),
                        receivingState: shipmentProvider.merchantAddress != null
                            ? shipmentProvider
                                .getStateIdByName(
                                    shipmentProvider.merchantAddress!.state!)
                                .toString()
                            : shipmentProvider
                                .getStateIdByName(
                                    mapProvider.fullAddress!.state!)
                                .toString(),
                        receivingLandmark:
                            shipmentProvider.merchantAddress != null
                                ? shipmentProvider.merchantAddress!.landmark
                                : mapProvider.fullAddress!.landmark,
                        notes: shipmentProvider.otherDetails,
                        amount: shipmentProvider.total.toString(),
                      );
                      shipmentProvider.addNewShipment(shipment);
                      if (shipmentProvider.shipmentMessage == addOneMore) {
                        shipmentProvider.setShipmentMessage(null);
                      }
                    }
                    shipmentProvider.reset(false);
                    shipmentProvider.setIndex(3);
                  } else {
                    if (shipmentProvider.shipmentFee == null ||
                        num.parse(shipmentProvider.shipmentFee!).toInt() < 50) {
                      setState(() {
                        _shipmentPriceError = true;
                      });
                    }
                    if (shipmentProvider.paymentMethod == null) {
                      setState(() {
                        _codError = true;
                      });
                    }
                  }
                }
              }
            },
            child: const Text(
              'التالي',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
