import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weevo_merchant_upgrade/features/bulk_shipment_details/data/repos/bulk_shipment_details_repo.dart';

import '../../data/models/bulk_shipment_model.dart';

part 'bulk_shipment_cubit.freezed.dart';
part 'bulk_shipment_state.dart';

class BulkShipmentCubit extends Cubit<BulkShipmentState> {
  final BulkShipmentDetailsRepo _bulkShipmentDetailsRepo;
  BulkShipmentCubit(this._bulkShipmentDetailsRepo)
      : super(const BulkShipmentState.initial());

  BulkShipmentModel? bulkShipmentModel;

  Future<void> getBulkShipmentDetails(int id,
      {bool clearShipment = true}) async {
    if (clearShipment) bulkShipmentModel = null;
    emit(const BulkShipmentState.loading());
    final result = await _bulkShipmentDetailsRepo.getBulkShipmentDetails(id);
    if (result.success) {
      bulkShipmentModel = result.data;
      emit(BulkShipmentState.success(bulkShipmentModel!));
    } else {
      emit(BulkShipmentState.error(result.error ?? ''));
    }
  }
}
