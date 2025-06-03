// === REPOSITORY INTERFACE (Domain Contract) ===
import 'package:randomizer/domain/entities/picker_result.dart';
import 'package:randomizer/data/services/picker_services.dart'; //TODO understand why core needs non core (services)

abstract class IPickerRepository {
  Future<PickerResult> pick(String modeId);
  PickerService? getService(String modeId);
}