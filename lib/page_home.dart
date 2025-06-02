import 'package:flutter/material.dart';
import 'dart:math';
import 'package:word_generator/word_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// =========================================================================
// DOMAIN LAYER - Business Logic & Entities (Independent of external concerns)
// =========================================================================

// === ENTITIES (Core Business Objects) ===
abstract class PickerResult {
  const PickerResult();
}

class TextResult extends PickerResult {
  final String value;
  const TextResult(this.value);
  
  @override
  String toString() => value;
}

class ImageResult extends PickerResult {
  final String url;
  final String? caption;
  const ImageResult(this.url, {this.caption});
}

class QuoteResult extends PickerResult {
  final String quote;
  final String author;
  const QuoteResult({required this.quote, required this.author});
  
  @override
  String toString() => '"$quote"\n—$author';
}

class AyaResult extends PickerResult {
  final String text;
  final String surahName;
  final int verseNumber;
  const AyaResult({
    required this.text,
    required this.surahName,
    required this.verseNumber,
  });
  
  @override
  String toString() => '$text\n$surahName : $verseNumber';
}

enum PickerCategory { offline, online, custom }

class PickerMode {
  final String id;
  final String name;
  final String description;
  final PickerCategory category;
  final IconData icon;
  final bool isEnabled;
  final bool isNew;

  const PickerMode({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    this.isEnabled = true,
    this.isNew = false,
  });
}

// === DOMAIN EXCEPTIONS ===
class PickerException implements Exception {
  final String message;
  const PickerException(this.message);
  
  @override
  String toString() => 'PickerException: $message';
}

// === REPOSITORY INTERFACE (Domain Contract) ===
abstract class IPickerRepository {
  Future<PickerResult> pick(String modeId);
  PickerService? getService(String modeId);
}

// === USE CASES (Business Logic) ===
class PickRandomUseCase {
  final IPickerRepository _repository;
  
  PickRandomUseCase(this._repository);
  
  Future<PickerResult> execute(String modeId) async {
    return await _repository.pick(modeId);
  }
}

class GetPickerModesUseCase {
  List<PickerMode> execute() {
    return PickerModes.all;
  }
}

class LoadCustomListUseCase {
  final CustomListPickerService _service;
  
  LoadCustomListUseCase(this._service);
  
  Future<void> execute() async {
    await _service.loadFromFile();
  }
}

// =========================================================================
// DATA LAYER - External Data Sources & Repository Implementation
// =========================================================================

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
  static const _colors = [
    "Red", "Blue", "Green", "Yellow", 
    "Black", "Purple", "Brown", "Orange"
  ];
  
  @override
  Future<PickerResult> pick() async {
    final random = Random();
    return TextResult(_colors[random.nextInt(_colors.length)]);
  }
}

class EmojiPickerService implements PickerService {
  static const _emojis = [
      "😀",
      "😃",
      "😄",
      "😁",
      "😆",
      "😅",
      "😂",
      "🤣",
      "😊",
      "😇",
      "🙂",
      "🙃",
      "😉",
      "😌",
      "😍",
      "🥰",
      "😘",
      "😗",
      "😙",
      "😚",
      "😋",
      "😛",
      "😝",
      "😜",
      "🤪",
      "🤨",
      "🧐",
      "🤓",
      "😎",
      "🥸",
      "🤩",
      "🥳",
      "😏",
      "😒",
      "😞",
      "😔",
      "😟",
      "😕",
      "🙁",
      "☹️",
      "😣",
      "😖",
      "😫",
      "😩",
      "🥺",
      "😢",
      "😭",
      "😤",
      "😠",
      "😡",
      "🤬",
      "🤯",
      "😳",
      "🥵",
      "🥶",
      "😱",
      "😨",
      "😰",
      "😥",
      "😓",
      "🤗",
      "🤔",
      "🫢",
      "🤭",
      "🫣",
      "🤫",
      "🤥",
      "😶",
      "😐",
      "😑",
      "😬",
      "🙄",
      "😯",
      "😦",
      "😧",
      "😮",
      "😲",
      "🥱",
      "😴",
      "🤤",
      "😪",
      "😵",
      "😵‍💫",
      "🤐",
      "🥴",
      "🤢",
      "🤮",
      "🤧",
      "😷",
      "🤒",
      "🤕",
      "🤑",
      "🤠",
      "😈",
      "👿",
      "👹",
      "👺",
      "💀",
      "☠️",
      "👻",
      "👽",
      "👾",
      "🤖",
      "😺",
      "😸",
      "😹",
      "😻",
      "😼",
      "😽",
      "🙀",
      "😿",
      "😾",
    ];
  
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
      final response = await _client.get(
        Uri.parse('https://dummyjson.com/quotes/random'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
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
      final response = await _client.get(
        Uri.parse('https://api.alquran.cloud/v1/ayah/$ayaNumber'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
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
    final url = "https://picsum.photos/850?random=$timestamp";
    return ImageResult(url);
  }
}

class CountryPickerService implements PickerService {
  final http.Client _client;
  static const _countryCodes = [
      "004",
      "008",
      "012",
      "016",
      "020",
      "024",
      "028",
      "031",
      "032",
      "036",
      "040",
      "044",
      "048",
      "050",
      "051",
      "052",
      "056",
      "060",
      "064",
      "068",
      "070",
      "072",
      "074",
      "076",
      "084",
      "086",
      "090",
      "092",
      "096",
      "100",
      "104",
      "108",
      "112",
      "116",
      "120",
      "124",
      "132",
      "136",
      "140",
      "144",
      "148",
      "152",
      "156",
      "158",
      "162",
      "166",
      "170",
      "174",
      "175",
      "178",
      "180",
      "184",
      "188",
      "191",
      "192",
      "196",
      "203",
      "204",
      "208",
      "212",
      "214",
      "218",
      "222",
      "226",
      "231",
      "232",
      "233",
      "234",
      "238",
      "239",
      "242",
      "246",
      "250",
      "254",
      "258",
      "260",
      "262",
      "266",
      "268",
      "270",
      "275",
      "276",
      "288",
      "292",
      "296",
      "300",
      "304",
      "308",
      "312",
      "316",
      "320",
      "324",
      "328",
      "332",
      "334",
      "336",
      "340",
      "344",
      "348",
      "352",
      "356",
      "360",
      "364",
      "368",
      "372",
      "380",
      "384",
      "388",
      "392",
      "398",
      "400",
      "404",
      "408",
      "410",
      "414",
      "417",
      "418",
      "422",
      "426",
      "428",
      "430",
      "434",
      "438",
      "440",
      "442",
      "446",
      "450",
      "454",
      "458",
      "462",
      "466",
      "470",
      "474",
      "478",
      "480",
      "484",
      "492",
      "496",
      "498",
      "499",
      "500",
      "504",
      "508",
      "512",
      "516",
      "520",
      "524",
      "528",
      "531",
      "533",
      "534",
      "535",
      "540",
      "548",
      "554",
      "558",
      "562",
      "566",
      "570",
      "574",
      "578",
      "580",
      "581",
      "583",
      "584",
      "585",
      "586",
      "591",
      "598",
      "600",
      "604",
      "608",
      "612",
      "616",
      "620",
      "624",
      "626",
      "630",
      "634",
      "638",
      "642",
      "643",
      "646",
      "652",
      "654",
      "659",
      "660",
      "662",
      "663",
      "666",
      "670",
      "674",
      "678",
      "682",
      "686",
      "688",
      "690",
      "694",
      "702",
      "703",
      "704",
      "705",
      "706",
      "710",
      "716",
      "724",
      "728",
      "729",
      "732",
      "740",
      "744",
      "748",
      "752",
      "756",
      "760",
      "762",
      "764",
      "768",
      "772",
      "776",
      "780",
      "784",
      "788",
      "792",
      "795",
      "796",
      "798",
      "800",
      "804",
      "807",
      "818",
      "826",
      "831",
      "832",
      "833",
      "834",
      "840",
      "850",
      "854",
      "858",
      "860",
      "862",
      "876",
      "882",
      "887",
      "894",
    ];
  
  CountryPickerService([http.Client? client]) : _client = client ?? http.Client();
  
  @override
  Future<PickerResult> pick() async {
    try {
      final code = _countryCodes[Random().nextInt(_countryCodes.length)];
      final response = await _client.get(
        Uri.parse('https://restcountries.com/v3.1/alpha/$code'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final countryData = data[0];
        
        String capital = "N/A";
        String currency = "N/A";
        
        if (code == "275") {
          capital = "Jerusalem|Al-Quds";
          currency = "Shekel";
        } else {
          if (countryData['capital'] != null && countryData['capital'].isNotEmpty) {
            capital = countryData['capital'][0];
          }
          if (countryData['currencies'] != null) {
            final currencies = countryData['currencies'] as Map;
            currency = currencies.values
                .map((c) => c['name'])
                .join(', ');
          }
        }
        
        return TextResult(
          '${countryData['name']['common']} ($capital)\n$currency'
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
      final code = CountryPickerService._countryCodes[
        Random().nextInt(CountryPickerService._countryCodes.length)
      ];
      final response = await _countryService._client.get(
        Uri.parse('https://restcountries.com/v3.1/alpha/$code'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final flagUrl = data[0]['flags']['png'];
        return ImageResult(flagUrl);
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

// === REPOSITORY IMPLEMENTATION ===
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

// =========================================================================
// PRESENTATION LAYER - UI Components, Controllers, and State Management
// =========================================================================

// === CONSTANTS (Configuration Data) ===
class PickerModes {
  static const List<PickerMode> all = [
    // Offline modes
    PickerMode(
      id: 'numbers',
      name: 'Numbers',
      description: 'integer number from 0 to 99',
      category: PickerCategory.offline,
      icon: Icons.pin_rounded,
    ),
    PickerMode(
      id: 'order',
      name: 'Order',
      description: 'integer number from 1 to 10',
      category: PickerCategory.offline,
      icon: Icons.looks_one_rounded,
    ),
    PickerMode(
      id: 'dice',
      name: 'Dice',
      description: 'integer number from 1 to 6',
      category: PickerCategory.offline,
      icon: Icons.casino_rounded,
    ),
    PickerMode(
      id: 'coin',
      name: 'Coin',
      description: 'heads or tails',
      category: PickerCategory.offline,
      icon: Icons.paid_rounded,
      isNew: true,
    ),
    PickerMode(
      id: 'colors',
      name: 'Colors',
      description: 'color from the seven colors',
      category: PickerCategory.offline,
      icon: Icons.palette_rounded,
    ),
    PickerMode(
      id: 'emojis',
      name: 'Emojis',
      description: 'face emoji',
      category: PickerCategory.offline,
      icon: Icons.emoji_emotions_rounded,
      isNew: true,
    ),
    PickerMode(
      id: 'letters',
      name: 'Letters',
      description: 'letter from the alphabet',
      category: PickerCategory.offline,
      icon: Icons.explicit_rounded,
    ),
    PickerMode(
      id: 'words',
      name: 'Words',
      description: 'english verb',
      category: PickerCategory.offline,
      icon: Icons.fiber_pin_rounded,
    ),
    PickerMode(
      id: 'password',
      name: 'Password',
      description: 'secure password',
      category: PickerCategory.offline,
      icon: Icons.phonelink_lock_rounded,
    ),
    
    // Online modes
    PickerMode(
      id: 'ayas',
      name: 'Ayas',
      description: 'aya in Arabic from public API',
      category: PickerCategory.online,
      icon: Icons.menu_book_rounded,
      isNew: true,
    ),
    PickerMode(
      id: 'quote',
      name: 'Quote',
      description: 'quote from public API',
      category: PickerCategory.online,
      icon: Icons.format_quote_rounded,
      isNew: true,
    ),
    PickerMode(
      id: 'images',
      name: 'Images',
      description: 'image from public API',
      category: PickerCategory.online,
      icon: Icons.panorama,
      isNew: true,
    ),
    PickerMode(
      id: 'countries',
      name: 'Countries',
      description: 'country with capital from public API',
      category: PickerCategory.online,
      icon: Icons.language_rounded,
      isNew: true,
    ),
    PickerMode(
      id: 'flags',
      name: 'Flags',
      description: 'flag from public API',
      category: PickerCategory.online,
      icon: Icons.flag_rounded,
      isNew: true,
    ),
    
    // Custom modes
    PickerMode(
      id: 'custom',
      name: 'Custom Items',
      description: 'item from your custom file (.json)',
      category: PickerCategory.custom,
      icon: Icons.upload_file_rounded,
    ),
  ];
}

// === UI CONTROLLER (Page State Management) ===
class _PageHomeState extends State<PageHome> {
  // State variables
  PickerResult? _currentResult;
  String _currentModeId = 'numbers';
  bool _isLoading = false;
  
  // Dependencies (injected in real app)
  late final PickRandomUseCase _pickRandomUseCase;
  late final GetPickerModesUseCase _getPickerModesUseCase;
  
  @override
  void initState() {
    super.initState();
    // Dependency injection would happen here in a real app
    final repository = PickerRepository();
    _pickRandomUseCase = PickRandomUseCase(repository);
    _getPickerModesUseCase = GetPickerModesUseCase();
  }
  
  // Computed properties
  PickerMode get _currentMode => 
    _getPickerModesUseCase.execute().firstWhere((mode) => mode.id == _currentModeId);

  // Event handlers
  Future<void> _pickRandom() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _pickRandomUseCase.execute(_currentModeId);
      setState(() {
        _currentResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _changeMode(String modeId) {
    setState(() {
      _currentModeId = modeId;
      _currentResult = null;
    });
    Navigator.pop(context);
  }

  Future<void> _copyToClipboard() async {
    if (_currentResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing to copy, pick something first.'),
        ),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: _currentResult.toString()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!')),
      );
    }
  }

  // UI Components
  Widget _buildResultDisplay() {
    if (_isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Picking...'),
        ],
      );
    }

    if (_currentResult == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '"Roll the Dice"\nTo get your next pick.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Current mode: ${_currentMode.name}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Your pick is:'),
        const SizedBox(height: 16),
        if (_currentResult is ImageResult) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              (_currentResult as ImageResult).url,
              fit: BoxFit.fitHeight,
              width: 400,
              loadingBuilder: (context, child, loadingProgress) { //TODO add loading state
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 48),
                        Text('Failed to load image'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ] else ...[
          Expanded(
  child: GestureDetector(
    onLongPress: _copyToClipboard,
    child: Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            _currentResult.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    ),
  ),
)
        ],
      ],
    );
  }

  Widget _buildDrawerContent() {
    final modes = _getPickerModesUseCase.execute();
    
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Next Pick',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your picking mode',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        ...modes.map((mode) => ListTile(
          leading: Icon(mode.icon),
          title: Text('${mode.name} mode'),
          subtitle: Text('Random ${mode.description}'),
          selected: _currentModeId == mode.id,
          trailing: mode.isNew 
            ? const Icon(Icons.fiber_new_rounded, color: Colors.redAccent)
            : null,
          onTap: () => _changeMode(mode.id),
        )),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language_rounded),
          title: const Text('Custom Collections!'),
          subtitle: const Text('Want to try example custom collections?'),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          onTap: () => launchUrl(
            Uri.parse('https://github.com/Meauh/randomizer'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.shop_rounded),
          title: const Text('Next Pick @Playstore'),
          subtitle: const Text('App Version: 0.1.0'),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          onTap: () => launchUrl(
            Uri.parse(
              'https://play.google.com/store/apps/details?id=com.bit.randomizer',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: _buildDrawerContent()),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Next Pick"),
        actions: [
          IconButton(
            icon: const Icon(Icons.content_paste_rounded),
            tooltip: _currentResult != null
                ? 'Copy to clipboard'
                : 'Pick something first',
            onPressed: _currentResult != null ? _copyToClipboard : null,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: _buildResultDisplay()),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _pickRandom,
        tooltip: "Random ${_currentMode.name}",
        label: Text(_isLoading ? 'Picking...' : 'Pick'),
        icon: _isLoading 
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(_currentMode.icon),
      ),
    );
  }
}

// === UI WIDGET (Page Definition) ===
class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}