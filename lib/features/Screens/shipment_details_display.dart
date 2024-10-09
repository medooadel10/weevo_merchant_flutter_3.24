import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/display_shipment_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/network_error_widget.dart';
import 'home.dart';
import 'shipment_details_with_more_than_one_product.dart';
import 'shipment_details_with_one_product.dart';

class ShipmentDetailsDisplay extends StatefulWidget {
  static const String id = 'BeforeConfirmation';
  final int shipmentId;

  const ShipmentDetailsDisplay({
    super.key,
    required this.shipmentId,
  });

  @override
  State<ShipmentDetailsDisplay> createState() => _ShipmentDetailsDisplayState();
}

class _ShipmentDetailsDisplayState extends State<ShipmentDetailsDisplay> {
  late DisplayShipmentProvider _displayShipmentProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getShipmentById();
    initializeDateFormatting('ar_EG');
  }

  void getShipmentById() async {
    await _displayShipmentProvider.getShipmentById(
      id: widget.shipmentId,
      isFirstTime: true,
    );
    check(
        ctx: navigator.currentContext!,
        auth: _authProvider,
        state: _displayShipmentProvider.shipmentByIdState!);
  }

  @override
  Widget build(BuildContext context) {
    final displayShipmentProvider =
        Provider.of<DisplayShipmentProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (_displayShipmentProvider.fromNewShipment &&
            _displayShipmentProvider.shipmentById!.parentId == 0) {
          MagicRouter.pop();
        } else if (_displayShipmentProvider.shipmentById!.parentId == 0) {
          MagicRouter.pop();
        } else if (_displayShipmentProvider.acceptNewShipment &&
            !_displayShipmentProvider.fromChildrenReview) {
          _displayShipmentProvider.setAcceptNewShipment(false);
          Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
        } else if (_authProvider.fromOutsideNotification) {
          _authProvider.setFromOutsideNotification(false);
          Navigator.pushReplacementNamed(context, Home.id);
        } else {
          if (displayShipmentProvider.shipmentById!.parentId! > 0) {
            displayShipmentProvider.getBulkShipmentById(
                displayShipmentProvider.shipmentById!.parentId!);
          }
          MagicRouter.pop();
        }
        return false;
      },
      child: Scaffold(
        body: Consumer<DisplayShipmentProvider>(
          builder: (context, data, child) => data.shipmentByIdState ==
                  NetworkState.WAITING
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
                  ),
                )
              : data.shipmentByIdState == NetworkState.SUCCESS
                  ? data.shipmentById!.products!.length > 1
                      ? ShipmentDetailsWithMoreThanOneProduct(
                          shipmentId: widget.shipmentId)
                      : ShipmentDetailsWithOneProduct(
                          shipmentId: widget.shipmentId,
                        )
                  : NetworkErrorWidget(
                      onRetryCallback: () async {
                        await data.getShipmentById(
                            id: widget.shipmentId, isFirstTime: false);
                      },
                    ),
        ),
      ),
    );
  }
}
