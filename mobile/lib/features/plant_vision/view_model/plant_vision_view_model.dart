import 'package:flutter/foundation.dart';
import 'package:hydronex_app/features/plant_vision/data/models/plant_analysis_model.dart';
import 'package:hydronex_app/features/plant_vision/data/repositories/plant_vision_repository.dart';

class PlantVisionViewModel extends ChangeNotifier {
  final PlantVisionRepository repository;

  PlantAnalysisModel? analysis;

  bool isLoading = false;
  String? errorMessage;

  PlantVisionViewModel({required this.repository});

  Future<void> analyzePlant({
    required String imagePath,
    required int cropId,
  }) async {
    if (isLoading) {
      return;
    }

    isLoading = true;
    errorMessage = null;
    analysis = null;

    notifyListeners();

    try {
      analysis = await repository.analyzePlant(
        imagePath: imagePath,
        cropId: cropId,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
