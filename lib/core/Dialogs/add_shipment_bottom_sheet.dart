import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/Screens/add_product.dart';
import '../../features/Widgets/edit_text.dart';
import '../../features/Widgets/horizontal_reusable_item.dart';
import '../Models/add_product_arg.dart';
import '../Models/product_model.dart';
import '../Providers/add_shipment_provider.dart';
import '../Providers/product_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../router/router.dart';
import 'action_dialog.dart';

class AddShipmentBottomSheet extends StatefulWidget {
  const AddShipmentBottomSheet({super.key});

  @override
  State<AddShipmentBottomSheet> createState() => _AddShipmentBottomSheetState();
}

class _AddShipmentBottomSheetState extends State<AddShipmentBottomSheet> {
  bool _searchFocused = false;
  late FocusNode _searchNode;
  List<Product> previousProducts = [];
  List<Product> previousChosenProducts = [];
  late AddShipmentProvider _shipmentProvider;

  @override
  void initState() {
    super.initState();
    _shipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    _searchNode = FocusNode();
    _searchNode.addListener(() {
      _searchFocused = _searchNode.hasFocus;
    });
    previousProducts = [..._shipmentProvider.shipmentProducts];
    previousChosenProducts = [..._shipmentProvider.chosenProducts];
  }

  @override
  void dispose() {
    _searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (shipmentProvider.chosenProducts.isNotEmpty) {
          showDialog(
            context: navigator.currentContext!,
            builder: (context) => ActionDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              content: 'لن يتم أضافة تعدبلاتك الجديدة\nهل تود ذلك ؟',
              onApproveClick: () {
                if (previousProducts.isNotEmpty) {
                  shipmentProvider.addShipmentProducts(previousProducts);
                }
                if (previousChosenProducts.isNotEmpty) {
                  shipmentProvider.addAllChosenProduct(previousChosenProducts);
                }
                MagicRouter.pop();
                MagicRouter.pop();
              },
              onCancelClick: () {
                MagicRouter.pop();
              },
              approveAction: 'نعم',
              cancelAction: 'لا',
            ),
          );
        } else {
          MagicRouter.pop();
        }
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: EditText(
                      readOnly: false,
                      suffix: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      validator: (String? value) {
                        return null;
                      },
                      onSave: (String? value) {},
                      onChange: (String? value) {
                        shipmentProvider.filterShipment(
                          productProvider.products,
                          value ?? '',
                        );
                      },
                      labelText: 'ابحث عن منتج معين',
                      isFocus: _searchFocused,
                      focusNode: _searchNode,
                      radius: 12.0,
                      isPassword: false,
                      isPhoneNumber: false,
                      shouldDisappear: false,
                      upperTitle: false,
                    ),
                  ),
                ),
                _searchFocused
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: shipmentProvider.searchList.length,
                          itemBuilder: (context, i) => HorizontalReusableItem(
                            product: shipmentProvider.searchList[i],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: shipmentProvider.shipmentProducts.length,
                          itemBuilder: (context, i) => HorizontalReusableItem(
                            product: shipmentProvider.shipmentProducts[i],
                          ),
                        ),
                      ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                      right: 20.0,
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        MagicRouter.pop();
                        Navigator.pushNamed(
                          navigator.currentContext!,
                          AddProduct.id,
                          arguments: AddProductArg(
                              isUpdated: false,
                              isDuplicate: false,
                              from: add_shipment),
                        );
                      },
                      backgroundColor: weevoPrimaryBlueColor,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  shipmentProvider.chosenProducts.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20.0,
                            right: 20.0,
                          ),
                          child: FloatingActionButton(
                            onPressed: () {
                              MagicRouter.pop();
                            },
                            backgroundColor: weevoPrimaryOrangeColor,
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
