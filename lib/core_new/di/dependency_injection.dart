import 'package:get_it/get_it.dart';

import '../../core/Storage/shared_preference.dart';
import '../../features/bulk_shipment_details/data/repos/bulk_shipment_details_repo.dart';
import '../../features/products/data/repos/products_repo.dart';
import '../../features/shipment_details/data/repos/shipment_details_repo.dart';
import '../../features/shipments/data/repos/shipments_repo.dart';
import '../../features/waslny/data/repos/waslny_map_repo.dart';
import '../../features/waslny/data/repos/waslny_repo.dart';
import '../../features/wasully_details/data/repos/wasully_details_repo.dart';
import '../../features/wasully_handle_shipment/data/repos/wasully_handle_shipment_repo.dart';
import '../../features/wasully_shipping_offers/data/repos/wasully_shipping_offers_repo.dart';
import '../helpers/wasully_delivery_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerSingleton(Preferences.instance);

  // Waslny
  getIt.registerLazySingleton(() => WaslnyRepo());

  // Waslny Map
  getIt.registerLazySingleton(() => WaslyMapRepo());

  // Shipments
  getIt.registerLazySingleton(() => ShipmentsRepo());

  // Wasully Details
  getIt.registerLazySingleton(() => WasullyDetailsRepo());

  // Shipment Details
  getIt.registerLazySingleton(() => ShipmentDetailsRepo());

  // Bulk Shipment Details
  getIt.registerLazySingleton(() => BulkShipmentDetailsRepo());

  // Couriers
  getIt.registerLazySingleton(() => WasullyShippingOffersRepo());

  // Wasully Handle Shipment
  getIt.registerLazySingleton(() => WasullyHandleShipmentRepo());

  // Wasully Delivery Service
  getIt.registerLazySingleton(() => WasullyDeliveryService());

  // Products
  getIt.registerLazySingleton(() => ProductsRepo());
}
