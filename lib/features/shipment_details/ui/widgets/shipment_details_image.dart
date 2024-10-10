import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../../../../core_new/widgets/custom_image.dart';

class ShipmentDetailsImage extends StatelessWidget {
  final String image;
  const ShipmentDetailsImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ShipmentDetailsCubit>();
        return CarouselSlider.builder(
          itemCount: cubit.shipmentDetails!.products.length,
          itemBuilder: (context, index, realIndex) {
            return CustomImage(
              imageUrl: image,
              width: double.infinity,
              height: 200,
              radius: 12,
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              cubit.changeProductIndex(index);
            },
            height: double.infinity,
          ),
        );
      },
    );
  }
}
