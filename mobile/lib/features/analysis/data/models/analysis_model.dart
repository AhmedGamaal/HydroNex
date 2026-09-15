class AnalysisModel {
  List<SensorModel> sensors;
  bool allSensorsOnline;
  String lastUpdated;
  List<TrendModel> environmentTrends;

  AnalysisModel({
    required this.sensors,
    required this.allSensorsOnline,
    required this.lastUpdated,
    required this.environmentTrends,
  });
}

class SensorModel {
  String name;
  String value;
  String unit;
  String optimalRange;
  String iconName;
  List<double> chartData;

  SensorModel({
    required this.name,
    required this.value,
    required this.unit,
    required this.optimalRange,
    required this.iconName,
    required this.chartData,
  });
}

class TrendModel {
  String day;
  double value;

  TrendModel({required this.day, required this.value});
}
