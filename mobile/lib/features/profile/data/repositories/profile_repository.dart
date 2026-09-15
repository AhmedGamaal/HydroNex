import 'package:hydronex_app/features/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
}
