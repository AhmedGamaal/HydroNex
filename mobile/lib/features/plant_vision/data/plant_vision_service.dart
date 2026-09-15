import 'package:dio/dio.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/features/plant_vision/data/datasources/plant_vision_remote_data_source.dart';
import 'package:hydronex_app/features/plant_vision/data/repositories/plant_vision_repository_impl.dart';

class PlantVisionService {
  static PlantVisionRepositoryImpl createRepository() {
    final tokenStorage = const TokenStorage();

    final Dio dio = ApiClient.create(tokenStorage: tokenStorage);

    final remoteDataSource = PlantVisionRemoteDataSource(dio: dio);

    return PlantVisionRepositoryImpl(remoteDataSource: remoteDataSource);
  }
}
