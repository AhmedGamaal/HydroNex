import '../data/models/create_farm_request.dart';
import '../data/models/farm_response.dart';

abstract class FarmRepository {
  Future<FarmResponse> createFarm(CreateFarmRequest request);

  Future<List<FarmResponse>> getFarms();

  Future<FarmResponse> getFarmById(int id);

  Future<FarmResponse> updateFarm(int id, CreateFarmRequest request);
}
