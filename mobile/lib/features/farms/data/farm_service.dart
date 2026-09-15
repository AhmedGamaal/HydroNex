import 'package:dio/dio.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/features/farms/datasources/farm_remote_data_source.dart';
import 'package:hydronex_app/features/farms/repositories/farm_repository_impl.dart';

class FarmService {
  static FarmRepositoryImpl createRepository() {
    final tokenStorage = const TokenStorage();

    final Dio dio = ApiClient.create(tokenStorage: tokenStorage);

    final remoteDataSource = FarmRemoteDataSource(dio: dio);

    return FarmRepositoryImpl(remoteDataSource: remoteDataSource);
  }
}
