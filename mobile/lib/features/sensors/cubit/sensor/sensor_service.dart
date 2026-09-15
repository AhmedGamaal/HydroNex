import 'package:hydronex_app/features/sensors/cubit/sensor/sensor_cubit.dart';
import 'package:hydronex_app/features/sensors/data/sensor_service.dart';

class SensorCubitService {
  static SensorCubit create() {
    return SensorCubit(repository: SensorService.createRepository());
  }
}
