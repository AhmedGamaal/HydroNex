import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import 'datasources/auth_remote_data_source.dart';
import 'repositories/auth_repository_impl.dart';

class AuthService {
  static AuthRepositoryImpl createRepository() {
    final tokenStorage = const TokenStorage();

    final Dio dio = ApiClient.create(tokenStorage: tokenStorage);

    final remoteDataSource = AuthRemoteDataSource(dio: dio);

    return AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      tokenStorage: tokenStorage,
    );
  }
}
