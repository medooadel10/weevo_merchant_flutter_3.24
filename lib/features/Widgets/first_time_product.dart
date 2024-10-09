import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Models/add_product_arg.dart';
import '../../core/Utilits/colors.dart';
import '../Screens/add_product.dart';
import 'headline_text.dart';

class FirstTimeProduct extends StatelessWidget {
  const FirstTimeProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HeadLineText(
            title: 'المنتجات',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Text(
            'عشان متحتاجش تكتب معلومات المنتج عند كل شحنة ضيف منتجاتك دلوقتي واشحن اسرع',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AddProduct.id,
              arguments: AddProductArg(
                isUpdated: false,
                isDuplicate: false,
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.07,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  border: Border.all(
                    width: 2.0,
                    color: weevoPrimaryBlueColor,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: weevoPrimaryBlueColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 8.0.w,
                    ),
                    const Text(
                      'أضافة منتج جديد',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: weevoPrimaryBlueColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
