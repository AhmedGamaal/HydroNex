import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/create_farm_request.dart';
import '../../data/models/farm_response.dart';
import '../../domain/farm_repository.dart';

part 'farm_state.dart';

class FarmCubit extends Cubit<FarmState> {
  FarmCubit({required FarmRepository repository})
    : _repository = repository,
      super(const FarmState());

  final FarmRepository _repository;

  Future<void> getFarms() async {
    emit(state.copyWith(status: FarmStatus.loading, errorMessage: null));

    try {
      final farms = await _repository.getFarms();

      emit(state.copyWith(status: FarmStatus.success, farms: farms));
    } catch (e) {
      emit(
        state.copyWith(status: FarmStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> createFarm({
    required String name,
    required String location,
    required String description,
  }) async {
    emit(state.copyWith(status: FarmStatus.loading, errorMessage: null));

    try {
      final farm = await _repository.createFarm(
        CreateFarmRequest(
          name: name,
          location: location,
          description: description,
        ),
      );

      emit(state.copyWith(status: FarmStatus.success, farms: [farm]));
    } catch (e) {
      emit(
        state.copyWith(status: FarmStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
