import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_merchant_upgrade/core_new/helpers/extensions.dart';

import '../../../../../core/Storage/shared_preference.dart';
import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/router/router.dart';
import '../../../../../core_new/widgets/custom_text_field.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';
import 'wasully_delivery_price.dart';
import 'wasully_map_bloc_builder.dart';
import 'wasully_photo_bloc_builder.dart';
import 'wasully_photo_picker_bottom_sheet.dart';
import 'wasully_submit_bloc_consumer.dart';
import 'wasully_tip_prices.dart';
import 'wasully_who_paid.dart';

class WasullyForm extends StatelessWidget {
  const WasullyForm({super.key});

  @override
  Widget build(BuildContext context) {
    final WasullyCubit cubit = context.read();
    return BlocBuilder<WasullyCubit, WasullyStates>(
      builder: (context, state) {
        return Form(
          key: cubit.formKey,
          child: Column(
            children: [
              CustomTextField(
                hintText: 'قولنا عاوز توصل ايه ؟ ارفع صورة للطلب ',
                controller: cubit.orderDetailsController,
                errorMsg: 'من فضلك ادخل تفاصيل الطلب',
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                suffixIcon: Icons.camera_alt,
                onSuffixIcon: () {
                  showModalBottomSheet(
                    context: navigator.currentContext!,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    builder: (_) {
                      return BlocProvider.value(
                        value: cubit,
                        child: const WasullyPhotoPickerBlocConsumer(),
                      );
                    },
                  );
                },
              ),
              verticalSpace(14.0),
              const WasullyPhotoBlocBuilder(),
              CustomTextField(
                controller: cubit.senderPhoneController,
                hintText: 'رقم المرسل',
                errorMsg: 'من فضلك ادخل رقم المرسل',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                maxLength: 11,
                prefixIcon: Icons.phone,
              ),
              verticalSpace(14.0),
              CustomTextField(
                controller: cubit.receiverPhoneController,
                hintText: 'رقم المستلم',
                errorMsg: 'من فضلك ادخل رقم المستلم',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 11,
                prefixIcon: Icons.phone,
              ),
              verticalSpace(14.0),
              const WasullyMapBlocBuilder(),
              verticalSpace(5),
              const WasullyDeliveryPrice(),
              verticalSpace(14),
              CustomTextField(
                controller: cubit.deliveryPriceContoller,
                hintText: 'اعرض سعر التوصيل المناسب لك',
                errorMsg: 'من فضلك ادخل سعر المناسب لك',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'من فضلك ادخل سعر التوصيل';
                  }
                  final number = double.parse(value);
                  if (cubit.deliveryPriceModel == null) {
                    return null;
                  }
                  if (number <
                      double.parse(cubit.deliveryPriceModel?.price ?? '0')) {
                    cubit.deliveryPriceContoller.text =
                        cubit.deliveryPriceModel!.price;
                    return 'سعر التوصيل المناسب لك ${cubit.deliveryPriceModel!.price}';
                  }
                  return null;
                },
                onSuffixIcon: () {
                  if (cubit.deliveryPriceModel != null) {
                    cubit.deliveryPriceContoller.text =
                        cubit.deliveryPriceModel!.price;
                  }
                },
                suffixIcon: Icons.monetization_on,
              ),
              verticalSpace(14.0),
              CustomTextField(
                controller: cubit.insuranceAmountController,
                hintText: 'مبلغ تأمين الطلب',
                errorMsg: 'من فضلك ادخل مبلغ تأمين',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                suffixIcon: Icons.info,
                onSuffixIcon: () {
                  showDialog(
                    context: navigator.currentContext!,
                    barrierColor: Colors.transparent,
                    builder: (c) => AlertDialog(
                      title: const Text(
                        'مبلغ تأمين الطلب',
                        style: TextStyle(
                          color: weevoPrimaryOrangeColor,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'أضف قيمة طلبك للتأمين في حالة التلف أو الفقدان',
                          ),
                          verticalSpace(10),
                          WeevoButton(
                            onTap: () => MagicRouter.pop(),
                            color: weevoPrimaryOrangeColor,
                            isStable: true,
                            title: 'موافق',
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
              ),
              verticalSpace(14.0),
              const WasullyTipPrices(),
              verticalSpace(14),
              const WasullyWhoPaid(),
              verticalSpace(14.0),
              const WasullySubmitBlocConsumer(),
            ],
          ),
        );
      },
    ).paddingOnly(
      top: 16.h,
    );
  }
}
