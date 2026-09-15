import '../data/models/create_crop_request.dart';
import '../data/models/crop_response.dart';
import '../data/models/update_crop_request.dart';

abstract class CropRepository {
  Future<CropResponse> createCrop(CreateCropRequest request);
  Future<List<CropResponse>> getCrops();
  Future<CropResponse> getCropById(int id);
  Future<CropResponse> updateCrop(int id, UpdateCropRequest request);
  Future<void> deleteCrop(int id);
}
