
import 'package:randomizer/domain/repos/i_preferences_repository.dart';
import 'package:randomizer/domain/entities/user_preferences.dart';

class SaveActiveModeUseCase {
  final IPreferencesRepository repository;
  
  SaveActiveModeUseCase(this.repository);
  
  Future<void> execute(String mode) async {
    await repository.saveActiveMode(mode);
  }
}