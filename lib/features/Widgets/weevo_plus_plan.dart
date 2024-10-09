import 'package:flutter/material.dart';

import '../../core/Utilits/colors.dart';

class WeevoPlusPlan extends StatelessWidget {
  const WeevoPlusPlan({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * .12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21.0),
        border: Border.all(
          width: 1.5,
          color: weevoButterColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'خطة السنة',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    height: 0.87,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '12',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        height: 0.88,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'جنيه / الاسبوع',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        height: 0.87,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              alignment: const Alignment(-0.06, -0.24),
              width: 65.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: weevoButterColor,
                boxShadow: [
                  BoxShadow(
                    color: weevoPrimaryOrangeColor.withOpacity(0.1),
                    offset: const Offset(0, 0),
                    blurRadius: 12.0,
                  ),
                ],
              ),
              child: const SizedBox(
                width: 31.0,
                height: 36.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Text(
                        'جنيه',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 0.82,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Text(
                        '599',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 0.82,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
