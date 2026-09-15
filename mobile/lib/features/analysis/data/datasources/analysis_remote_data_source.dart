import 'package:dio/dio.dart';
import 'package:hydronex_app/features/analysis/data/models/latest_sensor_reading_response.dart';
import 'package:hydronex_app/features/analysis/data/models/sensor_reading_response.dart';
import 'package:hydronex_app/features/sensors/data/models/sensor_response.dart';

class AnalysisRemoteDataSource {
  final Dio dio;

  AnalysisRemoteDataSource({required this.dio});

  Future<List<LatestSensorReadingResponse>> getLatestSensorReadings(
    int cropId,
  ) async {
    final response = await dio.get('/api/telemetry/crop/$cropId/latest');

    return (response.data as List)
        .map((json) => LatestSensorReadingResponse.fromJson(json))
        .toList();
  }

  Future<List<SensorReadingResponse>> getSensorHistory(
    int cropId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final response = await dio.get(
      '/api/telemetry/crop/$cropId/history',
      queryParameters: {
        if (from != null) 'from': from.toUtc().toIso8601String(),
        if (to != null) 'to': to.toUtc().toIso8601String(),
      },
    );

    return (response.data as List)
        .map((json) => SensorReadingResponse.fromJson(json))
        .toList();
  }

  Future<List<SensorResponse>> getSensorsByCropId(int cropId) async {
    final response = await dio.get('/api/Sensors/crop/$cropId');

    return (response.data as List)
        .map((json) => SensorResponse.fromJson(json))
        .toList();
  }
}
