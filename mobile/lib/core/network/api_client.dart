import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class ApiClient {
  static const String baseUrl = 'https://hydronex-api-g-eddgded6c3h4a5e3.centralus-01.azurewebsites.net';

  static Dio create({required TokenStorage tokenStorage}) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {'accept': '*/*', 'Content-Type': 'application/json'}));

    dio.interceptors.add(
      InterceptorsWrapper(
        // onRequest: (options, handler) async {
        //   final token = await tokenStorage.getToken();

        //   if (token != null && token.isNotEmpty) {
        //     options.headers['Authorization'] = 'Bearer $token';
        //   }

        //   handler.next(options);
        // },
        onRequest: (options, handler) async {
          final isAuthEndpoint =
              options.path.contains('/api/Auth/login') ||
              options.path.contains('/api/Auth/register') ||
              options.path.contains('/api/Auth/forgot-password') ||
              options.path.contains('/api/Auth/verify-otp') ||
              options.path.contains('/api/Auth/reset-password');

          if (!isAuthEndpoint) {
            final token = await tokenStorage.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
