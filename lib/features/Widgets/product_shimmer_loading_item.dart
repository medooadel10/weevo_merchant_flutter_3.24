import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductLoadingItem extends StatelessWidget {
  final Size size;

  const ProductLoadingItem({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.grey.withOpacity(
        0.3,
      ),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      margin: const EdgeInsets.only(
          left: 14.0, right: 14.0, top: 8.0, bottom: 30.0),
      child: SizedBox(
        height: size.height * 0.44,
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: size.height * 0.26,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      10.0,
                    ),
                    topRight: Radius.circular(
                      10.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[100]!,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.grey[400],
                          height: size.height * 0.034,
                          width: size.width * 0.06,
                        ),
                        SizedBox(
                          width: size.width * .05,
                        ),
                        Container(
                          width: size.width * 0.05,
                          height: size.width * 0.05,
                          padding: EdgeInsets.all(
                            size.width * 0.013,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: size.height * 0.023,
                          width: size.width * 0.6,
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Container(
                          height: size.height * 0.02,
                          width: size.width * 0.45,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: size.height * .045,
                      width: size.width * .25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[400],
                      ),
                    ),
                    Container(
                      width: size.width * .24,
                      height: size.height * .04,
                      color: Colors.grey[400],
                    ),
                    Container(
                      width: size.width * .24,
                      height: size.height * .04,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
