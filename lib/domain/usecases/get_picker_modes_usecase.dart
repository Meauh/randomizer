// === USE CASES (Business Logic) ===
import 'package:randomizer/domain/entities/picker_mode.dart';
import 'package:randomizer/data/constants/picker_modes.dart';

class GetPickerModesUseCase {
  List<PickerMode> execute() {
    return PickerModes.all;
  }
}