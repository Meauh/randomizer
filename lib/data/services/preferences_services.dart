import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesDataService {
  Future<String?> getActiveMode();
  Future<void> saveActiveMode(String mode);
  Future<void> clearAll();
}

class SharedPreferencesDataService implements PreferencesDataService {
  static const String _ActiveModeKey = 'Active_mode';
  
  @override
  Future<String?> getActiveMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ActiveModeKey);
  }
  
  @override
  Future<void> saveActiveMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ActiveModeKey, mode);
  }
  
  @override
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}