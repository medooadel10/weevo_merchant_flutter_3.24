import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_new/widgets/custom_text_field.dart';
import '../../logic/cubit/products_cubit.dart';

class ProductsSearch extends StatefulWidget {
  const ProductsSearch({super.key});

  @override
  State<ProductsSearch> createState() => _ProductsSearchState();
}

class _ProductsSearchState extends State<ProductsSearch> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      context.read<ProductsCubit>().searchProductByTitle(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: searchController,
      hintText: 'ابحث بإسم او وصف المنتج',
      errorMsg: '',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      suffixIcon: Icons.search,
    );
  }
}
