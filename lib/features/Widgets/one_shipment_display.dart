import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Models/child_shipment.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Providers/product_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core_new/widgets/custom_image.dart';

class OneShipmentDisplay extends StatefulWidget {
  final ChildShipment shipment;
  final VoidCallback onItemClick;

  const OneShipmentDisplay({
    super.key,
    required this.shipment,
    required this.onItemClick,
  });

  @override
  State<OneShipmentDisplay> createState() => _OneShipmentDisplayState();
}

class _OneShipmentDisplayState extends State<OneShipmentDisplay> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddShipmentProvider addShipmentProvider =
        Provider.of<AddShipmentProvider>(context, listen: false);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return GestureDetector(
      onTap: widget.onItemClick,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        height: 175.h,
        child: PageView.builder(
          onPageChanged: (int i) {},
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemCount: widget.shipment.products!.length,
          itemBuilder: (context, i) => Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: CustomImage(
                  imageUrl: widget.shipment.products?[i].image,
                  height: 150.0.h,
                  width: 150.0.h,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.shipment.products?[0].name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.shipment.products?[0].description ??
                                      '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(
                                    6.0,
                                  ),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffFFEEE6),
                                  ),
                                  child: Image.asset(
                                    'assets/images/t_shirt_icon.png',
                                    color: weevoPrimaryOrangeColor,
                                    fit: BoxFit.contain,
                                    height: 15.0,
                                    width: 15.0,
                                  ),
                                ),
                                Text(
                                  '${productProvider.getCatById(widget.shipment.products?[0].categoryId ?? 0)!.name}',
                                  style: TextStyle(
                                    fontSize: 10.0.sp,
                                  ),
                                  strutStyle: const StrutStyle(
                                    forceStrutHeight: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: weevoPrimaryOrangeColor,
                            ),
                            height: 8.h,
                            width: 8.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Expanded(
                            child: Text(
                              '${addShipmentProvider.getStateNameById(int.parse(widget.shipment.receivingState!))} - ${addShipmentProvider.getCityNameById(int.parse(widget.shipment.receivingState!), int.parse(widget.shipment.receivingCity!))}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(
                            3,
                            (index) => Container(
                              margin: const EdgeInsets.only(top: 1),
                              height: 3,
                              width: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.5),
                                color: index < 3
                                    ? weevoPrimaryOrangeColor
                                    : weevoPrimaryBlueColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: weevoPrimaryBlueColor,
                            ),
                            height: 8.h,
                            width: 8.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Expanded(
                            child: Text(
                              '${addShipmentProvider.getStateNameById(int.parse(widget.shipment.deliveringState!))} - ${addShipmentProvider.getCityNameById(int.parse(widget.shipment.deliveringState!), int.parse(widget.shipment.deliveringCity!))}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xffD8F3FF),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/money_icon.png',
                                    fit: BoxFit.contain,
                                    color: const Color(0xff091147),
                                    height: 20.h,
                                    width: 20.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${double.parse(widget.shipment.amount ?? '0').toInt()}',
                                        style: TextStyle(
                                          fontSize: 11.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        'جنية',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/van_icon.png',
                                    fit: BoxFit.contain,
                                    color: const Color(0xff091147),
                                    height: 18.h,
                                    width: 18.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${double.parse(widget.shipment.shippingCost ?? '0').toInt()}',
                                        style: TextStyle(
                                          fontSize: 11.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        'جنية',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
