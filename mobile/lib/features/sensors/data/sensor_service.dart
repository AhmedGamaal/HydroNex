import 'package:dio/dio.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/features/sensors/data/datasources/sensor_remote_data_source.dart';
import 'package:hydronex_app/features/sensors/data/repositories/sensor_repository_impl.dart';

class SensorService {
  static SensorRepositoryImpl createRepository() {
    final tokenStorage = const TokenStorage();
    final Dio dio = ApiClient.create(tokenStorage: tokenStorage);

    final remoteDataSource = SensorRemoteDataSource(dio: dio);

    return SensorRepositoryImpl(remoteDataSource: remoteDataSource);
  }
}
