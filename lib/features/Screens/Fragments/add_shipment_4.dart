import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Storage/shared_preference.dart';

import '../../../core/Dialogs/action_dialog.dart';
import '../../../core/Providers/add_shipment_provider.dart';
import '../../../core/Providers/auth_provider.dart';
import '../../../core/Providers/choose_captain_provider.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../../../core_new/router/router.dart';
import '../../../main.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/one_shipment_display.dart';
import '../choose_courier.dart';
import '../shipment_details_display.dart';

class AddShipment4 extends StatelessWidget {
  const AddShipment4({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    final chooseCaptainProvider = Provider.of<ChooseCaptainProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return LoadingWidget(
      isLoading: shipmentProvider.state == NetworkState.WAITING ||
          chooseCaptainProvider.state == NetworkState.WAITING,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            shipmentProvider.shipmentFromWhere == oneShipment ||
                    shipmentProvider.shipmentFromWhere == giftShipment
                ? Expanded(
                    child: Column(
                      children: [
                        OneShipmentDisplay(
                          shipment: shipmentProvider.shipments[0],
                          onItemClick: () {
                            shipmentProvider.setIsUpdated(true);
                            shipmentProvider.setData(
                              model: shipmentProvider.shipments[0],
                              i: 0,
                            );
                            shipmentProvider.setIndex(0);
                          },
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: shipmentProvider.shipments.length,
                      itemBuilder: (context, i) => OneShipmentDisplay(
                        shipment: shipmentProvider.shipments[i],
                        onItemClick: () {
                          shipmentProvider.setIsUpdated(true);
                          shipmentProvider.setData(
                            model: shipmentProvider.shipments[i],
                            i: i,
                          );
                          shipmentProvider.setIndex(0);
                        },
                      ),
                    ),
                  ),
            Column(
              children: [
                Text(
                  shipmentProvider.shipmentFromWhere == moreThanOneShipment
                      ? 'ننصحك بان يكون اجمالي مقدم الشحنات ليس كبيراً\nحتي يمكنك الحصول علي كابتن بشكل سريع'
                      : 'يمكنك تعديل ومراجعة الشحنة بالضغط عليها',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                shipmentProvider.shipmentFromWhere == moreThanOneShipment
                    ? TextButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all<Size>(
                            Size(
                              size.width,
                              size.height * 0.07,
                            ),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: weevoBlueBlack,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          shipmentProvider.setShipmentMessage(addOneMore);
                          shipmentProvider.setStateName(shipmentProvider
                              .getStateNameById(int.parse(shipmentProvider
                                  .shipments[0].deliveringState!))!);
                          shipmentProvider.setRealDeliveryDateTime(
                              shipmentProvider
                                  .shipments[0].dateToDeliverShipment!);
                          shipmentProvider.receiveLocationAddressNameController
                              .clear();
                          shipmentProvider.receiveLocationLatController.clear();
                          shipmentProvider.receiveLocationLangController
                              .clear();
                          shipmentProvider.setIndex(1);
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: weevoBlueBlack,
                              size: 30.0,
                            ),
                            Expanded(
                              child: Text(
                                'أضافة شحنة جديدة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: weevoBlueBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                shipmentProvider.shipmentFromWhere == moreThanOneShipment
                    ? SizedBox(
                        height: size.height * 0.02,
                      )
                    : Container(),
                TextButton(
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all<Size>(
                      Size(
                        size.width,
                        size.height * 0.07,
                      ),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      weevoPrimaryBlueColor,
                    ),
                  ),
                  onPressed: () async {
                    shipmentProvider.receiveLocationAddressNameController
                        .clear();
                    shipmentProvider.receiveLocationLatController.clear();
                    shipmentProvider.receiveLocationLangController.clear();
                    if (shipmentProvider.isUpdateFromServer) {
                      await shipmentProvider.updateOneShipment(
                        userId: authProvider.id!,
                        shipment: shipmentProvider.shipments[0],
                      );
                      if (shipmentProvider.state == NetworkState.SUCCESS) {
                        shipmentProvider.setIndex(0);
                        shipmentProvider.shipments.clear();
                        shipmentProvider.setIsUpdatedFromServer(false);
                        Navigator.pushReplacementNamed(
                            navigator.currentContext!,
                            ShipmentDetailsDisplay.id,
                            arguments: shipmentProvider.shipmentId);
                      } else if (shipmentProvider.state ==
                          NetworkState.LOGOUT) {
                        check(
                            auth: authProvider,
                            state: shipmentProvider.state!,
                            ctx: navigator.currentContext!);
                      } else {
                        showDialog(
                          context: navigator.currentContext!,
                          builder: (BuildContext context) => ActionDialog(
                            content: 'تأكد من الاتصال بشبكة الانترنت',
                            cancelAction: 'حسناً',
                            onCancelClick: () {
                              MagicRouter.pop();
                            },
                          ),
                        );
                      }
                    } else {
                      if (shipmentProvider.shipmentFromWhere == oneShipment ||
                          shipmentProvider.shipmentFromWhere == giftShipment) {
                        await shipmentProvider.addOneShipment(
                          shipment: shipmentProvider.shipments[0],
                          userId: authProvider.id!,
                        );
                        if (shipmentProvider.state == NetworkState.SUCCESS) {
                          Weevo.facebookAppEvents.logAddToCart(
                              id: shipmentProvider
                                  .shipmentNotification!.shipmentId
                                  .toString(),
                              type: shipmentProvider.shipmentFromWhere ==
                                      oneShipment
                                  ? 'one_shipment'
                                  : 'gift_shipment',
                              currency: 'EGP',
                              price: num.parse(shipmentProvider
                                      .shipmentNotification!.totalShipmentCost!)
                                  .toDouble());
                        } else if (shipmentProvider.state ==
                            NetworkState.ERROR) {
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (BuildContext context) => ActionDialog(
                              content: 'تأكد من الاتصال بشبكة الانترنت',
                              cancelAction: 'حسناً',
                              onCancelClick: () {
                                MagicRouter.pop();
                              },
                            ),
                          );
                        } else if (shipmentProvider.state ==
                            NetworkState.LOGOUT) {
                          check(
                              auth: authProvider,
                              state: shipmentProvider.state!,
                              ctx: navigator.currentContext!);
                        }
                      } else {
                        if (shipmentProvider.shipments.length <= 1) {
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (context) => ActionDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                              ),
                              content:
                                  'لا يمكنك أرسال شحنة واحدة في مجموعة شحنات هل تود أرسال الشحنة كشحنة واحدة ؟',
                              onApproveClick: () async {
                                MagicRouter.pop();
                                await shipmentProvider.addOneShipment(
                                  shipment: shipmentProvider.shipments[0],
                                  userId: authProvider.id!,
                                );
                              },
                              onCancelClick: () {
                                MagicRouter.pop();
                              },
                              approveAction: 'نعم',
                              cancelAction: 'لا',
                            ),
                          );
                        } else {
                          await shipmentProvider.addBulkShipment(
                            uploadedShipments: shipmentProvider.shipments,
                            userId: authProvider.id!,
                          );
                          if (shipmentProvider.state == NetworkState.SUCCESS) {
                            shipmentProvider.setShipmentMessage(null);
                            Weevo.facebookAppEvents.logAddToCart(
                                id: shipmentProvider
                                    .shipmentNotification!.shipmentId
                                    .toString(),
                                type: 'bulk_shipment',
                                currency: 'EGP',
                                price: num.parse(shipmentProvider
                                        .shipmentNotification!
                                        .totalShipmentCost!)
                                    .toDouble());
                          } else if (shipmentProvider.state ==
                              NetworkState.LOGOUT) {
                            check(
                                auth: authProvider,
                                state: shipmentProvider.state!,
                                ctx: navigator.currentContext!);
                          } else {
                            showDialog(
                              context: navigator.currentContext!,
                              builder: (BuildContext context) => ActionDialog(
                                content: 'تأكد من الاتصال بشبكة الانترنت',
                                cancelAction: 'حسناً',
                                onCancelClick: () {
                                  MagicRouter.pop();
                                },
                              ),
                            );
                          }
                        }
                      }
                      if (shipmentProvider.state == NetworkState.SUCCESS) {
                        await chooseCaptainProvider.postShipmentToGetOffers(
                            shipmentId: shipmentProvider.captainShipmentId!);
                        if (chooseCaptainProvider.state ==
                            NetworkState.SUCCESS) {
                          shipmentProvider.setShipmentFromInside(false);
                          Navigator.pushReplacementNamed(
                            navigator.currentContext!,
                            ChooseCourier.id,
                            arguments: shipmentProvider.shipmentNotification,
                          );
                          shipmentProvider.setIndex(0);
                          shipmentProvider.shipments.clear();
                        } else if (chooseCaptainProvider.state ==
                            NetworkState.LOGOUT) {
                          check(
                              ctx: navigator.currentContext!,
                              auth: authProvider,
                              state: chooseCaptainProvider.state!);
                        } else {
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (context) => ActionDialog(
                              content: 'تأكد من الاتصال بشبكة الانترنت',
                              cancelAction: 'حسناً',
                              onCancelClick: () {
                                MagicRouter.pop();
                              },
                            ),
                          );
                        }
                      } else if (shipmentProvider.state ==
                          NetworkState.LOGOUT) {
                        check(
                            auth: authProvider,
                            state: shipmentProvider.state!,
                            ctx: navigator.currentContext!);
                      }
                    }
                  },
                  child: const Text(
                    'التالي',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
