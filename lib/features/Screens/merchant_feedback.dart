import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Models/feedback_data_arg.dart';
import '../../core/Providers/display_shipment_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/merchant_feedback_item.dart';

class MerchantFeedback extends StatefulWidget {
  static const String id = 'Merchant_Feedback';
  final FeedbackDataArg arg;

  const MerchantFeedback({
    super.key,
    required this.arg,
  });

  @override
  State<MerchantFeedback> createState() => _MerchantFeedbackState();
}

class _MerchantFeedbackState extends State<MerchantFeedback> {
  late DisplayShipmentProvider _displayShipmentProvider;

  @override
  void initState() {
    super.initState();
    _displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context, listen: false);
    _displayShipmentProvider.listOfCourierReviews(courierId: widget.arg.userId);
  }

  @override
  Widget build(BuildContext context) {
    log('${widget.arg.userId}');
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
          title: Text(
            'تقييمات ${widget.arg.username}',
          ),
        ),
        body: Consumer<DisplayShipmentProvider>(
          builder: (ctx, data, ch) => data.courierReviewState ==
                  NetworkState.WAITING
              ? const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          weevoPrimaryOrangeColor)),
                )
              : data.courierReviewsEmpty
                  ? Center(
                      child: Text('لا توجد تقييمات ل ${widget.arg.username}'),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int i) =>
                          MerchantFeedbackItem(model: data.courierReviews[i]),
                      itemCount: data.courierReviews.length,
                    ),
        ),
      ),
    );
  }
}
