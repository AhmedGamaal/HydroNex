import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hydronex_app/features/plant_vision/data/models/disease_analysis_model.dart';
import 'package:hydronex_app/features/plant_vision/data/models/plant_image_model.dart';
import 'package:hydronex_app/features/plant_vision/data/models/recommendation_model.dart';

class PlantVisionRemoteDataSource {
  final Dio dio;

  PlantVisionRemoteDataSource({required this.dio});

  Future<PlantImageModel> uploadPlantImage({
    required int cropId,
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'cropId': cropId,
      'file': await MultipartFile.fromFile(imagePath),
    });

    final response = await dio.post('/api/plant-images', data: formData);

    debugPrint('PLANT IMAGE STATUS: ${response.statusCode}');

    debugPrint('PLANT IMAGE RESPONSE: ${response.data}');

    return PlantImageModel.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<DiseaseAnalysisModel> analyzePlantImage({
    required int plantImageId,
  }) async {
    debugPrint('DISEASE ANALYSIS REQUEST - Plant Image ID: $plantImageId');

    final response = await dio.post(
      '/api/disease-analysis/analyze',
      data: {'plantImageId': plantImageId},
    );

    debugPrint('DISEASE ANALYSIS STATUS: ${response.statusCode}');

    debugPrint('DISEASE ANALYSIS RESPONSE: ${response.data}');

    final diseaseAnalysis = DiseaseAnalysisModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );

    debugPrint('DISEASE NAME: ${diseaseAnalysis.diseaseName}');

    debugPrint('CONFIDENCE SCORE: ${diseaseAnalysis.confidenceScore}');

    debugPrint('ANALYSIS RESULT: ${diseaseAnalysis.analysisResult}');

    return diseaseAnalysis;
  }

  Future<RecommendationModel> generateRecommendation({
    required int cropId,
    required int diseaseAnalysisId,
  }) async {
    debugPrint(
      'RECOMMENDATION REQUEST - Crop ID: $cropId, '
      'Disease Analysis ID: $diseaseAnalysisId',
    );

    final response = await dio.post(
      '/api/recommendations/generate',
      data: {'cropId': cropId, 'diseaseAnalysisId': diseaseAnalysisId},
    );

    debugPrint('RECOMMENDATION STATUS: ${response.statusCode}');

    debugPrint('RECOMMENDATION RESPONSE: ${response.data}');

    return RecommendationModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<Map<String, dynamic>> getCropById(int cropId) async {
    debugPrint('GET CROP REQUEST - Crop ID: $cropId');

    final response = await dio.get('/api/crops/$cropId');

    debugPrint('GET CROP BY ID STATUS: ${response.statusCode}');

    debugPrint('GET CROP BY ID RESPONSE: ${response.data}');

    return Map<String, dynamic>.from(response.data);
  }

  Future<List<RecommendationModel>> getRecommendationsByCropId(
    int cropId,
  ) async {
    final response = await dio.get('/api/recommendations/crop/$cropId');

    debugPrint('GET RECOMMENDATIONS STATUS: ${response.statusCode}');

    debugPrint('GET RECOMMENDATIONS RESPONSE: ${response.data}');

    return (response.data as List)
        .map(
          (json) =>
              RecommendationModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  Future<RecommendationModel> getRecommendationById(int id) async {
    final response = await dio.get('/api/recommendations/$id');

    debugPrint('GET RECOMMENDATION STATUS: ${response.statusCode}');

    debugPrint('GET RECOMMENDATION RESPONSE: ${response.data}');

    return RecommendationModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<List<DiseaseAnalysisModel>> getAnalysisByImageId(
    int plantImageId,
  ) async {
    final response = await dio.get('/api/disease-analysis/image/$plantImageId');

    debugPrint('GET ANALYSIS BY IMAGE STATUS: ${response.statusCode}');

    debugPrint('GET ANALYSIS BY IMAGE RESPONSE: ${response.data}');

    return (response.data as List)
        .map(
          (json) =>
              DiseaseAnalysisModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  Future<DiseaseAnalysisModel> getAnalysisById(int id) async {
    final response = await dio.get('/api/disease-analysis/$id');

    debugPrint('GET ANALYSIS BY ID STATUS: ${response.statusCode}');

    debugPrint('GET ANALYSIS BY ID RESPONSE: ${response.data}');

    return DiseaseAnalysisModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<List<PlantImageModel>> getPlantImagesByCropId(int cropId) async {
    final response = await dio.get('/api/plant-images/crop/$cropId');

    debugPrint('GET PLANT IMAGES STATUS: ${response.statusCode}');

    debugPrint('GET PLANT IMAGES RESPONSE: ${response.data}');

    return (response.data as List)
        .map(
          (json) => PlantImageModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  Future<PlantImageModel> getPlantImageById(int imageId) async {
    final response = await dio.get('/api/plant-images/$imageId');

    debugPrint('GET PLANT IMAGE BY ID STATUS: ${response.statusCode}');

    debugPrint('GET PLANT IMAGE BY ID RESPONSE: ${response.data}');

    return PlantImageModel.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<void> deletePlantImage(int imageId) async {
    final response = await dio.delete('/api/plant-images/$imageId');

    debugPrint('DELETE PLANT IMAGE STATUS: ${response.statusCode}');
  }
}
