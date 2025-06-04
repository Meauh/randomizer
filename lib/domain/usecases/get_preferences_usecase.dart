import 'package:randomizer/domain/entities/user_preferences.dart';
import 'package:randomizer/domain/repos/i_preferences_repository.dart';

class GetPreferencesUseCase {
  final IPreferencesRepository repository;
  
  GetPreferencesUseCase(this.repository);
  
  Future<UserPreferences> execute() async {
    return await repository.getPreferences();
  }
}