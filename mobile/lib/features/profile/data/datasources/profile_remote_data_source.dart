import 'package:dio/dio.dart';
import 'package:hydronex_app/features/profile/data/models/profile_model.dart';

class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource({required this.dio});

  Future<ProfileModel> getProfile() async {
    final response = await dio.get('/api/Auth/me');

    return ProfileModel(
      userId: response.data['userId'],
      name: response.data['fullName'],
      email: response.data['email'],
    );
  }
}
