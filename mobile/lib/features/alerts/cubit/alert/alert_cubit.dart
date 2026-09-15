import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/features/alerts/data/models/alert_response.dart';
import 'package:hydronex_app/features/alerts/domain/alert_repository.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  AlertCubit({required AlertRepository repository})
    : _repository = repository,
      super(const AlertState());

  final AlertRepository _repository;

  Future<void> getAlertsByCropId(int cropId) async {
    emit(state.copyWith(status: AlertStatus.loading, errorMessage: null));

    try {
      final alerts = await _repository.getAlertsByCropId(cropId);

      emit(state.copyWith(status: AlertStatus.success, alerts: alerts));
    } catch (e) {
      emit(
        state.copyWith(status: AlertStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
