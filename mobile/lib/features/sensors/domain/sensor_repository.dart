import '../data/models/create_sensor_request.dart';
import '../data/models/sensor_response.dart';

abstract class SensorRepository {
  Future<SensorResponse> createSensor(CreateSensorRequest request);

  Future<List<SensorResponse>> getSensorsByCropId(int cropId);
}
