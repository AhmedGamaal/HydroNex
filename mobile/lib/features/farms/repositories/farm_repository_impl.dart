import 'package:hydronex_app/features/farms/data/models/create_farm_request.dart';
import 'package:hydronex_app/features/farms/data/models/farm_response.dart';
import 'package:hydronex_app/features/farms/domain/farm_repository.dart';
import '../datasources/farm_remote_data_source.dart';

class FarmRepositoryImpl implements FarmRepository {
  final FarmRemoteDataSource remoteDataSource;

  FarmRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FarmResponse> createFarm(CreateFarmRequest request) {
    return remoteDataSource.createFarm(request);
  }

  @override
  Future<List<FarmResponse>> getFarms() {
    return remoteDataSource.getFarms();
  }

  @override
  Future<FarmResponse> getFarmById(int id) {
    return remoteDataSource.getFarmById(id);
  }

  @override
  Future<FarmResponse> updateFarm(int id, CreateFarmRequest request) {
    return remoteDataSource.updateFarm(id, request);
  }
}
