import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hydronex_app/features/crops/data/models/update_crop_request.dart';
import '../models/create_crop_request.dart';
import '../models/crop_response.dart';

class CropRemoteDataSource {
  final Dio dio;

  CropRemoteDataSource({required this.dio});

  Future<CropResponse> createCrop(CreateCropRequest request) async {
    final response = await dio.post('/api/Crops', data: request.toJson());

    debugPrint('CREATE CROP RESPONSE: ${response.data}');

    return CropResponse.fromJson(response.data);
  }

  Future<List<CropResponse>> getCrops() async {
    final response = await dio.get('/api/Crops');

    debugPrint('GET CROPS STATUS: ${response.statusCode}');
    debugPrint('GET CROPS RESPONSE: ${response.data}');

    return (response.data as List)
        .map((json) => CropResponse.fromJson(json))
        .toList();
  }

  Future<CropResponse> getCropById(int id) async {
    final response = await dio.get('/api/Crops/$id');

    debugPrint('GET CROP BY ID RESPONSE: ${response.data}');

    return CropResponse.fromJson(response.data);
  }

  Future<void> deleteCrop(int id) async {
    await dio.delete('/api/Crops/$id');
  }

  Future<CropResponse> updateCrop(int id, UpdateCropRequest request) async {
    final response = await dio.put('/api/Crops/$id', data: request.toJson());

    return CropResponse.fromJson(response.data);
  }
}
