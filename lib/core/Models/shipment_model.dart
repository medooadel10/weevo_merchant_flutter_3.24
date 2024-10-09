import 'address.dart';
import 'product_model.dart';

class ShipmentModel {
  Address merchantAddress;
  String deliveryDateTime;
  String receiveDateTime;
  String clientAddress;
  String clientPhoneNumber;
  String clientName;
  String cityName;
  String stateName;
  String? landmarkName;
  String? otherDetails;
  String paymentMethod;
  List<Product> products;
  double shipmentFee;
  double productTotalPrice;

  ShipmentModel({
    required this.merchantAddress,
    required this.deliveryDateTime,
    required this.receiveDateTime,
    required this.clientAddress,
    required this.paymentMethod,
    required this.clientPhoneNumber,
    required this.clientName,
    required this.cityName,
    required this.stateName,
    this.landmarkName,
    this.otherDetails,
    required this.products,
    required this.shipmentFee,
    required this.productTotalPrice,
  });

  @override
  String toString() {
    return 'ShipmentModel{merchantAddress: $merchantAddress, deliveryDateTime: $deliveryDateTime, receiveDateTime: $receiveDateTime, clientAddress: $clientAddress, clientPhoneNumber: $clientPhoneNumber, clientName: $clientName, otherDetails: $otherDetails, productsLength: ${products.length}, shipmentFee: $shipmentFee, productTotalPrice: $productTotalPrice, paymentMethod: $paymentMethod}';
  }
}
