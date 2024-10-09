import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';
import '../Utilits/constants.dart';

class GenderBottomSheet extends StatelessWidget {
  final Function onItemClick;
  final int selectedItem;

  const GenderBottomSheet({
    super.key,
    required this.onItemClick,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: userType
            .map(
              (item) => InkWell(
                onTap: () => onItemClick(
                  item,
                  userType.indexOf(item),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    selectedItem == userType.indexOf(item)
                        ? const Icon(
                            Icons.done,
                            color: weevoPrimaryOrangeColor,
                          )
                        : const SizedBox(
                            height: 24.0,
                            width: 24.0,
                          ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ]),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
