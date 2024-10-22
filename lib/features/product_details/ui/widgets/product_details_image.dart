import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_new/widgets/custom_image.dart';
import '../../logic/cubit/product_details_cubit.dart';

class ProductDetailsImage extends StatelessWidget {
  const ProductDetailsImage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailsCubit>();
    return CustomImage(
      imageUrl: cubit.product!.image,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
