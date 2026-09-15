import 'package:hydronex_app/features/analysis/data/datasources/analysis_remote_data_source.dart';
import 'package:hydronex_app/features/analysis/data/models/latest_sensor_reading_response.dart';
import 'package:hydronex_app/features/analysis/data/models/sensor_reading_response.dart';
import 'package:hydronex_app/features/analysis/data/repositories/analysis_repository.dart';
import 'package:hydronex_app/features/sensors/data/models/sensor_response.dart';

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisRemoteDataSource remoteDataSource;

  AnalysisRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LatestSensorReadingResponse>> getLatestSensorReadings(
    int cropId,
  ) {
    return remoteDataSource.getLatestSensorReadings(cropId);
  }

  @override
  Future<List<SensorReadingResponse>> getSensorHistory(
    int cropId, {
    DateTime? from,
    DateTime? to,
  }) {
    return remoteDataSource.getSensorHistory(cropId, from: from, to: to);
  }

  @override
  Future<List<SensorResponse>> getSensorsByCropId(int cropId) {
    return remoteDataSource.getSensorsByCropId(cropId);
  }
}
