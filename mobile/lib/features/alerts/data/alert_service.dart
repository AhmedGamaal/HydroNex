import 'package:dio/dio.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/features/alerts/data/datasources/alert_remote_data_source.dart';
import 'package:hydronex_app/features/alerts/data/repositories/alert_repository_impl.dart';

class AlertService {
  static AlertRepositoryImpl createRepository() {
    final tokenStorage = const TokenStorage();
    final Dio dio = ApiClient.create(tokenStorage: tokenStorage);
    final remoteDataSource = AlertRemoteDataSource(dio: dio);

    return AlertRepositoryImpl(remoteDataSource: remoteDataSource);
  }
}
