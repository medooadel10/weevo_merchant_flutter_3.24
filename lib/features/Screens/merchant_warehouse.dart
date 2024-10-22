// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../../core/Dialogs/action_dialog.dart';
// import '../../core/Models/add_product_arg.dart';
// import '../../core/Providers/auth_provider.dart';
// import '../../core/Providers/product_provider.dart';
// import '../../core/Storage/shared_preference.dart';
// import '../../core/Utilits/colors.dart';
// import '../../core/Utilits/constants.dart';
// import '../../core/router/router.dart';
// import '../Widgets/edit_text.dart';
// import '../Widgets/product_item.dart';
// import 'add_product.dart';

// class MerchantWarehouse extends StatefulWidget {
//   static const String id = 'Merchant_Warehouse';

//   const MerchantWarehouse({super.key});

//   @override
//   State<MerchantWarehouse> createState() => _MerchantWarehouseState();
// }

// class _MerchantWarehouseState extends State<MerchantWarehouse> {
//   late TextEditingController _controller;
//   late FocusNode _searchNode;
//   bool _searchFocused = false, _searchEmpty = true;
//   late AuthProvider _authProvider;
//   late ProductProvider _productProvider;
//   @override
//   void initState() {
//     super.initState();
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _productProvider = Provider.of<ProductProvider>(context, listen: false);
//     _productProvider.getProducts(false);
//     check(
//         ctx: context,
//         auth: _authProvider,
//         state: _productProvider.productState!);
//     if (_productProvider.categories.isEmpty) {
//       _productProvider.getAllCategories();
//     }
//     _controller = TextEditingController();
//     _searchNode = FocusNode();
//     _controller.addListener(() {
//       setState(() {
//         _searchEmpty = _controller.text.isEmpty;
//       });
//     });
//     _searchNode.addListener(() {
//       setState(() {
//         _searchFocused = _searchNode.hasFocus;
//       });
//     });
//     _searchEmpty = _controller.text.isEmpty;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ProductProvider productProvider =
//         Provider.of<ProductProvider>(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//         floatingActionButton:
//             productProvider.productState == NetworkState.WAITING ||
//                     productProvider.refreshing
//                 ? Container()
//                 : FloatingActionButton(
//                     onPressed: () {
//                       Navigator.pushNamed(
//                         context,
//                         AddProduct.id,
//                         arguments: AddProductArg(
//                           isUpdated: false,
//                           isDuplicate: false,
//                           from: from_warehouse,
//                         ),
//                       );
//                     },
//                     backgroundColor: weevoPrimaryBlueColor,
//                     child: const Icon(
//                       Icons.add,
//                     ),
//                   ),
//         body: SafeArea(
//           child: Column(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 20.0,
//                     horizontal: 12.0,
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               MagicRouter.pop();
//                             },
//                             child: const Center(
//                               child: Icon(
//                                 Icons.arrow_back_ios_outlined,
//                                 color: Colors.black,
//                                 size: 24.0,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 6.0,
//                           ),
//                           Text(
//                             'المنتجات',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 20.0.sp,
//                             ),
//                             textAlign: TextAlign.center,
//                             strutStyle: const StrutStyle(
//                               forceStrutHeight: true,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 6.0,
//                           ),
//                           Expanded(
//                             child: EditText(
//                               fillColor: Colors.grey[100],
//                               upperTitle: false,
//                               focusNode: _searchNode,
//                               filled: false,
//                               controller: _controller,
//                               action: TextInputAction.search,
//                               type: TextInputType.text,
//                               align: TextAlign.end,
//                               isPassword: false,
//                               suffix: const Icon(
//                                 Icons.search,
//                                 color: Colors.grey,
//                               ),
//                               isPhoneNumber: false,
//                               hintText: 'اسم المنتج',
//                               hintColor: Colors.grey,
//                               onSave: (_) {},
//                               onChange: (String? v) {
//                                 if (v!.length >= 2) {
//                                   productProvider.filterProducts(v.trim());
//                                 }
//                               },
//                               readOnly: false,
//                               shouldDisappear: !_searchEmpty && !_searchFocused,
//                               isFocus: _searchFocused,
//                               validator: (_) {
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: productProvider.productState == NetworkState.WAITING ||
//                         productProvider.catState == NetworkState.WAITING
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                               weevoPrimaryOrangeColor),
//                         ),
//                       )
//                     : _searchFocused && _controller.text.length >= 2
//                         ? GridView.builder(
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               childAspectRatio: 0.62,
//                             ),
//                             itemBuilder: (BuildContext ctx, int i) =>
//                                 ProductItem(
//                               product: productProvider.productsSearch[i],
//                               isEditable: true,
//                               onMorePressed: () {
//                                 showModalBottomSheet(
//                                   context: navigator.currentContext!,
//                                   shape: const RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(
//                                         20.0,
//                                       ),
//                                       topRight: Radius.circular(
//                                         20.0,
//                                       ),
//                                     ),
//                                   ),
//                                   builder: (context) => Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16.0,
//                                       vertical: 20.0,
//                                     ),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Card(
//                                           color: const Color(0xFFFBFBFB),
//                                           elevation: 0.2,
//                                           shadowColor: Colors.grey[100],
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12.0,
//                                             ),
//                                           ),
//                                           margin: const EdgeInsets.symmetric(
//                                             vertical: 6.0,
//                                           ),
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               MagicRouter.pop();
//                                               Navigator.pushNamed(
//                                                 context,
//                                                 AddProduct.id,
//                                                 arguments: AddProductArg(
//                                                   isUpdated: true,
//                                                   isDuplicate: false,
//                                                   product: productProvider
//                                                       .productsSearch[i],
//                                                   from: from_warehouse,
//                                                 ),
//                                               );
//                                             },
//                                             child: const Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: 16.0,
//                                                 vertical: 12.0,
//                                               ),
//                                               child: Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.edit,
//                                                     color: Colors.black,
//                                                   ),
//                                                   Expanded(
//                                                     child: Text(
//                                                       'تعديل المنتج',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Card(
//                                           color: const Color(
//                                             0xFFFBFBFB,
//                                           ),
//                                           elevation: 0.2,
//                                           shadowColor: Colors.grey[100],
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12.0,
//                                             ),
//                                           ),
//                                           margin: const EdgeInsets.symmetric(
//                                             vertical: 6.0,
//                                           ),
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               MagicRouter.pop();
//                                               showDialog(
//                                                 context:
//                                                     navigator.currentContext!,
//                                                 builder: (context) =>
//                                                     ActionDialog(
//                                                   title: 'حذف المنتج',
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                       20.0,
//                                                     ),
//                                                   ),
//                                                   content:
//                                                       'هل تود حذف هذا المنتج',
//                                                   approveAction: 'نعم',
//                                                   onApproveClick: () {
//                                                     productProvider
//                                                         .removeProduct(
//                                                       productProvider
//                                                           .productsSearch[i]
//                                                           .id!,
//                                                     );
//                                                     MagicRouter.pop();
//                                                   },
//                                                   cancelAction: 'لا',
//                                                   onCancelClick: () {
//                                                     MagicRouter.pop();
//                                                   },
//                                                 ),
//                                               );
//                                             },
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                 horizontal: 16.0,
//                                                 vertical: 12.0,
//                                               ),
//                                               child: Row(
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/delete.png',
//                                                     width: 27.0,
//                                                     height: 27.0,
//                                                   ),
//                                                   const Expanded(
//                                                     child: Text(
//                                                       'حذف المنتج',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Card(
//                                           color: const Color(
//                                             0xFFFBFBFB,
//                                           ),
//                                           elevation: 0.2,
//                                           shadowColor: Colors.grey[100],
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12.0,
//                                             ),
//                                           ),
//                                           margin: const EdgeInsets.symmetric(
//                                             vertical: 6.0,
//                                           ),
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               MagicRouter.pop();
//                                               Navigator.pushNamed(
//                                                 context,
//                                                 AddProduct.id,
//                                                 arguments: AddProductArg(
//                                                   isUpdated: false,
//                                                   isDuplicate: true,
//                                                   product: productProvider
//                                                       .productsSearch[i],
//                                                   from: from_warehouse,
//                                                 ),
//                                               );
//                                             },
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                 horizontal: 16.0,
//                                                 vertical: 12.0,
//                                               ),
//                                               child: Row(
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/duplicate.png',
//                                                     width: 27.0,
//                                                     height: 27.0,
//                                                   ),
//                                                   const Expanded(
//                                                     child: Text(
//                                                       'نسخ المنتج',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16.0,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                             itemCount: productProvider.productsSearch.length,
//                           )
//                         : productProvider.productIsEmpty
//                             ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     const Icon(
//                                       Icons.shopping_bag_outlined,
//                                       size: 40.0,
//                                     ),
//                                     SizedBox(
//                                       height: 10.0.h,
//                                     ),
//                                     const Text(
//                                       'لا يوجد لديك منتجات',
//                                       style: TextStyle(
//                                         fontSize: 18.0,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : RefreshIndicator(
//                                 onRefresh: () =>
//                                     productProvider.clearProductList(),
//                                 child: GridView.builder(
//                                   gridDelegate:
//                                       const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     childAspectRatio: 0.58,
//                                   ),
//                                   itemBuilder: (BuildContext ctx, int i) =>
//                                       ProductItem(
//                                     product: productProvider.products[i],
//                                     isEditable: true,
//                                     onMorePressed: () {
//                                       showModalBottomSheet(
//                                         context: navigator.currentContext!,
//                                         shape: const RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(
//                                               20.0,
//                                             ),
//                                             topRight: Radius.circular(
//                                               20.0,
//                                             ),
//                                           ),
//                                         ),
//                                         builder: (context) => Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 16.0,
//                                             vertical: 20.0,
//                                           ),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Card(
//                                                 color: const Color(0xFFFBFBFB),
//                                                 elevation: 0.2,
//                                                 shadowColor: Colors.grey[100],
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     12.0,
//                                                   ),
//                                                 ),
//                                                 margin:
//                                                     const EdgeInsets.symmetric(
//                                                   vertical: 6.0,
//                                                 ),
//                                                 child: GestureDetector(
//                                                   onTap: () {
//                                                     MagicRouter.pop();
//                                                     Navigator.pushNamed(
//                                                       context,
//                                                       AddProduct.id,
//                                                       arguments: AddProductArg(
//                                                         isUpdated: true,
//                                                         isDuplicate: false,
//                                                         product: productProvider
//                                                             .products[i],
//                                                         from: from_warehouse,
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: const Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                       horizontal: 16.0,
//                                                       vertical: 12.0,
//                                                     ),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.edit,
//                                                           color: Colors.black,
//                                                         ),
//                                                         Expanded(
//                                                           child: Text(
//                                                             'تعديل المنتج',
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 16.0,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Card(
//                                                 color: const Color(
//                                                   0xFFFBFBFB,
//                                                 ),
//                                                 elevation: 0.2,
//                                                 shadowColor: Colors.grey[100],
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     12.0,
//                                                   ),
//                                                 ),
//                                                 margin:
//                                                     const EdgeInsets.symmetric(
//                                                   vertical: 6.0,
//                                                 ),
//                                                 child: GestureDetector(
//                                                   onTap: () {
//                                                     MagicRouter.pop();
//                                                     showDialog(
//                                                       context: navigator
//                                                           .currentContext!,
//                                                       builder: (context) =>
//                                                           ActionDialog(
//                                                         title: 'حذف المنتج',
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                             20.0,
//                                                           ),
//                                                         ),
//                                                         content:
//                                                             'هل تود حذف هذا المنتج',
//                                                         approveAction: 'نعم',
//                                                         onApproveClick: () {
//                                                           productProvider
//                                                               .removeProduct(
//                                                             productProvider
//                                                                 .products[i]
//                                                                 .id!,
//                                                           );
//                                                           Navigator.pop(
//                                                               context);
//                                                           if (productProvider
//                                                                   .removeProductState ==
//                                                               NetworkState
//                                                                   .LOGOUT) {
//                                                             check(
//                                                                 ctx: context,
//                                                                 auth:
//                                                                     _authProvider,
//                                                                 state: productProvider
//                                                                     .removeProductState!);
//                                                           }
//                                                         },
//                                                         cancelAction: 'لا',
//                                                         onCancelClick: () {
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                       horizontal: 16.0,
//                                                       vertical: 12.0,
//                                                     ),
//                                                     child: Row(
//                                                       children: [
//                                                         Image.asset(
//                                                           'assets/images/delete.png',
//                                                           width: 27.0,
//                                                           height: 27.0,
//                                                         ),
//                                                         const Expanded(
//                                                           child: Text(
//                                                             'حذف المنتج',
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 16.0,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Card(
//                                                 color: const Color(
//                                                   0xFFFBFBFB,
//                                                 ),
//                                                 elevation: 0.2,
//                                                 shadowColor: Colors.grey[100],
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                     12.0,
//                                                   ),
//                                                 ),
//                                                 margin:
//                                                     const EdgeInsets.symmetric(
//                                                   vertical: 6.0,
//                                                 ),
//                                                 child: GestureDetector(
//                                                   onTap: () {
//                                                     MagicRouter.pop();
//                                                     Navigator.pushNamed(
//                                                       context,
//                                                       AddProduct.id,
//                                                       arguments: AddProductArg(
//                                                         isUpdated: false,
//                                                         isDuplicate: true,
//                                                         product: productProvider
//                                                             .products[i],
//                                                         from: from_warehouse,
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                       horizontal: 16.0,
//                                                       vertical: 12.0,
//                                                     ),
//                                                     child: Row(
//                                                       children: [
//                                                         Image.asset(
//                                                           'assets/images/duplicate.png',
//                                                           width: 27.0,
//                                                           height: 27.0,
//                                                         ),
//                                                         const Expanded(
//                                                           child: Text(
//                                                             'نسخ المنتج',
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 16.0,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   itemCount: productProvider.products.length,
//                                 ),
//                               ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
