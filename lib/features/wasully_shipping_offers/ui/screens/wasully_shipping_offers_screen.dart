import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/Models/shipment_notification.dart';
import '../../../../core/Storage/shared_preference.dart';
import '../../../../core/Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../../../core_new/di/dependency_injection.dart';
import '../../logic/cubit/wasully_shipping_offers_cubit.dart';
import '../../logic/cubit/wasully_shipping_offers_state.dart';
import '../widgets/shipping_offer_tile.dart';

class WasullyShippingOffersScreen extends StatefulWidget {
  final int id;
  final ShipmentNotification shipmentNotification;
  const WasullyShippingOffersScreen(
      {super.key, required this.id, required this.shipmentNotification});

  @override
  State<WasullyShippingOffersScreen> createState() =>
      _WasullyShippingOffersScreenState();
}

class _WasullyShippingOffersScreenState
    extends State<WasullyShippingOffersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WasullyShippingOffersCubit(getIt())
        ..init(
          id: widget.id,
          shipmentNotification: widget.shipmentNotification,
          context: navigator.currentContext!,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'طلب ${widget.shipmentNotification.shipmentId}',
                    style: const TextStyle(
                      color: weevoPrimaryOrangeColor,
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/new_icon.png',
                    fit: BoxFit.contain,
                    height: 30.0.h,
                    width: 30.0.w,
                    color: weevoPrimaryOrangeColor,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.shipmentNotification.shippingCost ?? '0',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w600,
                          color: weevoPrimaryOrangeColor,
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'جنية',
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          color: weevoPrimaryOrangeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () => MagicRouter.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        body:
            BlocBuilder<WasullyShippingOffersCubit, WasullyShippingOffersState>(
          builder: (context, state) {
            final cubit = context.read<WasullyShippingOffersCubit>();
            if (state is WasullyShippingOffersErrorState) {
              return const Center(
                child: Text('Error'),
              );
            } else if (cubit.shippingOffers == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'برجاء الانتظار',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(
                          width: 20.0.w,
                        ),
                        const SpinKitThreeBounce(
                          color: weevoPrimaryOrangeColor,
                          size: 20.0,
                        ),
                      ],
                    ),
                    const Text(
                      'جاري البحث عن مناديب',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              );
            } else if (cubit.shippingOffers!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'برجاء الانتظار',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(
                          width: 20.0.w,
                        ),
                        const SpinKitThreeBounce(
                          color: weevoPrimaryOrangeColor,
                          size: 20.0,
                        ),
                      ],
                    ),
                    const Text(
                      'جاري البحث عن مناديب',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              controller: cubit.scrollController,
              itemCount: cubit.shippingOffers!.length,
              itemBuilder: (context, index) {
                return ShippingOfferTile(
                  courier: cubit.shippingOffers![index],
                  shipmentNotification: widget.shipmentNotification,
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
