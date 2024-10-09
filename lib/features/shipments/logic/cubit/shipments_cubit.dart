import 'package:bloc/bloc.dart';

import '../../../wasully_details/data/models/shipment_status/base_shipment_status.dart';
import '../../../wasully_details/data/models/wasully_model.dart';
import '../../data/models/shipment_model.dart';
import '../../data/repos/shipments_repo.dart';
import 'shipments_states.dart';

class ShipmentsCubit extends Cubit<ShipmentsStates> {
  final ShipmentsRepo _shipmentsRepo;
  ShipmentsCubit(this._shipmentsRepo) : super(ShipmentsInitialState());

  int currentFilterIndex = 0;
  int lastRequestedFilterIndex = -1;

  void filterAndGetShipments(int index, {bool isForcedGetData = false}) async {
    if (!isForcedGetData &&
        (currentFilterIndex == index || state is ShipmentsLoadingState)) return;
    currentFilterIndex = index;
    lastRequestedFilterIndex = index;
    await getShipments();
    emit(ShipmentsChangeFilterState(index));
  }

  int currentPage = 1;
  bool hasMoreData = true;
  List<ShipmentModel>? shipments;
  final int pageSize = 15;
  Future<void> getShipments({bool isPaging = false}) async {
    if (state is ShipmentsLoadingState ||
        state is ShipmentsPagingLoadingState) {
      return;
    }
    if (isPaging) {
      if (!hasMoreData) return;
      emit(ShipmentsPagingLoadingState());
    } else {
      currentPage = 1;
      shipments = [];
      hasMoreData = true;
      emit(ShipmentsLoadingState());
    }
    final result = await _shipmentsRepo.getShipments(
      currentPage,
      BaseShipmentStatus.shipmentStatusList[currentFilterIndex].status,
    );
    if (result.success! && lastRequestedFilterIndex == currentFilterIndex) {
      hasMoreData = result.data?.shipments.length == pageSize;
      shipments?.addAll(result.data!.shipments);
      if ((isPaging && hasMoreData) || currentPage == 1) currentPage++;
      emit(ShipmentsSuccessState(shipments ?? []));
    } else {
      hasMoreData = false;
      emit(ShipmentsErrorState(result.error ?? ''));
    }
  }

  void updateOneShipment(WasullyModel wasullyModel) {
    ShipmentModel shipmentModel = shipments!.singleWhere(
      (element) => element.id == wasullyModel.id,
    );
    ShipmentModel newShipment = shipmentModel.copyWith(
      id: wasullyModel.id,
      slug: wasullyModel.slug,
      price: wasullyModel.price,
      amount: wasullyModel.amount,
      deliveringCityModel: wasullyModel.deliveringCityModel,
      deliveringStateModel: wasullyModel.deliveringStateModel,
      receivingCityModel: wasullyModel.receivingCityModel,
      receivingStateModel: wasullyModel.receivingStateModel,
      tip: wasullyModel.tip,
      title: wasullyModel.title,
      image: wasullyModel.image,
      receivingStreet: wasullyModel.receivingStreet,
      deliveringStreet: wasullyModel.deliveringStreet,
    );
    int index = shipments!.indexWhere(
      (element) => element.id == wasullyModel.id,
    );
    shipments![index] = newShipment;
    emit(ShipmentsSuccessState(shipments ?? []));
  }
}
