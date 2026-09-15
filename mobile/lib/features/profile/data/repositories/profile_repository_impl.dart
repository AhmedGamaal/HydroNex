import 'package:hydronex_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:hydronex_app/features/profile/data/models/profile_model.dart';
import 'package:hydronex_app/features/profile/data/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileModel> getProfile() {
    return remoteDataSource.getProfile();
  }
}
