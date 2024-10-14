import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Dialogs/category_bottom_sheet.dart';
import '../../core/Dialogs/image_picker_dialog.dart';
import '../../core/Models/category_data.dart';
import '../../core/Models/image.dart';
import '../../core/Models/product_model.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/product_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core_new/router/router.dart';
import '../../core_new/widgets/custom_image.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/loading_widget.dart';
import 'merchant_warehouse.dart';
import 'product_details.dart';

class AddProduct extends StatefulWidget {
  static const String id = 'Add_Product';
  final bool isUpdated;
  final bool isDuplicate;
  final String? from;
  final Product? product;

  const AddProduct({
    super.key,
    required this.isUpdated,
    required this.isDuplicate,
    this.product,
    this.from,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  int? productCategory, _imageCounter = 0, _selectedItem;
  Img? _img, _oldImage;
  String? productName,
      productPrice,
      productLength,
      productWidth,
      productHeight,
      productWeight,
      merchantId,
      productImage,
      productDescription;
  late TextEditingController _titleController,
      _priceController,
      _heightController,
      _widthController,
      _lengthController,
      _weightController,
      _categoryController,
      _descriptionController;

  bool _imageHasError = false;
  bool _sizeHasError = false;
  bool _weightHasError = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late FocusNode _productNameNode,
      _productPriceNode,
      _productWeightNode,
      _productHeightNode,
      _productLengthNode,
      _productWidthNode,
      _categoryNode,
      _productDescriptionNode;
  bool _productNameFocused = false;
  bool _categoryFocused = false;
  bool _productDescriptionFocused = false;
  bool _productPriceFocused = false;
  bool _productWeightFocused = false;
  bool _productHeightFocused = false;
  bool _productWidthFocused = false;
  bool _productLengthFocused = false;
  bool _productNameIsEmpty = true;
  bool _categoryIsEmpty = true;
  bool _productDescriptionIsEmpty = true;
  bool _productPriceIsEmpty = true;
  bool _productWeightIsEmpty = true;
  bool _productHeightIsEmpty = true;
  bool _productWidthIsEmpty = true;
  bool _productLengthIsEmpty = true;
  late AuthProvider _authProvider;
  late ProductProvider _productProvider;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productNameNode = FocusNode();
    _categoryNode = FocusNode();
    _productPriceNode = FocusNode();
    _productWeightNode = FocusNode();
    _productWidthNode = FocusNode();
    _productHeightNode = FocusNode();
    _productLengthNode = FocusNode();
    _productDescriptionNode = FocusNode();
    _titleController = TextEditingController();
    _categoryController = TextEditingController();
    _priceController = TextEditingController();
    _heightController = TextEditingController();
    _widthController = TextEditingController();
    _weightController = TextEditingController();
    _lengthController = TextEditingController();
    _descriptionController = TextEditingController();
    _titleController.addListener(() {
      setState(() {
        _productNameIsEmpty = _titleController.text.isEmpty;
      });
    });
    _categoryController.addListener(() {
      setState(() {
        _categoryIsEmpty = _categoryController.text.isEmpty;
      });
    });
    _priceController.addListener(() {
      setState(() {
        _productPriceIsEmpty = _priceController.text.isEmpty;
      });
    });
    _heightController.addListener(() {
      setState(() {
        _productHeightIsEmpty = _heightController.text.isEmpty;
      });
    });
    _widthController.addListener(() {
      setState(() {
        _productWidthIsEmpty = _widthController.text.isEmpty;
      });
    });
    _weightController.addListener(() {
      setState(() {
        _productWeightIsEmpty = _weightController.text.isEmpty;
      });
    });
    _lengthController.addListener(() {
      setState(() {
        _productLengthIsEmpty = _lengthController.text.isEmpty;
      });
    });
    _descriptionController.addListener(() {
      setState(() {
        _productDescriptionIsEmpty = _descriptionController.text.isEmpty;
      });
    });

    _productNameNode.addListener(() {
      setState(() {
        _productNameFocused = _productNameNode.hasFocus;
      });
    });
    _categoryNode.addListener(() {
      setState(() {
        _categoryFocused = _categoryNode.hasFocus;
      });
    });
    _productDescriptionNode.addListener(() {
      setState(() {
        _productDescriptionFocused = _productDescriptionNode.hasFocus;
      });
    });
    _productPriceNode.addListener(() {
      setState(() {
        _productPriceFocused = _productPriceNode.hasFocus;
      });
    });
    _productWeightNode.addListener(() {
      setState(() {
        _productWeightFocused = _productWeightNode.hasFocus;
      });
    });
    _productHeightNode.addListener(() {
      setState(() {
        _productHeightFocused = _productHeightNode.hasFocus;
      });
    });
    _productWidthNode.addListener(() {
      setState(() {
        _productWidthFocused = _productWidthNode.hasFocus;
      });
    });
    _productLengthNode.addListener(() {
      setState(() {
        _productLengthFocused = _productLengthNode.hasFocus;
      });
    });
    if (widget.isUpdated || widget.isDuplicate) {
      _titleController.text = widget.product!.name!;
      _selectedItem = _productProvider.categories
          .indexOf(_productProvider.getCatById(widget.product!.categoryId!)!);
      _priceController.text = widget.product!.price.toString();
      _heightController.text = widget.product!.height!;
      _widthController.text = widget.product!.width!;
      _lengthController.text = widget.product!.length!;
      _weightController.text = widget.product!.weight!;
      productImage = widget.product!.image;
      productCategory = widget.product!.categoryId!;
      _descriptionController.text = widget.product!.description!;
      _categoryController.text =
          _productProvider.getCatById(widget.product!.categoryId!)!.name!;
    }
    _productNameIsEmpty = _titleController.text.isEmpty;
    _productDescriptionIsEmpty = _descriptionController.text.isEmpty;
    _productPriceIsEmpty = _priceController.text.isEmpty;
    _productWeightIsEmpty = _weightController.text.isEmpty;
    _productHeightIsEmpty = _heightController.text.isEmpty;
    _productWidthIsEmpty = _widthController.text.isEmpty;
    _productLengthIsEmpty = _lengthController.text.isEmpty;
  }

  @override
  void dispose() {
    _productNameNode.dispose();
    _productPriceNode.dispose();
    _productWeightNode.dispose();
    _categoryNode.dispose();
    _productWidthNode.dispose();
    _productHeightNode.dispose();
    _productLengthNode.dispose();
    _productDescriptionNode.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          showDialog(
            context: navigator.currentContext!,
            builder: (context) => ActionDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              title: 'الخروج',
              content: 'هل تود الخروج',
              onApproveClick: () {
                MagicRouter.pop();
                if (widget.from == from_warehouse) {
                  MagicRouter.pop();
                  Navigator.pushReplacementNamed(
                    context,
                    MerchantWarehouse.id,
                  );
                } else if (widget.from == add_shipment) {
                  Navigator.pop(navigator.currentContext!);
                  Navigator.pop(navigator.currentContext!);
                } else {
                  MagicRouter.pop();
                  Navigator.pushReplacementNamed(
                    context,
                    ProductDetails.id,
                    arguments: productProvider.productById!.id,
                  );
                }
              },
              onCancelClick: () {
                MagicRouter.pop();
              },
              approveAction: 'نعم',
              cancelAction: 'لا',
            ),
          );
          return false;
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: LoadingWidget(
              isLoading: productProvider.addProductLoading,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: navigator.currentContext!,
                              builder: (context) => ActionDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ),
                                ),
                                title: 'الخروج',
                                content: 'هل تود الخروج',
                                onApproveClick: () {
                                  if (widget.from == from_warehouse) {
                                    MagicRouter.pop();
                                    MagicRouter.pop();
                                  } else if (widget.from == add_shipment) {
                                    Navigator.pop(navigator.currentContext!);
                                    Navigator.pop(navigator.currentContext!);
                                  } else {
                                    MagicRouter.pop();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      ProductDetails.id,
                                      arguments:
                                          productProvider.productById!.id,
                                    );
                                  }
                                  MagicRouter.pop();
                                },
                                onCancelClick: () {
                                  MagicRouter.pop();
                                },
                                approveAction: 'نعم',
                                cancelAction: 'لا',
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'إضافة منتج',
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: weevoPrimaryOrangeColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          15.0,
                        ),
                        bottomRight: Radius.circular(
                          15.0,
                        ),
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    floating: true,
                    pinned: true,
                    expandedHeight: size.height * 0.3,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        children: [
                          productImage != null
                              ? SizedBox(
                                  height: size.height * 0.35,
                                  width: size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                    child: productImage!.contains('http')
                                        ? CustomImage(
                                            imageUrl: productImage,
                                          )
                                        : Image.file(
                                            File(productImage!),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                )
                              : Container(
                                  width: size.width,
                                  color: const Color(0xffFEF0E5),
                                  child: SafeArea(
                                    child: Image.asset(
                                        'assets/images/scotter_guy_1500px_resized.png'),
                                  ),
                                ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: size.height * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(
                            16.0,
                          ),
                          child: Form(
                            key: _formState,
                            child: Column(
                              children: [
                                EditText(
                                  readOnly: false,
                                  controller: _titleController,
                                  upperTitle: true,
                                  radius: 12.0.r,
                                  labelColor: Colors.grey,
                                  labelFontSize: 15.0.sp,
                                  align: TextAlign.start,
                                  onChange: (value) {
                                    isButtonPressed = false;
                                    if (isError) {
                                      _formState.currentState!.validate();
                                    }
                                    setState(() {
                                      _productNameIsEmpty = value!.isEmpty;
                                    });
                                  },
                                  shouldDisappear: !_productNameIsEmpty &&
                                      !_productNameFocused,
                                  action: TextInputAction.done,
                                  onFieldSubmit: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_productDescriptionNode);
                                  },
                                  isPhoneNumber: false,
                                  isPassword: false,
                                  isFocus: _productNameFocused,
                                  focusNode: _productNameNode,
                                  validator: (String? output) {
                                    if (!isButtonPressed) {
                                      return null;
                                    }
                                    isError = true;
                                    if (output!.isEmpty) {
                                      return 'من فضلك أدخل اسم المنتج';
                                    }
                                    isError = false;
                                    return null;
                                  },
                                  onSave: (String? value) {
                                    productName = value;
                                  },
                                  labelText: 'أسم المنتج',
                                ),
                                // SizedBox(
                                //   height: size.height * 0.02,
                                // ),
                                EditText(
                                  readOnly: false,
                                  controller: _descriptionController,
                                  upperTitle: true,
                                  type: TextInputType.multiline,
                                  maxLines: 4,
                                  radius: 12.0.r,
                                  labelColor: Colors.grey,
                                  labelFontSize: 15.0.sp,
                                  align: TextAlign.start,
                                  onChange: (String? value) {
                                    isButtonPressed = false;
                                    if (isError) {
                                      _formState.currentState!.validate();
                                    }
                                    setState(() {
                                      _productDescriptionIsEmpty =
                                          value!.isEmpty;
                                    });
                                  },
                                  shouldDisappear:
                                      !_productDescriptionIsEmpty &&
                                          !_productDescriptionFocused,
                                  action: TextInputAction.done,
                                  onFieldSubmit: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_productPriceNode);
                                  },
                                  isPhoneNumber: false,
                                  isPassword: false,
                                  isFocus: _productDescriptionFocused,
                                  focusNode: _productDescriptionNode,
                                  validator: (String? output) {
                                    if (!isButtonPressed) {
                                      return null;
                                    }
                                    isError = true;
                                    if (output!.isEmpty) {
                                      return 'من فضلك أدخل مواصفات المنتج';
                                    }
                                    isError = false;
                                    return null;
                                  },
                                  onSave: (String? saved) {
                                    productDescription = saved;
                                  },
                                  labelText: 'مواصفات المنتج',
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                EditText(
                                  readOnly: true,
                                  upperTitle: true,
                                  labelColor: Colors.grey,
                                  labelText: 'نوع المنتج',
                                  onChange: (String? v) {
                                    isButtonPressed = false;
                                    if (isError) {
                                      _formState.currentState!.validate();
                                    }
                                  },
                                  onTap: () async {
                                    await showModalBottomSheet(
                                      context: navigator.currentContext!,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25.0),
                                        topLeft: Radius.circular(25.0),
                                      )),
                                      builder: (ctx) {
                                        FocusScope.of(context)
                                            .requestFocus(_categoryNode);
                                        return CategoryBottomSheet(
                                          onItemClick:
                                              (CategoryData item, int i) {
                                            setState(() {
                                              _selectedItem = i;
                                              _categoryController.text =
                                                  item.name!;
                                              productCategory = item.id;
                                              Navigator.pop(ctx);
                                            });
                                          },
                                          categories:
                                              productProvider.categories,
                                          selectedItem: _selectedItem ?? 0,
                                        );
                                      },
                                    );
                                    _categoryNode.unfocus();
                                  },
                                  shouldDisappear:
                                      !_categoryIsEmpty && !_categoryFocused,
                                  controller: _categoryController,
                                  isPassword: false,
                                  labelFontSize: 15.0.sp,
                                  isPhoneNumber: false,
                                  suffix: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: _categoryFocused
                                        ? weevoPrimaryOrangeColor
                                        : Colors.grey,
                                  ),
                                  validator: (String? value) {
                                    if (!isButtonPressed) {
                                      return null;
                                    }
                                    isError = true;
                                    if (value!.isEmpty) {
                                      return 'من فضلك اختر نوع المنتج';
                                    }
                                    isError = false;
                                    return null;
                                  },
                                  onSave: (_) {},
                                  focusNode: _categoryNode,
                                  isFocus: _categoryFocused,
                                ),
                                EditText(
                                  readOnly: false,
                                  controller: _priceController,
                                  upperTitle: true,
                                  radius: 12.0.r,
                                  labelColor: Colors.grey,
                                  suffix: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Text('جنية'),
                                      ),
                                    ],
                                  ),
                                  onChange: (value) {
                                    isButtonPressed = false;
                                    if (isError) {
                                      _formState.currentState!.validate();
                                    }
                                    setState(() {
                                      _productPriceIsEmpty = value!.isEmpty;
                                    });
                                  },
                                  type: TextInputType.number,
                                  labelFontSize: 15.0.sp,
                                  shouldDisappear: !_productPriceIsEmpty &&
                                      !_productPriceFocused,
                                  action: TextInputAction.done,
                                  onFieldSubmit: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_productHeightNode);
                                  },
                                  isPhoneNumber: false,
                                  isPassword: false,
                                  isFocus: _productPriceFocused,
                                  focusNode: _productPriceNode,
                                  validator: (String? output) {
                                    if (!isButtonPressed) {
                                      return null;
                                    }
                                    isError = true;
                                    if (output!.isEmpty) {
                                      return 'من فضلك ادخل سعر المنتج';
                                    } else if (num.parse(output).toInt() < 10) {
                                      return 'يجب الا يقل سعر المنتج عن ١٠ جنية';
                                    }
                                    isError = false;
                                    return null;
                                  },
                                  onSave: (String? saved) {
                                    productPrice = saved;
                                  },
                                  labelText: 'سعر المنتج',
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_img != null) {
                                      _oldImage = _img;
                                    }
                                    !productProvider.imageLoading
                                        ? showModalBottomSheet(
                                            context: navigator.currentContext!,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                  20.0.r,
                                                ),
                                                topLeft: Radius.circular(
                                                  20.0.r,
                                                ),
                                              ),
                                            ),
                                            builder: (_) => ImagePickerDialog(
                                              onImageReceived:
                                                  (XFile? imageFile) async {
                                                if (imageFile == null) return;
                                                log(imageFile.path);
                                                if (!widget.isUpdated) {
                                                  _imageCounter =
                                                      _imageCounter! + 1;
                                                }
                                                MagicRouter.pop();
                                                productProvider
                                                    .setImageLoading(true);
                                                File? compressedImage =
                                                    await compressFile(
                                                        imageFile.path);
                                                log('compresed -> ${compressedImage?.path}');
                                                if (widget.isUpdated) {
                                                  _img = await productProvider
                                                      .uploadPhoto(
                                                    path: base64Encode(
                                                      await compressedImage!
                                                          .readAsBytes(),
                                                    ),
                                                    imageName: compressedImage
                                                        .path
                                                        .split('/')
                                                        .last,
                                                  );
                                                } else {
                                                  if (_imageCounter! > 1) {
                                                    await productProvider
                                                        .deletePhoto(
                                                      token: _oldImage!.token!,
                                                      imageName:
                                                          _oldImage!.filename!,
                                                    );

                                                    _img = await productProvider
                                                        .uploadPhoto(
                                                      path: base64Encode(
                                                          await compressedImage!
                                                              .readAsBytes()),
                                                      imageName: imageFile.path
                                                          .split('/')
                                                          .last,
                                                    );
                                                  } else {
                                                    log(imageFile.path);
                                                    _img = await productProvider
                                                        .uploadPhoto(
                                                      path: base64Encode(
                                                          await compressedImage!
                                                              .readAsBytes()),
                                                      imageName: imageFile.path
                                                          .split('/')
                                                          .last,
                                                    );
                                                  }
                                                }
                                                setState(
                                                  () =>
                                                      productImage = _img!.path,
                                                );
                                                log('productImage -> $productImage');
                                                log('_img.path -> ${_img!.path}');
                                                productProvider
                                                    .setImageLoading(false);
                                              },
                                            ),
                                          )
                                        : Container();
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 16.0,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0.r),
                                            color: weevoGreyColor),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'صورة المنتج',
                                              style: TextStyle(
                                                fontSize: 15.0.r,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            productProvider.imageLoading
                                                ? SizedBox(
                                                    height: 24.0.h,
                                                    width: 24.0.w,
                                                    child:
                                                        const CircularProgressIndicator(),
                                                  )
                                                : const Icon(
                                                    Icons.image,
                                                    color: Colors.grey,
                                                  )
                                          ],
                                        ),
                                      ),
                                      _imageHasError
                                          ? SizedBox(
                                              height: 10.h,
                                            )
                                          : Container(),
                                      _imageHasError
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                right: 12.0,
                                              ),
                                              child: Text(
                                                'من فضلك اختر صورة المنتج',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.red[800],
                                                  fontSize: 12.0.sp,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 12.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.0.r,
                                            ),
                                            border: Border.all(
                                              width: 1.0,
                                              color: Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/weevo_dimension.png',
                                                      width: 20.w,
                                                      height: 20.h,
                                                    ),
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    Text(
                                                      'حجم المنتج',
                                                      style: TextStyle(
                                                        fontSize: 14.0.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'الطول',
                                                      style: TextStyle(
                                                        fontSize: 12.0.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    Text(
                                                      'X',
                                                      style: TextStyle(
                                                        fontSize: 10.0.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    Text(
                                                      'العرض',
                                                      style: TextStyle(
                                                        fontSize: 12.0.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    Text(
                                                      'X',
                                                      style: TextStyle(
                                                        fontSize: 10.0.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    Text(
                                                      'الارتفاع',
                                                      style: TextStyle(
                                                        fontSize: 12.0.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 60.0.h,
                                              width: 70.0.w,
                                              alignment: Alignment.center,
                                              child: EditText(
                                                readOnly: false,
                                                controller: _heightController,
                                                upperTitle: false,
                                                focusNode: _productHeightNode,
                                                isFocus: _productHeightFocused,
                                                radius: 12.0.r,
                                                align: TextAlign.center,
                                                action: TextInputAction.done,
                                                isPhoneNumber: false,
                                                onFieldSubmit: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _productWidthNode);
                                                },
                                                shouldDisappear:
                                                    !_productHeightIsEmpty &&
                                                        !_productHeightFocused,
                                                onSave: (String? value) {
                                                  productHeight = value;
                                                },
                                                onChange: (String? value) {
                                                  setState(() {
                                                    _productHeightIsEmpty =
                                                        value!.isEmpty;
                                                  });
                                                },
                                                type: TextInputType.number,
                                                validator: (String? value) {
                                                  value!.isEmpty
                                                      ? _sizeHasError = true
                                                      : _sizeHasError = false;
                                                  return null;
                                                },
                                                labelText: '',
                                                isPassword: false,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6.w,
                                            ),
                                            const Text('X'),
                                            SizedBox(
                                              width: 6.w,
                                            ),
                                            SizedBox(
                                              height: 60.0.h,
                                              width: 70.0.w,
                                              child: EditText(
                                                readOnly: false,
                                                controller: _widthController,
                                                upperTitle: false,
                                                focusNode: _productWidthNode,
                                                isFocus: _productWidthFocused,
                                                radius: 12.0.r,
                                                align: TextAlign.center,
                                                onFieldSubmit: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _productLengthNode);
                                                },
                                                action: TextInputAction.done,
                                                isPhoneNumber: false,
                                                shouldDisappear:
                                                    !_productWidthFocused &&
                                                        !_productWidthIsEmpty,
                                                onSave: (String? value) {
                                                  productWidth = value;
                                                },
                                                onChange: (String? value) {
                                                  setState(() {
                                                    _productWidthIsEmpty =
                                                        value!.isEmpty;
                                                  });
                                                  if (value!.isEmpty) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            _productHeightNode);
                                                  }
                                                },
                                                type: TextInputType.number,
                                                validator: (String? value) {
                                                  value!.isEmpty
                                                      ? _sizeHasError = true
                                                      : _sizeHasError = false;
                                                  return null;
                                                },
                                                labelText: '',
                                                isPassword: false,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6.w,
                                            ),
                                            const Text('X'),
                                            SizedBox(
                                              width: 6.w,
                                            ),
                                            SizedBox(
                                              height: 60.0.h,
                                              width: 70.0.w,
                                              child: EditText(
                                                readOnly: false,
                                                controller: _lengthController,
                                                upperTitle: false,
                                                align: TextAlign.center,
                                                focusNode: _productLengthNode,
                                                action: TextInputAction.done,
                                                isFocus: _productLengthFocused,
                                                onFieldSubmit: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _productWeightNode);
                                                },
                                                radius: 12.0.r,
                                                isPhoneNumber: false,
                                                shouldDisappear:
                                                    !_productLengthFocused &&
                                                        !_productLengthIsEmpty,
                                                onSave: (String? value) {
                                                  productLength = value;
                                                },
                                                onChange: (String? value) {
                                                  setState(() {
                                                    _productLengthIsEmpty =
                                                        value!.isEmpty;
                                                  });
                                                  if (value!.isEmpty) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            _productWidthNode);
                                                  }
                                                },
                                                type: TextInputType.number,
                                                validator: (String? value) {
                                                  value!.isEmpty
                                                      ? _sizeHasError = true
                                                      : _sizeHasError = false;
                                                  return null;
                                                },
                                                labelText: '',
                                                isPassword: false,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    _sizeHasError
                                        ? SizedBox(
                                            height: size.height * 0.01,
                                          )
                                        : Container(),
                                    _sizeHasError
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              right: 12.0,
                                            ),
                                            child: Text(
                                              'من فضلك ادخل الحجم بطريقة صحيحة',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.red[800],
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 12.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.0.r,
                                            ),
                                            border: Border.all(
                                              width: 1.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/weevo_weight.png',
                                                width: 25.w,
                                                height: 25.h,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                'وزن المنتج',
                                                style: TextStyle(
                                                  fontSize: 15.0.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Expanded(
                                          child: EditText(
                                            readOnly: false,
                                            controller: _weightController,
                                            upperTitle: false,
                                            align: TextAlign.left,
                                            focusNode: _productWeightNode,
                                            action: TextInputAction.done,
                                            onFieldSubmit: (_) {
                                              _productLengthNode.unfocus();
                                            },
                                            isFocus: _productWeightFocused,
                                            radius: 12.0.r,
                                            isPhoneNumber: false,
                                            shouldDisappear:
                                                !_productWeightFocused &&
                                                    !_productWeightIsEmpty,
                                            onSave: (String? value) {
                                              productWeight = value;
                                            },
                                            onChange: (value) {
                                              setState(() {
                                                _productWeightIsEmpty =
                                                    value!.isEmpty;
                                              });
                                            },
                                            type: TextInputType.number,
                                            validator: (String? value) {
                                              value!.isEmpty
                                                  ? _weightHasError = true
                                                  : _weightHasError = false;
                                              return null;
                                            },
                                            labelText: '',
                                            suffix: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 8.0,
                                                  ),
                                                  child: Text(
                                                    'كيلو جرام',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            isPassword: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _weightHasError
                                        ? SizedBox(
                                            height: 10.h,
                                          )
                                        : Container(),
                                    _weightHasError
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              right: 12.0,
                                            ),
                                            child: Text(
                                              'من فضلك ادخل الوزن',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.red[800],
                                                fontSize: 12.0.r,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: productProvider.imageLoading
                                          ? null
                                          : () async {
                                              isButtonPressed = true;
                                              if (_formState.currentState!
                                                  .validate()) {
                                                _productProvider
                                                    .setProductLoading(true);
                                                setState(() {
                                                  _imageHasError = false;
                                                });
                                                _formState.currentState!.save();
                                                if (widget.isUpdated) {
                                                  await productProvider
                                                      .updateProduct(
                                                    Product(
                                                      id: widget.product!.id,
                                                      name: productName,
                                                      categoryId:
                                                          productCategory,
                                                      description:
                                                          productDescription,
                                                      height: productHeight,
                                                      width: productWidth,
                                                      weight: productWeight,
                                                      length: productLength,
                                                      image: _img != null
                                                          ? '${_img!.path}'
                                                          : productImage,
                                                      merchantId: int.parse(
                                                          _authProvider.id!),
                                                      price: double.parse(
                                                          productPrice!),
                                                    ),
                                                  );
                                                } else {
                                                  await productProvider
                                                      .addProduct(
                                                    Product(
                                                      name: productName,
                                                      categoryId:
                                                          productCategory,
                                                      height: productHeight,
                                                      description:
                                                          productDescription,
                                                      width: productWidth,
                                                      weight: productWeight,
                                                      length: productLength,
                                                      merchantId: int.parse(
                                                          _authProvider.id!),
                                                      image: _img != null
                                                          ? '${_img!.path}'
                                                          : productImage,
                                                      price: double.parse(
                                                          productPrice!),
                                                    ),
                                                  );
                                                }
                                                if (productProvider.state ==
                                                    NetworkState.SUCCESS) {
                                                  await productProvider
                                                      .getProducts(false);
                                                  await productProvider
                                                      .getLast5Products();
                                                  productProvider
                                                      .setProductLoading(false);
                                                  if (widget.isUpdated &&
                                                      widget.from ==
                                                          from_item_details) {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      navigator.currentContext!,
                                                      ProductDetails.id,
                                                      arguments: productProvider
                                                          .productById!.id,
                                                    );
                                                  } else {
                                                    MagicRouter.pop();
                                                  }
                                                } else if (productProvider
                                                        .state ==
                                                    NetworkState.ERROR) {
                                                  productProvider
                                                      .setProductLoading(false);
                                                  showDialog(
                                                    context: navigator
                                                        .currentContext!,
                                                    builder: (BuildContext
                                                            context) =>
                                                        ActionDialog(
                                                      content:
                                                          'تأكد من الاتصال بشبكة الانترنت',
                                                      cancelAction: 'حسناً',
                                                      onCancelClick: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  );
                                                }
                                              } else {
                                                setState(() {
                                                  _imageHasError = true;
                                                });
                                              }
                                            },
                                      child: Container(
                                        width: 120.0.w,
                                        height: 50.0.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0.r),
                                          color: productProvider.imageLoading
                                              ? Colors.grey
                                              : weevoPrimaryOrangeColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: weevoPrimaryOrangeColor
                                                  .withOpacity(0.22),
                                              offset: const Offset(0, 5.0),
                                              blurRadius: 12.0,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.isUpdated
                                                  ? 'تعديل المنتج'
                                                  : 'إضافة المنتج',
                                              style: TextStyle(
                                                fontSize: 18.0.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void nextFocus(String value, FocusNode node) {
    if (value.length == 1) {
      node.requestFocus();
    }
  }

  void perviousFocus(String value, FocusNode node) {
    if (value.isEmpty) {
      node.requestFocus();
    }
  }
}
