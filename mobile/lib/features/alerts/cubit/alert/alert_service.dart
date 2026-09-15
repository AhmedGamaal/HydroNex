import 'package:dio/dio.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/features/alerts/cubit/alert/alert_cubit.dart';
import 'package:hydronex_app/features/alerts/data/alert_service.dart';

class AlertCubitService {
  static AlertCubit create() {
    return AlertCubit(repository: AlertService.createRepository());
  }
}
