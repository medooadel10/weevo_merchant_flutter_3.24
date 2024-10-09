import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Models/product_model.dart';
import '../../core/Utilits/colors.dart';
import '../../core_new/widgets/custom_image.dart';

class ExpandedProductItem extends StatelessWidget {
  final Product product;

  const ExpandedProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(
        4.0,
      ),
      elevation: 2.0,
      shadowColor: weevoGreyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          8.0,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'الكمية: ${product.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                product.description ?? '',
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'جنيه',
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${product.price}',
                                style: const TextStyle(
                                  fontSize: 17.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Image.asset('assets/images/e.png'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'كيلو جرام',
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                double.parse(product.weight ?? '0.0')
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 17.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Image.asset('assets/images/ee.png'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
              child: CustomImage(
                imageUrl: product.image,
                width: 80.w,
                height: 80.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
