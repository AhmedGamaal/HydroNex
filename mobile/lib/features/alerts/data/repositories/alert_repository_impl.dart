import 'package:hydronex_app/features/alerts/data/datasources/alert_remote_data_source.dart';
import 'package:hydronex_app/features/alerts/data/models/alert_response.dart';
import 'package:hydronex_app/features/alerts/domain/alert_repository.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertRemoteDataSource remoteDataSource;

  AlertRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AlertResponse>> getAlertsByCropId(int cropId) {
    return remoteDataSource.getAlertsByCropId(cropId);
  }
}
