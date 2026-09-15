import 'package:flutter/foundation.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/features/profile/data/models/profile_model.dart';
import 'package:hydronex_app/features/profile/data/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileRepository repository;
  final TokenStorage tokenStorage;

  ProfileModel? profile;

  bool isLoading = false;
  String? errorMessage;

  ProfileViewModel({required this.repository, required this.tokenStorage});

  Future<void> loadProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await repository.getProfile();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await tokenStorage.deleteToken();
  }
}
