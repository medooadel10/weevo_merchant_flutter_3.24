import 'package:flutter/material.dart';

import '../../core/Models/shipment_model.dart';
import '../../core/Utilits/colors.dart';

class ShipmentItem extends StatelessWidget {
  final VoidCallback onItemClick;
  final ShipmentModel shipment;

  const ShipmentItem({
    super.key,
    required this.onItemClick,
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onItemClick,
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 10.0,
        ),
        elevation: 2.0,
        shadowColor: weevoGreyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(
            8.0,
          ),
          height: size.height * 0.14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.arrow_forward_ios,
                color: weevoPrimaryOrangeColor,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'ملابس وفاشون',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: size.width * .03,
                          ),
                          Container(
                            width: size.width * 0.05,
                            height: size.width * 0.05,
                            padding: EdgeInsets.all(
                              size.width * 0.013,
                            ),
                            decoration: BoxDecoration(
                              color: weevoPrimaryOrangeColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Image.asset(
                              'assets/images/smallshirt.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.008,
                      ),
                      Row(
                        children: [
                          const Text(
                            'ملابس وفاشون',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: size.width * .03,
                          ),
                          Container(
                            width: size.width * 0.05,
                            height: size.width * 0.05,
                            padding: EdgeInsets.all(
                              size.width * 0.013,
                            ),
                            decoration: BoxDecoration(
                              color: weevoPrimaryOrangeColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Image.asset(
                              'assets/images/smallshirt.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'جنية',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.008,
                      ),
                      Text(
                        '${shipment.shipmentFee}',
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.015,
                      ),
                      Image.asset(
                        'assets/images/ship_icon.png',
                        height: size.height * .022,
                        // width: size.height * .03,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'طلب رقم 110017',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'product length: ${shipment.products.length}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'جنية',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.008,
                      ),
                      Text(
                        '${shipment.productTotalPrice}',
                        style: const TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.015,
                      ),
                      Image.asset(
                        'assets/images/price_icon.png',
                        height: size.height * .022,
                        // width: size.height * .03,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   final containerHeight = size.width - 8.0;
  //   return GestureDetector(
  //     onTap: onItemClick,
  //     child: Card(
  //       shadowColor: Colors.grey[300],
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(
  //           10.0,
  //         ),
  //       ),
  //       margin: EdgeInsets.all(8.0),
  //       child: Column(
  //         children: [
  //           Container(
  //             height: size.height * 0.185,
  //             child: ListView.builder(
  //               itemCount: shipment.products.length,
  //               scrollDirection: Axis.horizontal,
  //               itemBuilder: (context, i) => Card(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(10.0),
  //                     topRight: Radius.circular(10.0),
  //                   ),
  //                 ),
  //                 child: Container(
  //                   width: shipment.products.length == 2
  //                       ? containerHeight / shipment.products.length
  //                       : size.width * 0.3,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       ClipRRect(
  //                         borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(10.0),
  //                           topRight: Radius.circular(10.0),
  //                         ),
  //                         child: Image.network(
  //                           shipment.products[i].imageUrl,
  //                           fit: BoxFit.fill,
  //                           height: size.height * 0.097,
  //                           width: size.width,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.all(
  //                           8.0,
  //                         ),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               shipment.products[i].name,
  //                               style: TextStyle(
  //                                   fontSize: 20, fontWeight: FontWeight.w600),
  //                             ),
  //                             SizedBox(
  //                               height: size.height * 0.01,
  //                             ),
  //                             Text(
  //                               shipment.products[i].description,
  //                               overflow: TextOverflow.ellipsis,
  //                               maxLines: 1,
  //                               style: TextStyle(fontSize: 12),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.all(
  //               8.0,
  //             ),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     Text(
  //                       '${shipment.stateName} - ${shipment.cityName}',
  //                       style: TextStyle(
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: size.width * 0.02,
  //                     ),
  //                     Image.asset(
  //                       'assets/images/icon_location.png',
  //                       fit: BoxFit.cover,
  //                       height: 30.0,
  //                       width: 30.0,
  //                     ),
  //                     SizedBox(
  //                       width: size.width * 0.03,
  //                     ),
  //                     Transform.rotate(
  //                       angle: pi,
  //                       child: Icon(
  //                         Icons.arrow_right_alt,
  //                         size: 26.0,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: size.width * 0.03,
  //                     ),
  //                     Text(
  //                       '${shipment.stateName} - ${shipment.cityName}',
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 1,
  //                       style: TextStyle(
  //                         fontSize: 16.0,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: size.width * 0.02,
  //                     ),
  //                     Image.asset(
  //                       'assets/images/icon_location.png',
  //                       fit: BoxFit.cover,
  //                       height: 30.0,
  //                       width: 30.0,
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: size.height * 0.01,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Expanded(
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         children: [
  //                           Text(
  //                             'جنية',
  //                             style: TextStyle(
  //                               fontSize: 14.0,
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             width: size.width * 0.008,
  //                           ),
  //                           Text(
  //                             '${shipment.shipmentFee}',
  //                             style: TextStyle(
  //                               fontSize: 20.0,
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             width: size.width * 0.015,
  //                           ),
  //                           Image.asset(
  //                             'assets/images/ship_icon.png',
  //                             height: size.height * .022,
  //                             fit: BoxFit.fill,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: size.width * 0.07,
  //                     ),
  //                     Expanded(
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         children: [
  //                           Text(
  //                             'جنية',
  //                             style: TextStyle(
  //                               fontSize: 14.0,
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             width: size.width * 0.008,
  //                           ),
  //                           Text(
  //                             '${shipment.productTotalPrice}',
  //                             style: TextStyle(
  //                               fontSize: 20.0,
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             width: size.width * 0.015,
  //                           ),
  //                           Image.asset(
  //                             'assets/images/price_icon.png',
  //                             height: size.height * .022,
  //                             fit: BoxFit.fill,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
