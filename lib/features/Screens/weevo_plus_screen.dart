import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/weevo_button.dart';
import '../Widgets/weevo_plus_offer_item.dart';

class WeevoPlus extends StatelessWidget {
  static String id = 'WeevoPlus';
  final bool isPreview;

  const WeevoPlus({super.key, required this.isPreview});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/weevo_plus_app_title.png',
            height: 80.0.h,
            width: 80.0.h,
          ),
          leading: IconButton(
            onPressed: () async {
              MagicRouter.pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: offerList.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WeevoPlusOfferItem(i),
                  ),
                ),
              ),
              isPreview
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: WeevoButton(
                        onTap: () {
                          // showModalBottomSheet(
                          //   navigator.currentContext!,
                          //   backgroundColor: Colors.white,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.only(
                          //       topLeft: Radius.circular(
                          //         20.0,
                          //       ),
                          //       topRight: Radius.circular(
                          //         20.0,
                          //       ),
                          //     ),
                          //   ),
                          //   builder: (context) => BottomSheetBody(),
                          // );
                        },
                        title: 'اختر خطة الاشتراك',
                        color: weevoWhiteGrey,
                        // weevoPrimaryOrangeColor,
                        isStable: true,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
