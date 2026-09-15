import '../data/models/alert_response.dart';

abstract class AlertRepository {
  Future<List<AlertResponse>> getAlertsByCropId(int cropId);
}
