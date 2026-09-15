import 'package:hydronex_app/features/plant_vision/data/datasources/plant_vision_remote_data_source.dart';
import 'package:hydronex_app/features/plant_vision/data/models/plant_analysis_model.dart';
import 'package:hydronex_app/features/plant_vision/data/models/recommendation_model.dart';
import 'package:hydronex_app/features/plant_vision/data/repositories/plant_vision_repository.dart';

class PlantVisionRepositoryImpl implements PlantVisionRepository {
  final PlantVisionRemoteDataSource remoteDataSource;

  PlantVisionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PlantAnalysisModel> analyzePlant({
    required String imagePath,
    required int cropId,
  }) async {
    // 1. Get the crop information
    final crop = await remoteDataSource.getCropById(cropId);

    // 2. Upload image
    final plantImage = await remoteDataSource.uploadPlantImage(
      cropId: cropId,
      imagePath: imagePath,
    );

    // 3. Analyze uploaded image
    final diseaseAnalysis = await remoteDataSource.analyzePlantImage(
      plantImageId: plantImage.id,
    );

    // 4. Generate recommendation
    RecommendationModel? recommendation;

    try {
      recommendation = await remoteDataSource.generateRecommendation(
        cropId: cropId,
        diseaseAnalysisId: diseaseAnalysis.id,
      );
    } catch (_) {
      // Analysis succeeded even if recommendation generation fails.
      recommendation = null;
    }

    // 5. Get real crop information
    final String plantType = crop['cropType']?.toString() ?? 'Unknown';

    final String growthStage = crop['growthStage']?.toString() ?? 'Unknown';

    final String age = crop['currentDay'] != null
        ? 'Day ${crop['currentDay']}'
        : 'Unknown';

    // System is not provided by the Crop API.
    const String system = 'Hydroponic';

    return PlantAnalysisModel(
      cropId: cropId,
      diseaseAnalysis: diseaseAnalysis,
      recommendationData: recommendation,
      plantType: plantType,
      growthStage: growthStage,
      age: age,
      system: system,
    );
  }
}
