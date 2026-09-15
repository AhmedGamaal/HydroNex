import 'package:hydronex_app/features/crops/data/models/update_crop_request.dart';
import '../../domain/crop_repository.dart';
import '../datasources/crop_remote_data_source.dart';
import '../models/create_crop_request.dart';
import '../models/crop_response.dart';

class CropRepositoryImpl implements CropRepository {
  final CropRemoteDataSource remoteDataSource;

  CropRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CropResponse> createCrop(CreateCropRequest request) {
    return remoteDataSource.createCrop(request);
  }

  @override
  Future<List<CropResponse>> getCrops() {
    return remoteDataSource.getCrops();
  }

  @override
  Future<CropResponse> getCropById(int id) {
    return remoteDataSource.getCropById(id);
  }

  @override
  Future<CropResponse> updateCrop(int id, UpdateCropRequest request) {
    return remoteDataSource.updateCrop(id, request);
  }

  @override
  Future<void> deleteCrop(int id) {
    return remoteDataSource.deleteCrop(id);
  }
}
