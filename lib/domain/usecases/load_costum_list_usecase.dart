// === USE CASES (Business Logic) ===
import 'package:randomizer/data/services/picker_services.dart';

class LoadCustomListUseCase {
  final CustomListPickerService _service;

  LoadCustomListUseCase(this._service);

  Future<void> execute() async {
    await _service.loadFromFile();
  }
}