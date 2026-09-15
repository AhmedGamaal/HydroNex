import 'package:hydronex_app/features/analysis/data/models/latest_sensor_reading_response.dart';
import 'package:hydronex_app/features/analysis/data/models/sensor_reading_response.dart';
import 'package:hydronex_app/features/sensors/data/models/sensor_response.dart';

abstract class AnalysisRepository {
  Future<List<LatestSensorReadingResponse>> getLatestSensorReadings(int cropId);

  Future<List<SensorReadingResponse>> getSensorHistory(
    int cropId, {
    DateTime? from,
    DateTime? to,
  });

  Future<List<SensorResponse>> getSensorsByCropId(int cropId);
}
