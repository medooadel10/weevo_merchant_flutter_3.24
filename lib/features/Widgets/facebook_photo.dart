import 'package:flutter/material.dart';

import '../../core/Models/shipment_product.dart';
import '../../core_new/widgets/custom_image.dart';

class CustomPhoto extends StatefulWidget {
  final List<ShipmentProduct> products;

  const CustomPhoto({
    super.key,
    required this.products,
  });

  @override
  createState() => _CustomPhotoState();
}

class _CustomPhotoState extends State<CustomPhoto> {
  final height = 170.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(height: height, child: buildImages(size));
  }

  Widget buildImages(Size size) {
    final length = widget.products.length;
    Widget imageWidget;
    if (length == 1) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: CustomImage(
          imageUrl: widget.products[0].productInfo!.image,
          width: size.width,
          height: size.height,
        ),
      );
    } else if (length == 2) {
      imageWidget = Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(20.0)),
              child: CustomImage(
                imageUrl: widget.products[0].productInfo!.image,
                width: size.width,
                height: size.height,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20.0)),
              child: CustomImage(
                imageUrl: widget.products[1].productInfo!.image,
                width: size.width,
                height: size.height,
              ),
            ),
          ),
        ],
      );
    } else if (length == 3) {
      imageWidget = Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(20.0)),
              child: CustomImage(
                imageUrl: widget.products[0].productInfo!.image,
                width: size.width,
                height: size.height,
              ),
            ),
          ),
          Expanded(
            child: CustomImage(
              imageUrl: widget.products[1].productInfo!.image,
              width: size.width,
              height: size.height,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20.0)),
              child: CustomImage(
                imageUrl: widget.products[2].productInfo!.image,
                width: size.width,
                height: size.height,
              ),
            ),
          ),
        ],
      );
    } else {
      imageWidget = Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(20.0)),
              child: CustomImage(
                imageUrl: widget.products[0].productInfo!.image,
                width: size.width,
                height: size.height,
              ),
            ),
          ),
          Expanded(
            child: CustomImage(
              imageUrl: widget.products[1].productInfo!.image,
              width: size.width,
              height: size.height,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20.0)),
              child: Stack(
                children: [
                  CustomImage(
                    imageUrl: widget.products[2].productInfo!.image,
                    width: size.width,
                    height: size.height,
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: Center(
                        child: Text(
                          '+${length - 3}',
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 32.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
    return imageWidget;
  }
}
