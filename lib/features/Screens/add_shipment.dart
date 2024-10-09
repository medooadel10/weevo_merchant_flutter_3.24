import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Providers/add_shipment_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core_new/router/router.dart';
import '../Widgets/dotted_container.dart';
import '../Widgets/stepper_item.dart';

class AddShipment extends StatefulWidget {
  static String id = 'AddOneShipments';

  const AddShipment({super.key});

  @override
  State<AddShipment> createState() => _AddShipmentState();
}

class _AddShipmentState extends State<AddShipment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar_EG');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shipmentProvider = Provider.of<AddShipmentProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if (shipmentProvider.shipmentMessage == addOneMore) {
            switch (shipmentProvider.currentIndex) {
              // case 0:
              //   MagicRouter.pop();
              //   break;

              //
              //   break;
              case 1:
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => ActionDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    title: 'الخروج',
                    content: 'هل تود الغاء الشحنة',
                    onApproveClick: () {
                      MagicRouter.pop();
                      shipmentProvider.reset(false);
                      shipmentProvider.setShipmentMessage(null);
                      shipmentProvider.setIndex(3);
                    },
                    onCancelClick: () {
                      MagicRouter.pop();
                    },
                    approveAction: 'نعم',
                    cancelAction: 'لا',
                  ),
                );
                // shipmentProvider.setIndex(0);
                break;
              case 2:
                shipmentProvider.setIndex(1);
                break;
              case 3:
                shipmentProvider.setIndex(2);
                break;
            }
          } else if (shipmentProvider.isUpdated) {
            switch (shipmentProvider.currentIndex) {
              case 0:
                showDialog(
                  context: navigator.currentContext!,
                  builder: (context) => ActionDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    title: 'الخروج',
                    content: 'هل تود الغاء تعديل الشحنة',
                    onApproveClick: () {
                      MagicRouter.pop();
                      shipmentProvider.setIsUpdated(false);
                      shipmentProvider.reset(true);
                      shipmentProvider.setIndex(3);
                    },
                    onCancelClick: () {
                      MagicRouter.pop();
                    },
                    approveAction: 'نعم',
                    cancelAction: 'لا',
                  ),
                );
                break;
              case 1:
                shipmentProvider.setIndex(0);
                break;
              case 2:
                shipmentProvider.setIndex(1);
                break;
              case 3:
                shipmentProvider.setIndex(2);
                break;
            }
          } else {
            if (shipmentProvider.isUpdateFromServer) {
              switch (shipmentProvider.currentIndex) {
                case 0:
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      title: 'الخروج',
                      content: 'هل تود الغاء تعديل الشحنة',
                      onApproveClick: () {
                        MagicRouter.pop();
                        shipmentProvider.reset(false);
                        shipmentProvider.setIsUpdatedFromServer(false);
                        MagicRouter.pop();
                      },
                      onCancelClick: () {
                        MagicRouter.pop();
                      },
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                    ),
                  );
                  break;
                case 1:
                  shipmentProvider.setIndex(0);
                  break;
                case 2:
                  shipmentProvider.setIndex(1);
                  break;
                case 3:
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      title: 'الخروج',
                      content: 'هل تود الغاء تعديل الشحنة',
                      onApproveClick: () {
                        shipmentProvider.shipments.clear();
                        shipmentProvider.setIndex(0);
                        shipmentProvider.reset(false);
                        shipmentProvider.setIsUpdatedFromServer(false);
                        MagicRouter.pop();
                        MagicRouter.pop();
                      },
                      onCancelClick: () {
                        MagicRouter.pop();
                      },
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                    ),
                  );
                  break;
              }
            } else {
              switch (shipmentProvider.currentIndex) {
                case 0:
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      title: 'الخروج',
                      content: 'هل تود الغاء الشحنة',
                      onApproveClick: () {
                        MagicRouter.pop();
                        MagicRouter.pop();
                        shipmentProvider.reset(false);
                      },
                      onCancelClick: () {
                        MagicRouter.pop();
                      },
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                    ),
                  );
                  break;
                case 1:
                  shipmentProvider.setIndex(0);
                  break;
                case 2:
                  shipmentProvider.setIndex(1);
                  break;
                case 3:
                  log('message from else');
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      title: 'الخروج',
                      content: 'هل تود الغاء الشحنة',
                      onApproveClick: () {
                        shipmentProvider.shipments.clear();
                        shipmentProvider.setIndex(0);
                        MagicRouter.pop();
                        MagicRouter.pop();
                      },
                      onCancelClick: () {
                        MagicRouter.pop();
                      },
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                    ),
                  );
                  break;
              }
            }
          }
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (shipmentProvider.shipmentMessage == addOneMore) {
                  switch (shipmentProvider.currentIndex) {
                    case 0:
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (context) => ActionDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          title: 'الخروج',
                          content: 'هل تود الغاء الشحنة',
                          onApproveClick: () {
                            MagicRouter.pop();
                            shipmentProvider.reset(false);
                            shipmentProvider.setShipmentMessage(null);
                            shipmentProvider.setIndex(3);
                          },
                          onCancelClick: () {
                            MagicRouter.pop();
                          },
                          approveAction: 'نعم',
                          cancelAction: 'لا',
                        ),
                      );
                      break;
                    case 1:
                      shipmentProvider.setIndex(0);
                      break;
                    case 2:
                      shipmentProvider.setIndex(1);
                      break;
                    case 3:
                      shipmentProvider.setIndex(2);
                      break;
                  }
                } else if (shipmentProvider.isUpdated) {
                  switch (shipmentProvider.currentIndex) {
                    case 0:
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (context) => ActionDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          title: 'الخروج',
                          content: 'هل تود الغاء تعديل الشحنة',
                          onApproveClick: () {
                            MagicRouter.pop();
                            shipmentProvider.setIsUpdated(false);
                            shipmentProvider.reset(true);
                            shipmentProvider.setIndex(3);
                          },
                          onCancelClick: () {
                            MagicRouter.pop();
                          },
                          approveAction: 'نعم',
                          cancelAction: 'لا',
                        ),
                      );
                      break;
                    case 1:
                      shipmentProvider.setIndex(0);
                      break;
                    case 2:
                      shipmentProvider.setIndex(1);
                      break;
                    case 3:
                      shipmentProvider.setIndex(2);
                      break;
                  }
                } else {
                  switch (shipmentProvider.currentIndex) {
                    case 0:
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (context) => ActionDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          title: 'الخروج',
                          content: 'هل تود الغاء الشحنة',
                          onApproveClick: () {
                            MagicRouter.pop();
                            MagicRouter.pop();
                          },
                          onCancelClick: () {
                            MagicRouter.pop();
                          },
                          approveAction: 'نعم',
                          cancelAction: 'لا',
                        ),
                      );
                      break;
                    case 1:
                      shipmentProvider.setIndex(0);
                      break;
                    case 2:
                      shipmentProvider.setIndex(1);
                      break;
                    case 3:
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (context) => ActionDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          title: 'الخروج',
                          content: 'هل تود الغاء الشحنة',
                          onApproveClick: () {
                            shipmentProvider.shipments.clear();
                            shipmentProvider.setIndex(0);
                            MagicRouter.pop();
                            MagicRouter.pop();
                          },
                          onCancelClick: () {
                            MagicRouter.pop();
                          },
                          approveAction: 'نعم',
                          cancelAction: 'لا',
                        ),
                      );
                      break;
                  }
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
              ),
            ),
            title: Text(
              shipmentProvider.currentIndex != 3
                  ? 'أضافة شحنة'
                  : shipmentProvider.shipmentFromWhere == moreThanOneShipment
                      ? 'ملخص الشحنات'
                      : 'مراجعة الشحنة',
            ),
          ),
          body: Column(
            children: [
              shipmentProvider.currentIndex != 3
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StepperItem(
                                contentColor: shipmentProvider.currentIndex <= 2
                                    ? weevoPrimaryOrangeColor
                                    : Colors.grey[300]!,
                                textColor: shipmentProvider.currentIndex <= 2
                                    ? weevoPrimaryOrangeColor
                                    : Colors.grey[500]!,
                                height: shipmentProvider.currentIndex <= 2
                                    ? size.height * 0.07
                                    : size.height * 0.05,
                                width: shipmentProvider.currentIndex <= 2
                                    ? size.height * 0.07
                                    : size.height * 0.05,
                                selectedItem: shipmentProvider.currentIndex,
                                title: 'منين',
                                path: shipmentProvider.currentIndex <= 2
                                    ? 'assets/images/boxes_white.png'
                                    : 'assets/images/boxes_gray.png',
                                itemIndex: 0,
                              ),
                              Row(
                                children: List.generate(
                                  15,
                                  (index) => DottedContainer(
                                    color: shipmentProvider.currentIndex == 1 ||
                                            shipmentProvider.currentIndex == 2
                                        ? weevoPrimaryOrangeColor
                                        : Colors.grey[400]!,
                                  ),
                                ),
                              ),
                              StepperItem(
                                contentColor:
                                    shipmentProvider.currentIndex == 1 ||
                                            shipmentProvider.currentIndex == 2
                                        ? weevoPrimaryOrangeColor
                                        : Colors.grey[300]!,
                                textColor: shipmentProvider.currentIndex == 1 ||
                                        shipmentProvider.currentIndex == 2
                                    ? weevoPrimaryOrangeColor
                                    : Colors.grey[500]!,
                                height: shipmentProvider.currentIndex == 1 ||
                                        shipmentProvider.currentIndex == 2
                                    ? size.height * 0.07
                                    : size.height * 0.05,
                                width: shipmentProvider.currentIndex == 1 ||
                                        shipmentProvider.currentIndex == 2
                                    ? size.height * 0.07
                                    : size.height * 0.05,
                                selectedItem: shipmentProvider.currentIndex,
                                title: 'ل فين',
                                path: shipmentProvider.currentIndex == 1 ||
                                        shipmentProvider.currentIndex == 2
                                    ? 'assets/images/location_icon_white.png'
                                    : 'assets/images/location_icon_gray.png',
                                itemIndex: 1,
                              ),
                              Row(
                                children: List.generate(
                                  15,
                                  (index) => DottedContainer(
                                    color: shipmentProvider.currentIndex == 2
                                        ? weevoPrimaryOrangeColor
                                        : Colors.grey[400]!,
                                  ),
                                ),
                              ),
                              StepperItem(
                                contentColor: shipmentProvider.currentIndex == 2
                                    ? weevoPrimaryOrangeColor
                                    : Colors.grey[300]!,
                                textColor: shipmentProvider.currentIndex == 2
                                    ? weevoPrimaryOrangeColor
                                    : Colors.grey[500]!,
                                height: shipmentProvider.currentIndex == 2
                                    ? size.height * 0.07
                                    : size.height * 0.05,
                                width: shipmentProvider.currentIndex == 2
                                    ? size.height * 0.07
                                    : size.height * 0.05,
                                selectedItem: shipmentProvider.currentIndex,
                                title: 'الشحنة',
                                path: shipmentProvider.currentIndex == 2
                                    ? 'assets/images/shipment_box_white.png'
                                    : 'assets/images/shipment_box_gray.png',
                                itemIndex: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * .01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (shipmentProvider.currentIndex == 0)
                              const Text(
                                'مكان استلام الشحنة هيكون فين؟',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: weevoGreyBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            if (shipmentProvider.currentIndex == 1)
                              const Text(
                                'مكان تسليم الشحنة ومعلوماتها',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: weevoGreyBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            if (shipmentProvider.currentIndex == 2)
                              const Text(
                                'هتشحن ايه؟ اختر ما بين المنتجات',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: weevoGreyBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        const Divider(
                          height: 2.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                      ],
                    )
                  : Container(),
              Expanded(
                child: shipmentProvider.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
