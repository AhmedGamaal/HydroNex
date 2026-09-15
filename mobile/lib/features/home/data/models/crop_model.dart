import 'package:hydronex_app/features/crops/data/models/crop_response.dart';

class CropModel {
  final int id;
  final String name;
  final String cropType;
  final String image;
  final String batchId;
  final String location;
  final String notes;
  final String variety;
  final String currentDay;
  final String totalDays;
  final String progress;
  final String startDate;
  final String expectedHarvestDate;
  final String growthStage;
  final String status;

  const CropModel({
    required this.id,
    required this.name,
    required this.cropType,
    required this.image,
    required this.batchId,
    required this.location,
    required this.notes,
    required this.variety,
    required this.currentDay,
    required this.totalDays,
    required this.progress,
    required this.startDate,
    required this.expectedHarvestDate,
    required this.growthStage,
    required this.status,
  });

  factory CropModel.fromResponse(CropResponse crop) {
    String getCropImage(String cropType) {
      switch (cropType.toLowerCase()) {
        case 'basil':
          return 'assets/images/basil.png';
        case 'cucumber':
          return 'assets/images/cucumber.png';
        case 'lettuce':
          return 'assets/images/lettuce.png';
        case 'strawberry':
          return 'assets/images/strawberry.png';
        case 'tomato':
          return 'assets/images/tomato.png';
        default:
          return 'assets/images/no_image.png';
      }
    }

    return CropModel(
      id: crop.id,
      name: crop.name,
      cropType: crop.cropType,
      image: getCropImage(crop.cropType),
      batchId: crop.batchId,
      location: crop.location,
      notes: crop.notes,
      variety: crop.variety,
      currentDay: crop.currentDay.toString(),
      totalDays: crop.cycleDuration.toString(),
      progress: crop.progressPercentage.toString(),
      startDate: crop.plantingDate,
      expectedHarvestDate: crop.expectedHarvestDate,
      growthStage: crop.growthStage,
      status: crop.status,
    );
  }
}
