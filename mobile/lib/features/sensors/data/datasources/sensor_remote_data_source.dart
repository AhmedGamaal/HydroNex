import 'package:dio/dio.dart';

import '../models/create_sensor_request.dart';
import '../models/sensor_response.dart';

class SensorRemoteDataSource {
  final Dio dio;

  SensorRemoteDataSource({required this.dio});

  Future<SensorResponse> createSensor(CreateSensorRequest request) async {
    print('CREATE SENSOR REQUEST: ${request.toJson()}');

    final response = await dio.post('/api/Sensors', data: request.toJson());

    print('CREATE SENSOR RESPONSE: ${response.data}');

    return SensorResponse.fromJson(response.data);
  }

  Future<List<SensorResponse>> getSensorsByCropId(int cropId) async {
    final response = await dio.get('/api/Sensors/crop/$cropId');

    return (response.data as List)
        .map((json) => SensorResponse.fromJson(json))
        .toList();
  }
}
