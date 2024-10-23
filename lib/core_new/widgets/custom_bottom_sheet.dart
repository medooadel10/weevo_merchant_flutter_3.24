import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/features/Widgets/weevo_button.dart';

import 'custom_image.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<BottomSheetItem>? items;
  final List<Widget>? children;
  final bool hasHeight;
  final bool hasButton;
  final void Function()? onTap;
  final String title;
  const CustomBottomSheet({
    super.key,
    this.items,
    this.children,
    this.hasHeight = false,
    this.hasButton = false,
    this.onTap,
    this.title = '',
  });

  static void show(
    BuildContext context, {
    List<BottomSheetItem>? items,
    String? title,
    List<Widget>? children,
    bool hasHeight = false,
    bool hasButton = false,
    void Function()? onTap,
    String buttonText = '',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
        reverseCurve: Curves.easeInOut,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
      ),
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          SizedBox(
            height: hasHeight ? context.height * 0.7 : null,
            child: CustomBottomSheet(
              items: items,
              hasHeight: hasHeight,
              hasButton: hasButton,
              onTap: onTap,
              title: buttonText,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasHeight)
          Expanded(
            child: _buildListView(),
          )
        else
          _buildListView(),
        if (hasButton) ...[
          WeevoButton(
            onTap: () {
              context.pop();
              if (onTap != null) onTap!();
            },
            color: weevoPrimaryOrangeColor,
            isStable: true,
            title: title,
            isExpand: true,
          ).paddingSymmetric(
            vertical: 20.0.h,
            horizontal: 20.0.w,
          ),
        ],
      ],
    );
  }

  Widget _buildListView() => Container(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          shrinkWrap: !hasHeight,
          itemCount: items?.length ?? children?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            if (children != null) {
              return children![index];
            }
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
                items![index].onTap();
              },
              child: ListTile(
                leading: items![index].icon != null
                    ? Icon(items![index].icon)
                    : CustomImage(
                        imageUrl: items![index].imageUrl,
                        height: 24,
                        width: 24,
                        isCircle: true,
                        fit: BoxFit.cover,
                        radius: 20,
                      ),
                title: Text(items![index].title),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[400],
          ),
        ),
      );
}

class BottomSheetItem {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final String? imageUrl;

  BottomSheetItem({
    required this.title,
    this.icon,
    required this.onTap,
    this.imageUrl,
  });
}
