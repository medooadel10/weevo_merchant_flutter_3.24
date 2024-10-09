import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/display_shipment_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/merchant_feedback_item.dart';
import '../Widgets/network_error_widget.dart';

class MyReviews extends StatefulWidget {
  static const String id = 'My_Feedback';

  const MyReviews({super.key});

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  late DisplayShipmentProvider _displayShipmentProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _displayShipmentProvider.listOfMyReviews();
    check(
        ctx: context,
        state: _displayShipmentProvider.myReviewsState!,
        auth: _authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              MagicRouter.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
          ),
          title: const Text(
            'ملاحظات المستخدمين',
          ),
        ),
        body: Consumer<DisplayShipmentProvider>(
          builder: (ctx, data, ch) => data.myReviewsState ==
                  NetworkState.WAITING
              ? const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          weevoPrimaryOrangeColor)),
                )
              : data.myReviewsState == NetworkState.SUCCESS
                  ? data.myReviewsEmpty
                      ? const Center(
                          child: Text('لا توجد تقييمات'),
                        )
                      : ListView.builder(
                          itemBuilder: (BuildContext context, int i) =>
                              MerchantFeedbackItem(model: data.myReviews[i]),
                          itemCount: data.myReviews.length,
                        )
                  : NetworkErrorWidget(
                      onRetryCallback:
                          _displayShipmentProvider.listOfMyReviews),
        ),
      ),
    );
  }
}
