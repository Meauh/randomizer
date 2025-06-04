import 'package:randomizer/domain/entities/user_preferences.dart';
import 'package:randomizer/domain/repos/i_preferences_repository.dart';

import 'package:randomizer/data/constants/data_constants.dart';
import 'package:randomizer/data/services/preferences_services.dart';

class PreferencesRepository implements IPreferencesRepository {
  final PreferencesDataService _service = SharedPreferencesDataService();
  static const String _defaultMode = DataConstants.defaultPickerMode;
  
  
  @override
  Future<UserPreferences> getPreferences() async {
    try {
      final activeMode = await _service.getActiveMode();
      return UserPreferences(
        activeMode: activeMode ?? _defaultMode,
      );
    } catch (e) {
      // Return default preferences if there's an error
      return const UserPreferences(activeMode: _defaultMode);
    }
  }
  
  @override
  Future<void> saveActiveMode(String mode) async {
    await _service.saveActiveMode(mode);
  }
  
  @override
  Future<void> clearPreferences() async {
    await _service.clearAll();
  }
}