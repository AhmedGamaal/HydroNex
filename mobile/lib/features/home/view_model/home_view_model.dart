import 'package:hydronex_app/features/home/data/models/alert_model.dart';
import 'package:hydronex_app/features/home/data/models/crop_model.dart';

class HomeViewModel {
  List<CropModel> crops = [];

  List<AlertModel> alerts = [
    AlertModel(
      iconName: 'ph',
      message: 'PH level is above the optimal range',
      status: 'Critical',
      recommendation: 'Lower pH using pH-solution',
      time: 'Today · 10:15 AM',
    ),
    AlertModel(
      iconName: 'light',
      message: 'Light intensity is below optimal range',
      status: 'Warning',
      recommendation: 'Increase light intensity',
      time: 'Today · 10:15 AM',
    ),
    AlertModel(
      iconName: 'light',
      message: 'Light intensity is below optimal range',
      status: 'Resolved',
      recommendation: 'Increase light intensity',
      time: 'Today · 10:15 AM',
    ),
  ];

  void addCrop(CropModel crop) {
    crops.add(crop);
  }
}
