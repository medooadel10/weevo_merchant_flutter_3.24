import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Dialogs/content_dialog.dart';
import '../../../../core/Dialogs/loading.dart';
import '../../../../core/Models/shipment_tracking_model.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/helpers/spacing.dart';
import '../../../../core_new/widgets/custom_image.dart';
import '../../../Screens/home.dart';
import '../../../Widgets/edit_text.dart';
import '../../../Widgets/weevo_button.dart';
import '../../logic/cubit/wasully_handle_shipment_cubit.dart';
import '../../logic/cubit/wasully_handle_shipment_state.dart';

class WasullyRatingDialog extends StatefulWidget {
  final ShipmentTrackingModel model;

  const WasullyRatingDialog({
    super.key,
    required this.model,
  });

  @override
  State<WasullyRatingDialog> createState() => _WasullyRatingDialogState();
}

class _WasullyRatingDialogState extends State<WasullyRatingDialog> {
  late TextEditingController _ratingController;
  late FocusNode _focusNode;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool _isFocus = false;
  double? _ratePoint;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _ratingController = TextEditingController();
    _focusNode.addListener(() {
      setState(() {
        _isFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WasullyHandleShipmentCubit cubit = context.read();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'تقييم الكابتن',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: weevoPrimaryOrangeColor,
          ),
          onPressed: () {
            MagicRouter.navigateAndPopAll(const Home());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 30.0,
          left: 30.0,
          top: 20.0,
          bottom: 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              verticalSpace(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CustomImage(
                      imageUrl: widget.model.courierImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                'كيف كانت طلبك مع الكابتن ${widget.model.courierName ?? ''}',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Center(
                child: RatingBar.builder(
                  itemBuilder: (BuildContext ctx, int i) => const Icon(
                    Icons.star_rounded,
                    color: weevoPrimaryOrangeColor,
                  ),
                  glowColor: weevoPrimaryOrangeColor.withOpacity(0.1),
                  onRatingUpdate: (double v) {
                    setState(() {
                      _ratePoint = v;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              _ratePoint == 1.0
                  ? const Text(
                      'سئ جداً',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    )
                  : _ratePoint == 2.0
                      ? const Text(
                          'سئ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0),
                          textAlign: TextAlign.center,
                        )
                      : _ratePoint == 3.0
                          ? const Text(
                              'جيد',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16.0),
                              textAlign: TextAlign.center,
                            )
                          : _ratePoint == 4.0
                              ? const Text(
                                  'جيد جداً',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                  textAlign: TextAlign.center,
                                )
                              : _ratePoint == 5.0
                                  ? const Text(
                                      'ممتاز',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0),
                                      textAlign: TextAlign.center,
                                    )
                                  : Container(),
              const SizedBox(
                height: 8.0,
              ),
              Form(
                key: _formState,
                child: EditText(
                  controller: _ratingController,
                  readOnly: false,
                  isFocus: _isFocus,
                  type: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 4,
                  filled: false,
                  radius: 12.0.r,
                  validator: (v) {
                    return '';
                  },
                  focusNode: _focusNode,
                  labelColor: Colors.grey,
                  labelFontSize: 15.0.sp,
                  align: TextAlign.start,
                  action: TextInputAction.done,
                  isPhoneNumber: false,
                  isPassword: false,
                  labelText: 'التقييم',
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              WeevoButton(
                onTap: () async {
                  showDialog(
                      context: navigator.currentContext!,
                      builder: (context) => BlocConsumer<
                              WasullyHandleShipmentCubit,
                              WasullyHandleShipmentState>(
                            listener: (context, state) {
                              if (state
                                  is WasullyHandleShipmentReviewCourierSuccess) {
                                MagicRouter.pop();
                                showDialog(
                                    context: navigator.currentContext!,
                                    builder: (context) => Dialog(
                                        insetPadding:
                                            const EdgeInsets.all(20.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                'assets/images/done_icon.png',
                                                color: weevoPrimaryOrangeColor,
                                                height: 150.0,
                                                width: 150.0,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              const Text(
                                                'تم ارسال التقييم',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                              Color>(
                                                          weevoPrimaryOrangeColor),
                                                  shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  MagicRouter.pop();
                                                  MagicRouter.pop();
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          Home.id,
                                                          (route) => false);
                                                },
                                                child: const Text(
                                                  'حسناً',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )));
                              }
                              if (state
                                  is WasullyHandleShipmentReviewCourierError) {
                                MagicRouter.pop();
                                showDialog(
                                    context: navigator.currentContext!,
                                    builder: (context) => ContentDialog(
                                        content: state.error,
                                        callback: () {
                                          MagicRouter.pop();
                                        }));
                              }
                            },
                            builder: (context, state) {
                              return const LoadingDialog();
                            },
                          ));
                  await cubit.reviewCourier(
                      shipmentId: widget.model.shipmentId!,
                      rating: _ratePoint!.toInt(),
                      body: _ratingController.text.isEmpty
                          ? 'لا يوجد تعليق'
                          : _ratingController.text,
                      recommend: 'Yes',
                      title: _ratePoint == 1.0
                          ? 'very bad'
                          : _ratePoint == 2.0
                              ? 'bad'
                              : _ratePoint == 3.0
                                  ? 'good'
                                  : _ratePoint == 4.0
                                      ? 'very good'
                                      : 'excellent');
                },
                title: 'ارسال التقييم',
                color: weevoPrimaryOrangeColor,
                isStable: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
