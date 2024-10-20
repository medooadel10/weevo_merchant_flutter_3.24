import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/spacing.dart';
import 'package:weevo_merchant_upgrade/features/add_product/ui/widgets/add_product_submit_bloc_consumer.dart';

import 'add_product_form.dart';

class AddProductBody extends StatelessWidget {
  const AddProductBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: AddProductForm(),
            ),
          ),
          verticalSpace(10),
          const AddProductSubmitBlocConsumer(),
        ],
      ).paddingSymmetric(
        horizontal: 20.0.w,
        vertical: 10.0.h,
      ),
    );
  }
}
