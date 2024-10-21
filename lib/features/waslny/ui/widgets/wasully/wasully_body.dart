import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core_new/helpers/spacing.dart';
import 'wasully_form.dart';
import 'wasully_submit_bloc_consumer.dart';

class WasullyBody extends StatelessWidget {
  const WasullyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Column(
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: WasullyForm(),
            ),
          ),
          verticalSpace(14.0),
          const WasullySubmitBlocConsumer(),
        ],
      ).paddingOnly(
        left: 20.0.w,
        right: 20.0.w,
        bottom: 20.0.h,
      ),
    );
  }
}
