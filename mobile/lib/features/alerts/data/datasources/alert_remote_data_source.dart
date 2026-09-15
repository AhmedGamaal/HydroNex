import 'package:dio/dio.dart';
import 'package:hydronex_app/features/alerts/data/models/alert_response.dart';

class AlertRemoteDataSource {
  final Dio dio;

  AlertRemoteDataSource({required this.dio});

  Future<List<AlertResponse>> getAlertsByCropId(int cropId) async {
    final response = await dio.get('/api/alerts/crop/$cropId');

    print('ALERTS API RESPONSE: ${response.data}');

    return (response.data as List)
        .map((json) => AlertResponse.fromJson(json))
        .toList();
  }
}
