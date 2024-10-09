import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/widgets/custom_image.dart';

import '../../core_new/networking/api_constants.dart';
import '../Models/category_data.dart';

class CategoryBottomSheet extends StatelessWidget {
  final Function onItemClick;
  final int selectedItem;
  final List<CategoryData> categories;

  const CategoryBottomSheet({
    super.key,
    required this.onItemClick,
    required this.selectedItem,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemBuilder: (BuildContext context, int i) => ListTile(
        leading: Container(
          height: 20.h,
          width: 20.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomImage(
              imageUrl: '${ApiConstants.baseUrl}${categories[i].image}',
              height: 20.h,
              width: 20.h,
            ),
          ),
        ),
        onTap: () => onItemClick(
          categories[i],
          categories.indexOf(categories[i]),
        ),
        title: Text(
          categories[i].name ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: selectedItem == categories.indexOf(categories[i])
            ? const Icon(
                Icons.done,
                color: Colors.black,
              )
            : const SizedBox(
                height: 24.0,
                width: 24.0,
              ),
      ),
      itemCount: categories.length,
    );
  }
}
