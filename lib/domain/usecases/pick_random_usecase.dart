// === USE CASES (Business Logic) ===
import 'package:randomizer/domain/repos/i_picker_repository.dart';
import 'package:randomizer/domain/entities/picker_result.dart';

class PickRandomUseCase {
  final IPickerRepository _repository;

  PickRandomUseCase(this._repository);

  Future<PickerResult> execute(String modeId) async {
    return await _repository.pick(modeId);
  }
}