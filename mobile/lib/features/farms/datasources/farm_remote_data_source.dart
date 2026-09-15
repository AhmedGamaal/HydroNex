import 'package:dio/dio.dart';
import 'package:hydronex_app/features/farms/data/models/create_farm_request.dart';
import 'package:hydronex_app/features/farms/data/models/farm_response.dart';

class FarmRemoteDataSource {
  final Dio dio;

  FarmRemoteDataSource({required this.dio});

  Future<FarmResponse> createFarm(CreateFarmRequest request) async {
    final response = await dio.post('/api/Farms', data: request.toJson());

    return FarmResponse.fromJson(response.data);
  }

  Future<List<FarmResponse>> getFarms() async {
    final response = await dio.get('/api/Farms');

    return (response.data as List)
        .map((json) => FarmResponse.fromJson(json))
        .toList();
  }

  Future<FarmResponse> getFarmById(int id) async {
    final response = await dio.get('/api/Farms/$id');

    return FarmResponse.fromJson(response.data);
  }

  Future<FarmResponse> updateFarm(int id, CreateFarmRequest request) async {
    final response = await dio.put('/api/Farms/$id', data: request.toJson());

    return FarmResponse.fromJson(response.data);
  }
}
