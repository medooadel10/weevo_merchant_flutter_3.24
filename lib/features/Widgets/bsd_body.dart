import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Models/plus_plan.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/weevo_plus_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Screens/weevo_payment.dart';
import 'plus_item.dart';
import 'weevo_button.dart';

class BottomSheetBody extends StatefulWidget {
  const BottomSheetBody({super.key});

  @override
  State<BottomSheetBody> createState() => _BottomSheetBodyState();
}

class _BottomSheetBodyState extends State<BottomSheetBody> {
  int? _selected;
  PlusPlan? _selectedPlan;
  late WeevoPlusProvider _weevoPlusProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _weevoPlusProvider = Provider.of<WeevoPlusProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _weevoPlusProvider.getWeevoPlans();
    check(auth: _authProvider, state: _weevoPlusProvider.state!, ctx: context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WeevoPlusProvider>(
        builder: (ctx, data, ch) => data.state == NetworkState.WAITING
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اختر خطة الاشتراك',
                    style: TextStyle(
                      color: weevoBlack,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.plusPlans?.length,
                      itemBuilder: (context, i) => PlusItem(
                        itemIndex: i,
                        plusPlan: data.plusPlans![i],
                        selectedItem: _selected!,
                        onPressed: () {
                          setState(() {
                            _selected = i;
                          });
                          _selectedPlan = data.plusPlans![_selected!];
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: WeevoButton(
                      onTap: () {
                        MagicRouter.pop();
                        Navigator.pushNamed(context, WeevoPlusPayment.id,
                            arguments: _selectedPlan);
                      },
                      title: 'التأكيد',
                      color: weevoPrimaryOrangeColor,
                      isStable: true,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
