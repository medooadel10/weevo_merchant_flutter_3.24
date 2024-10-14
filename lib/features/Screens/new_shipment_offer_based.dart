import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';
import 'package:weevo_merchant_upgrade/features/shipment_details/ui/shipment_details_screen.dart';

import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/display_shipment_provider.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/bulk_item.dart';
import '../Widgets/network_error_widget.dart';
import 'child_shipment_details.dart';
import 'home.dart';

class NewShipmentHost extends StatefulWidget {
  static const String id = 'New_Shipments_Host';

  const NewShipmentHost({
    super.key,
  });

  @override
  State<NewShipmentHost> createState() => _NewShipmentHostState();
}

class _NewShipmentHostState extends State<NewShipmentHost> {
  late DisplayShipmentProvider _shipmentProvider;
  Timer? _t;
  late ScrollController _scrollController;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _shipmentProvider =
        Provider.of<DisplayShipmentProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getShipment(true);
    _t = Timer.periodic(const Duration(seconds: 120), (timer) {
      getShipment(false);
    });
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_shipmentProvider.offerBasedNextPageLoading) {
          _shipmentProvider.offerBasedNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();

    super.dispose();
  }

  void getShipment(bool v) async {
    await _shipmentProvider.getOfferBasedShipment(
        isPagination: false, isFirstTime: v, isRefreshing: false);
    check(
        auth: _authProvider,
        state: _shipmentProvider.offerBasedState!,
        ctx: navigator.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    final DisplayShipmentProvider displayShipment =
        Provider.of(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (displayShipment.shipmentFromHome) {
          displayShipment.setShipmentFromHome(false);
          if (displayShipment.fromNewShipment) {
            displayShipment.setFromNewShipment(false);
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            Home.id,
            (route) => false,
          );
        } else {
          if (displayShipment.fromNewShipment) {
            displayShipment.setFromNewShipment(false);
          }
          MagicRouter.pop();
        }

        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<DisplayShipmentProvider>(
            builder: (context, data, child) => RefreshIndicator(
              onRefresh: () => data.clearOfferBasedShipmentList(),
              child: data.offerBasedState == NetworkState.WAITING
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          weevoPrimaryOrangeColor,
                        ),
                      ),
                    )
                  : data.offerBasedState == NetworkState.SUCCESS
                      ? data.offerBasedShipmentIsEmpty
                          ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'لا يوجد لديك طلبات جديدة',
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Image.asset(
                                    'assets/images/shipment_details_icon.png',
                                    width: 30.0,
                                    height: 30.0,
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.only(
                                    top: 10.h,
                                  ),
                                  itemBuilder: (BuildContext ctx, int i) =>
                                      BulkItem(
                                          bulkShipment:
                                              data.offerBasedShipments[i],
                                          onItemPressed: () => data
                                                  .offerBasedShipments[i]
                                                  .children!
                                                  .isNotEmpty
                                              ? Navigator.pushReplacementNamed(
                                                  context,
                                                  ChildShipmentDetails.id,
                                                  arguments: data
                                                      .offerBasedShipments[i]
                                                      .id,
                                                )
                                              : MagicRouter.navigateAndPop(
                                                  ShipmentDetailsScreen(
                                                      id: data
                                                          .offerBasedShipments[
                                                              i]
                                                          .id!))),
                                  itemCount: data.offerBasedShipments.length,
                                ),
                                data.offerBasedNextPageLoading
                                    ? Container(
                                        height: 50.0,
                                        color: Colors.white.withOpacity(0.2),
                                        child: const Center(
                                            child: SpinKitThreeBounce(
                                          color: weevoPrimaryOrangeColor,
                                          size: 30.0,
                                        )),
                                      )
                                    : Container()
                              ],
                            )
                      : NetworkErrorWidget(
                          onRetryCallback: () async {
                            await data.getOfferBasedShipment(
                                isPagination: false,
                                isFirstTime: false,
                                isRefreshing: false);
                          },
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
