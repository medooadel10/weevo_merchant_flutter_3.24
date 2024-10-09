import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/Utilits/colors.dart';
import '../../../../../core_new/helpers/spacing.dart';
import '../../../../../core_new/widgets/custom_text_field.dart';
import '../../../logic/wasully_cubit/wasully_cubit.dart';
import '../../../logic/wasully_cubit/wasully_states.dart';

class WasullyTipPrices extends StatelessWidget {
  const WasullyTipPrices({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyCubit, WasullyStates>(
      builder: (context, state) {
        final cubit = context.read<WasullyCubit>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0.w,
            vertical: 8.0.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey[400]!,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'كافئ الكابتن بإكرامية',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              verticalSpace(5),
              SizedBox(
                height: 35.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        cubit.selectTipPrice(index);
                      },
                      borderRadius: BorderRadius.circular(30.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0.w,
                          vertical: 5.0.h,
                        ),
                        decoration: BoxDecoration(
                          color: cubit.tipPriceSelected == index
                              ? weevoPrimaryOrangeColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: weevoPrimaryOrangeColor,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${cubit.tipPrices[index]} ${index != cubit.tipPrices.length - 1 ? 'ج.م' : ''}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: cubit.tipPriceSelected == index
                                  ? Colors.white
                                  : weevoPrimaryOrangeColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => horizontalSpace(6.0),
                  itemCount: cubit.tipPrices.length,
                ),
              ),
              Visibility(
                visible: cubit.tipPriceSelected == cubit.tipPrices.length - 1,
                child: Column(
                  children: [
                    verticalSpace(14),
                    CustomTextField(
                      controller: cubit.tipController,
                      hintText: 'كافئ الكابتن بإكرامية',
                      errorMsg: '',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
