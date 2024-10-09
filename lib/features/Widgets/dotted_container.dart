import 'package:flutter/material.dart';

class DottedContainer extends StatelessWidget {
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 200,
      ),
      margin: EdgeInsets.only(
        right: 1,
        left: 1,
        bottom: 20.0,
      ),
      height: size.height * 0.004,
      width: size.height * 0.004,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
    );
  }

  DottedContainer({
    required this.color,
  });
}
