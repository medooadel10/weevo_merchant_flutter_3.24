import 'package:flutter/material.dart';

class WasullyMapMark extends StatelessWidget {
  const WasullyMapMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 50.0,
      ),
      child: Image.asset(
        'assets/images/marker.png',
        height: 50.0,
        width: 50.0,
      ),
    );
  }
}
