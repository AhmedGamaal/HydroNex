import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/features/sensors/data/models/create_sensor_request.dart';
import 'package:hydronex_app/features/sensors/data/models/sensor_response.dart';
import 'package:hydronex_app/features/sensors/domain/sensor_repository.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  SensorCubit({required SensorRepository repository})
    : _repository = repository,
      super(const SensorState());

  final SensorRepository _repository;

  Future<void> createSensor(CreateSensorRequest request) async {
    emit(state.copyWith(status: SensorStatus.loading, errorMessage: null));

    try {
      final sensor = await _repository.createSensor(request);

      emit(
        state.copyWith(
          status: SensorStatus.success,
          sensors: [...state.sensors, sensor],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SensorStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getSensorsByCropId(int cropId) async {
    emit(state.copyWith(status: SensorStatus.loading, errorMessage: null));

    try {
      final sensors = await _repository.getSensorsByCropId(cropId);

      emit(state.copyWith(status: SensorStatus.success, sensors: sensors));
    } catch (e) {
      emit(
        state.copyWith(
          status: SensorStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> createDefaultSensors(int cropId) async {
    final sensors = [
      const CreateSensorRequest(
        cropId: 0,
        type: 'PH',
        unit: 'pH',
        name: 'pH Sensor',
      ),
      const CreateSensorRequest(
        cropId: 0,
        type: 'EC',
        unit: 'mS/cm',
        name: 'EC Sensor',
      ),
      const CreateSensorRequest(
        cropId: 0,
        type: 'WaterTemperature',
        unit: '°C',
        name: 'Water Temperature Sensor',
      ),
      const CreateSensorRequest(
        cropId: 0,
        type: 'AirTemperature',
        unit: '°C',
        name: 'Air Temperature Sensor',
      ),
      const CreateSensorRequest(
        cropId: 0,
        type: 'Humidity',
        unit: '%',
        name: 'Humidity Sensor',
      ),
      const CreateSensorRequest(
        cropId: 0,
        type: 'WaterLevel',
        unit: '%',
        name: 'Water Level Sensor',
      ),
      const CreateSensorRequest(
        cropId: 0,
        type: 'CO2',
        unit: 'ppm',
        name: 'CO2 Sensor',
      ),
      const CreateSensorRequest(
        cropId: 0,
        type: 'Light',
        unit: 'lux',
        name: 'Light Sensor',
      ),
    ];

    for (final sensor in sensors) {
      await createSensor(
        CreateSensorRequest(
          cropId: cropId,
          type: sensor.type,
          unit: sensor.unit,
          name: sensor.name,
          location: sensor.location,
        ),
      );
    }
  }
}
