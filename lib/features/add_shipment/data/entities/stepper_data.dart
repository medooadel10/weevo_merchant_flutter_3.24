import 'package:flutter/material.dart';

import '../../ui/widgets/add_shipment_body/add_shipment_first_body.dart';
import '../../ui/widgets/add_shipment_body/add_shipment_second_body.dart';
import '../../ui/widgets/add_shipment_body/add_shipment_third_body.dart';

class StepperData {
  final String title;
  final String image;
  final String description;
  final Widget body;

  StepperData({
    required this.title,
    required this.image,
    required this.description,
    required this.body,
  });

  static final List<StepperData> list = [
    StepperData(
      title: 'منين',
      image: 'boxes',
      description: 'مكان استلام الشحنة هيكون فين؟',
      body: const AddShipmentFirstBody(),
    ),
    StepperData(
      title: 'ل فين',
      image: 'address',
      body: const AddShipmentSecondBody(),
      description: 'مكان تسليم الشحنة ومعلوماتها',
    ),
    StepperData(
      title: 'الطلب',
      image: 'shipment_box',
      body: const AddShipmentThirdBody(),
      description: 'هتشحن ايه؟ اختر ما بين المنتجات',
    ),
  ];
}
