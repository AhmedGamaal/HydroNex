part of 'sensor_cubit.dart';

enum SensorStatus { initial, loading, success, failure }

class SensorState {
  final SensorStatus status;
  final List<SensorResponse> sensors;
  final String? errorMessage;

  const SensorState({
    this.status = SensorStatus.initial,
    this.sensors = const [],
    this.errorMessage,
  });

  SensorState copyWith({
    SensorStatus? status,
    List<SensorResponse>? sensors,
    String? errorMessage,
  }) {
    return SensorState(
      status: status ?? this.status,
      sensors: sensors ?? this.sensors,
      errorMessage: errorMessage,
    );
  }
}
