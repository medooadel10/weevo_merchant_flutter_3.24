import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/core/Utilits/colors.dart';

class ProductMoreIcon extends StatelessWidget {
  const ProductMoreIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFD8F3FF),
        ),
        child: const Icon(
          Icons.more_horiz,
          color: weevoPrimaryBlueColor,
        ),
      ),
    );
  }
}
