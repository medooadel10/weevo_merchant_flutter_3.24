import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Screens/merchant_warehouse.dart';
import 'home_page_view.dart';

class UserProducts extends StatefulWidget {
  final Size size;

  const UserProducts({
    super.key,
    required this.size,
  });

  @override
  State<UserProducts> createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المنتجات',
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, MerchantWarehouse.id);
                },
                child: Text(
                  'عرض المزيد',
                  style: TextStyle(
                    fontSize: 15.0.sp,
                    color: const Color(0xFF0062DD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const HomePageView(),
      ],
    );
  }
}
