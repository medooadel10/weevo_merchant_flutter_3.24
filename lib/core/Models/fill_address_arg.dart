import 'address.dart';

class FillAddressArg {
  final Address? address;
  final bool isUpdated;

  FillAddressArg({
    required this.isUpdated,
    this.address,
  });
}
