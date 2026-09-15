import 'package:hydronex_app/features/sensors/data/datasources/sensor_remote_data_source.dart';
import 'package:hydronex_app/features/sensors/data/models/create_sensor_request.dart';
import 'package:hydronex_app/features/sensors/data/models/sensor_response.dart';
import 'package:hydronex_app/features/sensors/domain/sensor_repository.dart';

class SensorRepositoryImpl implements SensorRepository {
  final SensorRemoteDataSource remoteDataSource;

  SensorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SensorResponse> createSensor(CreateSensorRequest request) {
    return remoteDataSource.createSensor(request);
  }

  @override
  Future<List<SensorResponse>> getSensorsByCropId(int cropId) {
    return remoteDataSource.getSensorsByCropId(cropId);
  }
}
