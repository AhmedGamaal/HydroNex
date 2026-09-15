import 'package:hydronex_app/features/plant_vision/data/models/plant_analysis_model.dart';

abstract class PlantVisionRepository {
  Future<PlantAnalysisModel> analyzePlant({
    required String imagePath,
    required int cropId,
  });
}
