import 'dart:math';
import 'package:word_generator/word_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:randomizer/core/exceptions/picker_exception.dart';
import 'package:randomizer/domain/entities/picker_result.dart';
import 'package:randomizer/data/constants/api_endpoints.dart';
import 'package:randomizer/data/constants/data_constants.dart';

// === DATA SOURCES (External APIs, Files, etc.) ===
abstract class PickerService {
  Future<PickerResult> pick();
}

// Offline Data Sources
class NumberPickerService implements PickerService {
  final int min;
  final int max;

  const NumberPickerService({this.min = 0, this.max = 99});

  @override
  Future<PickerResult> pick() async {
    final random = Random();
    final value = random.nextInt(max - min + 1) + min;
    return TextResult(value.toString());
  }
}

class ColorPickerService implements PickerService {
  static const _colors = DataConstants.colors;

  @override
  Future<PickerResult> pick() async {
    final random = Random();
    return TextResult(_colors[random.nextInt(_colors.length)]);
  }
}

class EmojiPickerService implements PickerService {
  static const _emojis = DataConstants.emojis;

  @override
  Future<PickerResult> pick() async {
    final random = Random();
    return TextResult(_emojis[random.nextInt(_emojis.length)]);
  }
}

class CoinFlipService implements PickerService {
  @override
  Future<PickerResult> pick() async {
    final random = Random();
    return TextResult(random.nextBool() ? "Heads" : "Tails");
  }
}

class LetterPickerService implements PickerService {
  final WordGenerator wordGenerator = WordGenerator();

  @override
  Future<PickerResult> pick() async {
    return TextResult(wordGenerator.randomName().substring(0, 1));
  }
}

class WordPickerService implements PickerService {
  final WordGenerator wordGenerator = WordGenerator();

  @override
  Future<PickerResult> pick() async {
    return TextResult(wordGenerator.randomVerb());
  }
}

class PasswordPickerService implements PickerService {
  final PasswordGenerator passwordGenerator = PasswordGenerator();

  @override
  Future<PickerResult> pick() async {
    return TextResult(passwordGenerator.generatePassword());
  }
}

// Online Data Sources (Remote APIs)
class QuotePickerService implements PickerService {
  final http.Client _client;

  QuotePickerService([http.Client? client]) : _client = client ?? http.Client();

  @override
  Future<PickerResult> pick() async {
    try {
      final response = await _client
          .get(
            Uri.parse(ApiEndpoints.quotesApi),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuoteResult(
          quote: data['quote'] ?? '',
          author: data['author'] ?? 'Unknown',
        );
      } else {
        throw HttpException('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      throw PickerException('Error fetching quote: $e');
    }
  }
}

class AyaPickerService implements PickerService {
  final http.Client _client;

  AyaPickerService([http.Client? client]) : _client = client ?? http.Client();

  @override
  Future<PickerResult> pick() async {
    try {
      final ayaNumber = Random().nextInt(6236) + 1;
      final response = await _client
          .get(
            Uri.parse('${ApiEndpoints.quranApi}$ayaNumber'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AyaResult(
          text: data['data']['text'] ?? '',
          surahName: data['data']['surah']['name'] ?? '',
          verseNumber: data['data']['numberInSurah'] ?? 0,
        );
      } else {
        throw HttpException('Failed to load aya: ${response.statusCode}');
      }
    } catch (e) {
      throw PickerException('Error fetching aya: $e');
    }
  }
}

class ImagePickerService implements PickerService {
  @override
  Future<PickerResult> pick() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final url = "${ApiEndpoints.imagesApi}?random=$timestamp";
    return ImageResult(url);
  }
}

class CountryPickerService implements PickerService {
  final http.Client _client;
  static const _countryCodes = DataConstants.countryCodes;

  CountryPickerService([http.Client? client])
    : _client = client ?? http.Client();

  @override
  Future<PickerResult> pick() async {
    try {
      final code = _countryCodes[Random().nextInt(_countryCodes.length)];
      final response = await _client
          .get(
            Uri.parse('${ApiEndpoints.countriesApi}$code'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final countryData = data[0];

        String capital = "N/A";
        String currency = "N/A";

        if (code == "275") {
          capital = "Jerusalem|Al-Quds";
          currency = "Shekel";
        } else {
          if (countryData['capital'] != null &&
              countryData['capital'].isNotEmpty) {
            capital = countryData['capital'][0];
          }
          if (countryData['currencies'] != null) {
            final currencies = countryData['currencies'] as Map;
            currency = currencies.values.map((c) => c['name']).join(', ');
          }
        }

        return TextResult(
          '${countryData['name']['common']} ($capital)\n$currency',
        );
      } else {
        throw HttpException('Failed to load country: ${response.statusCode}');
      }
    } catch (e) {
      throw PickerException('Error fetching country: $e');
    }
  }
}

class FlagPickerService implements PickerService {
  final CountryPickerService _countryService;

  FlagPickerService([http.Client? client])
    : _countryService = CountryPickerService(client);

  @override
  Future<PickerResult> pick() async {
    try {
      final code =
          CountryPickerService._countryCodes[Random().nextInt(
            CountryPickerService._countryCodes.length,
          )];
      final response = await _countryService._client
          .get(
            Uri.parse('${ApiEndpoints.countriesApi}$code'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final flagUrl = data[0]['flags']['png'];
        final flagName = data[0]['name']['common'];
        return ImageResult(flagUrl, caption: flagName);
      } else {
        throw HttpException('Failed to load flag: ${response.statusCode}');
      }
    } catch (e) {
      throw PickerException('Error fetching flag: $e');
    }
  }
}

// File Data Source
class CustomListPickerService implements PickerService {
  List<String> _items = [];

  bool get hasItems => _items.isNotEmpty;

  Future<void> loadFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      if (result == null) return;

      String jsonString;
      if (kIsWeb) {
        final bytes = result.files.single.bytes;
        if (bytes == null) throw PickerException('No file data available');
        jsonString = utf8.decode(bytes);
      } else {
        final path = result.files.single.path;
        if (path == null) throw PickerException('No file path available');
        final file = File(path);
        jsonString = await file.readAsString();
      }

      final decoded = json.decode(jsonString);
      if (decoded is List) {
        _items = decoded.cast<String>();
      } else {
        throw PickerException('JSON format not valid (not a list)');
      }
    } catch (e) {
      throw PickerException('Error reading JSON file: $e');
    }
  }

  @override
  Future<PickerResult> pick() async {
    if (_items.isEmpty) {
      await loadFromFile();
    }

    if (_items.isEmpty) {
      throw PickerException('No items available to pick from');
    }

    final random = Random();
    return TextResult(_items[random.nextInt(_items.length)]);
  }
}
