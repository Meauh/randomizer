import 'package:randomizer/domain/entities/user_preferences.dart';

abstract class IPreferencesRepository {
  Future<UserPreferences> getPreferences();
  Future<void> saveActiveMode(String mode);
  Future<void> clearPreferences();
}