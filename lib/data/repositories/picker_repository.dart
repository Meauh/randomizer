// === REPOSITORY IMPLEMENTATION ===
import 'package:randomizer/domain/entities/picker_result.dart';
import 'package:randomizer/core/exceptions/picker_exception.dart';
import 'package:randomizer/domain/repos/i_picker_repository.dart';
import 'package:randomizer/data/services/picker_services.dart';

class PickerRepository implements IPickerRepository {
  final Map<String, PickerService> _services = {};

  PickerRepository() {
    _initializeServices();
  }

  void _initializeServices() {
    // Offline services
    _services['numbers'] = const NumberPickerService();
    _services['order'] = const NumberPickerService(min: 1, max: 10);
    _services['dice'] = const NumberPickerService(min: 1, max: 6);
    _services['coin'] = CoinFlipService();
    _services['colors'] = ColorPickerService();
    _services['emojis'] = EmojiPickerService();
    _services['letters'] = LetterPickerService();
    _services['words'] = WordPickerService();
    _services['password'] = PasswordPickerService();

    // Online services
    _services['ayas'] = AyaPickerService();
    _services['quote'] = QuotePickerService();
    _services['images'] = ImagePickerService();
    _services['countries'] = CountryPickerService();
    _services['flags'] = FlagPickerService();

    // File-based services
    _services['custom'] = CustomListPickerService();
  }

  @override
  Future<PickerResult> pick(String modeId) async {
    final service = _services[modeId];
    if (service == null) {
      throw PickerException('Unknown picker mode: $modeId');
    }
    return await service.pick();
  }

  @override
  PickerService? getService(String modeId) => _services[modeId];
}