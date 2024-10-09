import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Screens/weevo_plus_screen.dart';

class WeevoPlusBanner extends StatelessWidget {
  const WeevoPlusBanner({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            WeevoPlus.id,
            arguments: false,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            'assets/images/weevo_new_plus.png',
            height: 100.h,
            width: size.width,
          ),
        ),
      ),
    );
  }
}
