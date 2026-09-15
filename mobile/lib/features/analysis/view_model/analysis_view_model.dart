import 'package:flutter/foundation.dart';
import 'package:hydronex_app/features/analysis/data/models/analysis_model.dart';
import 'package:hydronex_app/features/analysis/data/models/latest_sensor_reading_response.dart';
import 'package:hydronex_app/features/analysis/data/models/sensor_reading_response.dart';
import 'package:hydronex_app/features/analysis/data/repositories/analysis_repository.dart';
import 'package:hydronex_app/features/sensors/data/models/sensor_response.dart';

class AnalysisViewModel extends ChangeNotifier {
  final AnalysisRepository repository;

  List<LatestSensorReadingResponse> sensorReadings = [];
  List<SensorModel> sensors = [];
  List<SensorResponse> sensorStatuses = [];
  List<TrendModel> environmentTrends = [];

  bool allSensorsOnline = false;
  String lastUpdated = '';

  bool isLoading = false;
  String? errorMessage;

  AnalysisViewModel({required this.repository});

  Future<void> loadAnalysis(int cropId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final latestReadings = await repository.getLatestSensorReadings(cropId);

      final historyReadings = await repository.getSensorHistory(cropId);

      final sensorStatuses = await repository.getSensorsByCropId(cropId);

      sensorReadings = latestReadings;
      this.sensorStatuses = sensorStatuses;

      allSensorsOnline =
          sensorStatuses.isNotEmpty &&
          sensorStatuses.every((sensor) => sensor.status == 'Active');

      if (latestReadings.isNotEmpty) {
        final latestTime = latestReadings
            .map((reading) => reading.recordedAt)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        lastUpdated = _formatLastUpdated(latestTime);
      }

      sensors = _buildSensors(latestReadings, historyReadings);

      environmentTrends = _buildEnvironmentTrends(historyReadings);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  List<SensorModel> _buildSensors(
    List<LatestSensorReadingResponse> latestReadings,
    List<SensorReadingResponse> historyReadings,
  ) {
    final sensors = <SensorModel>[];

    const sensorOrder = [
      'AirTemperature',
      'WaterTemperature',
      'PH',
      'EC',
      'Humidity',
      'Light',
      'WaterLevel',
      'CO2',
    ];

    for (final sensorType in sensorOrder) {
      final latest = latestReadings
          .where((reading) => reading.sensorType == sensorType)
          .firstOrNull;

      if (latest == null) {
        continue;
      }

      final chartData = historyReadings
          .where((reading) => reading.sensorType == sensorType)
          .map((reading) => reading.value)
          .toList();

      sensors.add(_mapSensor(latest, chartData));
    }

    return sensors;
  }

  List<TrendModel> _buildEnvironmentTrends(
    List<SensorReadingResponse> historyReadings,
  ) {
    return historyReadings
        .where((reading) => reading.sensorType == 'AirTemperature')
        .map(
          (reading) => TrendModel(
            day: _formatTrendTime(reading.recordedAt),
            value: reading.value,
          ),
        )
        .toList();
  }

  SensorModel _mapSensor(
    LatestSensorReadingResponse reading,
    List<double> chartData,
  ) {
    switch (reading.sensorType) {
      case 'AirTemperature':
        return SensorModel(
          name: 'Temperature',
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '18 - 30°C',
          iconName: 'temperature',
          chartData: chartData,
        );

      case 'WaterTemperature':
        return SensorModel(
          name: 'Water Temperature',
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '18 - 24°C',
          iconName: 'temperature_water',
          chartData: chartData,
        );

      case 'PH':
        return SensorModel(
          name: 'PH',
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '5.5 - 6.5',
          iconName: 'ph',
          chartData: chartData,
        );

      case 'EC':
        return SensorModel(
          name: 'EC',
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '1.0 - 3.0 mS/cm',
          iconName: 'ec',
          chartData: chartData,
        );

      case 'Humidity':
        return SensorModel(
          name: 'Humidity',
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '40 - 80%',
          iconName: 'humidity',
          chartData: chartData,
        );

      case 'Light':
        return SensorModel(
          name: 'Light Intensity',
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '1000 - 30000 lux',
          iconName: 'light',
          chartData: chartData,
        );

      case 'WaterLevel':
        return SensorModel(
          name: 'Water Level',
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '20 - 100%',
          iconName: 'water',
          chartData: chartData,
        );

      case 'CO2':
        return SensorModel(
          name: 'CO₂',
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '400 - 1500 ppm',
          iconName: 'co2',
          chartData: chartData,
        );

      default:
        return SensorModel(
          name: reading.sensorType,
          value: _formatValue(reading.value),
          unit: reading.unit,
          optimalRange: '-',
          iconName: 'temperature',
          chartData: chartData,
        );
    }
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  String _formatLastUpdated(DateTime dateTime) {
    final localTime = dateTime.toLocal();

    final hour = localTime.hour == 0
        ? 12
        : localTime.hour > 12
        ? localTime.hour - 12
        : localTime.hour;

    final minute = localTime.minute.toString().padLeft(2, '0');

    final period = localTime.hour >= 12 ? 'PM' : 'AM';

    return 'Today, $hour:$minute $period';
  }

  String _formatTrendTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();

    final hour = localTime.hour == 0
        ? 12
        : localTime.hour > 12
        ? localTime.hour - 12
        : localTime.hour;

    final minute = localTime.minute.toString().padLeft(2, '0');

    final period = localTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}
