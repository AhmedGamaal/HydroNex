import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/features/crops/data/models/create_crop_request.dart';
import '../../data/models/crop_response.dart';
import '../../domain/crop_repository.dart';
import '../../data/models/update_crop_request.dart';

part 'crop_state.dart';

class CropCubit extends Cubit<CropState> {
  CropCubit({required CropRepository repository})
    : _repository = repository,
      super(const CropState());

  final CropRepository _repository;

  Future<List<CropResponse>> getCrops() async {
    emit(state.copyWith(status: CropStatus.loading, errorMessage: null));

    try {
      final crops = await _repository.getCrops();

      emit(state.copyWith(status: CropStatus.success, crops: crops));

      return crops;
    } catch (e) {
      emit(
        state.copyWith(status: CropStatus.failure, errorMessage: e.toString()),
      );

      return [];
    }
  }

  Future<CropResponse?> createCrop({
    required int farmId,
    required String cropType,
    required String batchId,
    required String location,
    required String notes,
    required String variety,
    required String plantingDate,
    required int cycleDuration,
  }) async {
    emit(state.copyWith(status: CropStatus.loading, errorMessage: null));

    try {
      final crop = await _repository.createCrop(
        CreateCropRequest(
          farmId: farmId,
          cropType: cropType,
          batchId: batchId,
          location: location,
          notes: notes,
          variety: variety,
          plantingDate: plantingDate,
          cycleDuration: cycleDuration,
        ),
      );

      emit(
        state.copyWith(
          status: CropStatus.success,
          crops: [crop, ...state.crops],
        ),
      );

      return crop;
    } catch (e) {
      emit(
        state.copyWith(status: CropStatus.failure, errorMessage: e.toString()),
      );

      return null;
    }
  }

  Future<void> deleteCrop(int id) async {
    emit(state.copyWith(status: CropStatus.loading, errorMessage: null));

    try {
      await _repository.deleteCrop(id);

      emit(
        state.copyWith(
          status: CropStatus.deleteSuccess,
          crops: state.crops.where((crop) => crop.id != id).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CropStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateCrop({
    required int id,
    required UpdateCropRequest request,
  }) async {
    emit(state.copyWith(status: CropStatus.loading, errorMessage: null));

    try {
      final crop = await _repository.updateCrop(id, request);

      final updatedCrops = state.crops
          .map((item) => item.id == id ? crop : item)
          .toList();

      emit(state.copyWith(status: CropStatus.success, crops: updatedCrops));
    } catch (e) {
      emit(
        state.copyWith(status: CropStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
