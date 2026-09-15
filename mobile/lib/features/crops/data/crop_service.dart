import 'package:dio/dio.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';

import 'datasources/crop_remote_data_source.dart';
import 'repositories/crop_repository_impl.dart';

class CropService {
  static CropRepositoryImpl createRepository() {
    final tokenStorage = const TokenStorage();

    final Dio dio = ApiClient.create(tokenStorage: tokenStorage);

    final remoteDataSource = CropRemoteDataSource(dio: dio);

    return CropRepositoryImpl(remoteDataSource: remoteDataSource);
  }
}
