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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Pick',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
      home: const MyHomePage(title: 'Next Pick'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _randomValue;
  int activeMode = 0;
  List<String> listFromFile = [];

  final wordGenerator = WordGenerator();
  final passGenerator = PasswordGenerator();

  static const List<String> colors = [
    "Red",
    "Blue",
    "Green",
    "Yellow",
    "Black",
    "Purple",
    "Brown",
    "Orange",
  ];
  static const List<(String name, String mode, String description, Icon icon)>
  modes = [
    ("Numbers", "int", "integer number from 0 to 99.", Icon(Icons.pin_rounded)),
    (
      "Order",
      "order",
      "integer number from 1 to 10.",
      Icon(Icons.looks_one_rounded),
    ),
    ("Dice", "dice", "integer number from 1 to 6.", Icon(Icons.casino_rounded)),
    ("Coin", "coin", "heads or tails.", Icon(Icons.paid_rounded)),
    (
      "Colors",
      "color",
      "color from the seven colors.",
      Icon(Icons.palette_rounded),
    ),
    ("Emojis", "emoji", "face emoji.", Icon(Icons.emoji_emotions_rounded)),
    (
      "Letters",
      "caract",
      "letter from the alphabet.",
      Icon(Icons.explicit_rounded),
    ),
    ("Words", "word", "english verbe.", Icon(Icons.fiber_pin_rounded)),
    ("Password", "pass", "password.", Icon(Icons.phonelink_lock_rounded)),
    (
      "Ayas",
      "aya",
      "aya in Arabic from public API.",
      Icon(Icons.menu_book_rounded),
    ),
    (
      "Quote",
      "quote",
      "quote from public API.",
      Icon(Icons.format_quote_rounded),
    ),
    (
      "Images",
      "img",
      "image from public API (uses unsplash).",
      Icon(Icons.panorama),
    ),
    (
      "Countries",
      "country",
      "country (capital) from public API.",
      Icon(Icons.language_rounded),
    ),
    (
      "Items",
      "file",
      "item from your costume file (.json contain list of strings).",
      Icon(Icons.upload_file_rounded),
    ),
    (
      "Videos",
      "yt",
      "video from youtube playlist.",
      Icon(Icons.ondemand_video_rounded),
    ),
  ];

  void _pickRandom() {
    String currentMode = "int";
    currentMode = modes[activeMode].$2;

    //TODO Fix double setState
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _randomValue without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      switch (currentMode) {
        case "int":
          _pickRandomInt();
          break;
        case "order":
          _pickRandomOrder();
          break;
        case "dice":
          _pickRandomDice();
          break;
        case "caract":
          _pickRandomCaracter();
          break;
        case "word":
          _pickRandomWord();
          break;
        case "color":
          _pickRandomColor();
          break;
        case "file":
          _pickRandomFromFile();
          break;
        case "pass":
          _pickRandomPass();
          break;
        case "img":
          _pickRandomImage();
          break;
        case "quote":
          _pickRandomQuote();
          break;
        case "coin":
          _pickRandomCoin();
          break;
        case "emoji":
          _pickRandomEmoji();
          break;
        case "aya":
          _pickRandomAya();
          break;
        case "country":
          _pickRandomCountry();
          break;
        default:
          _pickRandomInt();
          break;
      }
    });
  }

  void _changeMode({int modeIndex = 0}) {
    setState(() {
      activeMode = modeIndex;
      _randomValue = null;
      listFromFile = [];
      Navigator.pop(context);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Picking type set to: ${modes[activeMode].$1}.'),),);
    });
  }

  void _pickRandomOrder() =>
      _randomValue = (Random().nextInt(10) + 1).toString();
  void _pickRandomDice() => _randomValue = (Random().nextInt(6) + 1).toString();
  void _pickRandomInt() => _randomValue = Random().nextInt(100).toString();
  void _pickRandomCaracter() =>
      _randomValue = wordGenerator.randomName().substring(0, 1);
  void _pickRandomWord() => _randomValue = wordGenerator.randomVerb();
  void _pickRandomPass() => _randomValue = passGenerator.generatePassword();
  void _pickRandomColor() =>
      _randomValue = colors[Random().nextInt(colors.length)];
  void _pickRandomCoin() {
    List<String> coinFaces = ["Heads", "Tails"];
    _randomValue = coinFaces[Random().nextInt(2)];
  }

  void _pickRandomEmoji() {
    List<String> faceEmojis = [
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
    _randomValue = faceEmojis[Random().nextInt(faceEmojis.length)];
  }

  Future<void> _pickRandomFromFile() async {
    if (listFromFile.isEmpty) {
      var list = await pickAndLoadStringListFromJson();
      if (list == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("No JSON file selected!")));
        return;
      }
      listFromFile = list.toList(growable: false);
    }
    setState(() {
      _randomValue = listFromFile[Random().nextInt(listFromFile.length)];
    });
  }

  /*Future<void> _pickRandomImage() async {
    //TODO Secure accessKey
    const accessKey = ''; //TODO Access key is missing
    const url = 'https://api.unsplash.com/photos/random?client_id=$accessKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final imageUrl = data['urls']['regular']; // or 'full', 'thumb'

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Random image: $imageUrl')));
        setState(() {
          _randomValue = imageUrl;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Random value: $_randomValue')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load image: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching image: $e')));
    }
  }*/
  Future<void> _pickRandomImage() async {
    // const accessKey = ''; //TODO Access key is missing
    setState(() {
      _randomValue =
          "https://picsum.photos/850?random=${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  Future<void> _pickRandomAya() async {
    String url =
        'https://api.alquran.cloud/v1/ayah/${Random().nextInt(6236) + 1}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ayaBody =
            '${data['data']['text']} \n${data['data']['surah']['name']} : ${data['data']['numberInSurah']}';
        setState(() {
          _randomValue = ayaBody;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load aya: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching aya: $e')));
    }
  }

  Future<void> _pickRandomQuote() async {
    const url = 'https://dummyjson.com/quotes/random';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final quoteBody = '"${data['quote']}" \nBy ${data['author']}';
        setState(() {
          _randomValue = quoteBody;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load quote: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching quote: $e')));
    }
  }

  Future<void> _pickRandomCountry() async {
    List<String> ccn3List = [
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

    String ccn3Pick = ccn3List.elementAt(Random().nextInt(245)); //TODO fix range to 245
    String url = 'https://restcountries.com/v3.1/alpha/${ccn3Pick}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (ccn3Pick == "275") {
          final countryBody =
              '${data[0]['name']['common']} (Jerusalem|Al-Quds) \nShekel';
          setState(() {
            _randomValue = countryBody;
          });
        } else {
          final countryBody =
              '${data[0]['name']['common']} (${data[0]['capital'][0]}) \n${data[0]['currencies'].values.map((c) => c['name']).join(', ')}';
          setState(() {
            _randomValue = countryBody;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load aya: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching aya: $e')));
    }
  }

  Future<List<String>?> pickAndLoadStringListFromJson() async {
    //TODO Save list of strings
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true, // Required for Web to get .bytes
      );

      if (result == null) return null;

      String jsonString;

      if (kIsWeb) {
        // ✅ Web: use .bytes
        final bytes = result.files.single.bytes;
        if (bytes == null) return null;
        jsonString = utf8.decode(bytes);
      } else {
        // ✅ Mobile/Desktop: use file path
        final path = result.files.single.path;
        if (path == null) return null;
        final file = File(path);
        jsonString = await file.readAsString();
      }

      // Decode the JSON string into List<String>
      final decoded = json.decode(jsonString);
      if (decoded is List) {
        return decoded.cast<String>();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("JSON format not valid (not a list)")),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error reading JSON file: $e")));
      return null;
    }
  }

  void copyClipboard() async {
    if (_randomValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing to copy, you have to pick first.'),
        ),
      );
    } else {
      await Clipboard.setData(ClipboardData(text: _randomValue.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your pick copied in the clipboard.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _pickRandom method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: ListTile(
                leading: Icon(Icons.auto_awesome_motion_rounded),
                title: Text('Randomizing Modes'),
                subtitle: Text(
                  'Pick your favorite mode to unlock the new use of randomization.',
                ),
              ),
              //TODO create new list button
            ),

            ListTile(
              leading: modes[0].$4,
              title: Text('${modes[0].$1} mode'),
              subtitle: Text('Random ${modes[0].$3}'),
              selected: activeMode == 0,
              onTap: () => _changeMode(modeIndex: 0),
            ),
            ListTile(
              leading: modes[2].$4,
              title: Text('${modes[2].$1} mode'),
              subtitle: Text('Random ${modes[2].$3}'),
              selected: activeMode == 2,
              onTap: () => _changeMode(modeIndex: 2),
              // enabled: false,
            ),
            ListTile(
              leading: modes[3].$4,
              trailing: Icon(Icons.fiber_new_rounded, color: Colors.redAccent),
              title: Text('${modes[3].$1} mode'),
              subtitle: Text('Random ${modes[3].$3}'),
              selected: activeMode == 3,
              onTap: () => _changeMode(modeIndex: 3),
              // enabled: false,
            ),
            ListTile(
              leading: modes[4].$4,
              title: Text('${modes[4].$1} mode'),
              subtitle: Text('Random ${modes[4].$3}'),
              selected: activeMode == 4,
              onTap: () => _changeMode(modeIndex: 4),
              // enabled: false,
            ),
            ListTile(
              leading: modes[5].$4,
              trailing: Icon(Icons.fiber_new_rounded, color: Colors.redAccent),
              title: Text('${modes[5].$1} mode'),
              subtitle: Text('Random ${modes[5].$3}'),
              selected: activeMode == 5,
              onTap: () => _changeMode(modeIndex: 5),
              // enabled: false,
            ),
            ListTile(
              leading: modes[6].$4,
              title: Text('${modes[6].$1} mode'),
              subtitle: Text('Random ${modes[6].$3}'),
              selected: activeMode == 6,
              onTap: () => _changeMode(modeIndex: 6),
              // enabled: false,
            ),
            ListTile(
              leading: modes[7].$4,
              title: Text('${modes[7].$1} mode'),
              subtitle: Text('Random ${modes[7].$3}'),
              selected: activeMode == 7,
              onTap: () => _changeMode(modeIndex: 7),
              // enabled: false,
            ),
            // Divider(indent: 24, endIndent: 24),
            ListTile(
              leading: modes[8].$4,
              title: Text('${modes[8].$1} mode'),
              subtitle: Text('Random ${modes[8].$3}'),
              selected: activeMode == 8,
              onTap: () => _changeMode(modeIndex: 8),
              // enabled: false,
            ),
            ListTile(
              leading: modes[9].$4,
              trailing: Icon(Icons.fiber_new_rounded, color: Colors.redAccent),
              title: Text('${modes[9].$1} mode'),
              subtitle: Text('Random ${modes[9].$3}'),
              selected: activeMode == 9,
              onTap: () => _changeMode(modeIndex: 9),
              // enabled: false,
            ),
            ListTile(
              leading: modes[10].$4,
              trailing: Icon(Icons.fiber_new_rounded, color: Colors.redAccent),
              title: Text('${modes[10].$1} mode'),
              subtitle: Text('Random ${modes[10].$3}'),
              selected: activeMode == 10,
              onTap: () => _changeMode(modeIndex: 10),
              // enabled: false,
            ),
            ListTile(
              leading: modes[11].$4,
              trailing: Icon(Icons.fiber_new_rounded, color: Colors.redAccent),
              title: Text('${modes[11].$1} mode'),
              subtitle: Text('Random ${modes[11].$3}'),
              selected: activeMode == 11,
              onTap: () => _changeMode(modeIndex: 11),
              // enabled: false,
            ),
            ListTile(
              leading: modes[12].$4,
              trailing: Icon(Icons.fiber_new_rounded, color: Colors.redAccent),
              title: Text('${modes[12].$1} mode'),
              subtitle: Text('Random ${modes[12].$3}'),
              selected: activeMode == 12,
              onTap: () => _changeMode(modeIndex: 12),
              // enabled: false,
            ),
            ListTile(
              leading: modes[13].$4,
              title: Text('${modes[13].$1} mode'),
              subtitle: Text('Random ${modes[13].$3}'),
              selected: activeMode == 13,
              onTap: () => _changeMode(modeIndex: 13),
              // enabled: false,
            ),
            Divider(indent: 12, endIndent: 12),
            ListTile(
              leading: Icon(Icons.language_rounded),
              title: Text('Costume Collections !'),
              subtitle: Text(
                "Want to try some exmaple of costume collections and it's power.",
              ),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap:
                  () => launchUrl(
                    Uri.parse('https://github.com/Meauh/randomizer'),
                  ),
              /*onLongPress: () async {
                await Clipboard.setData(
                  ClipboardData(text: 'test'),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Test.', textAlign: TextAlign.center,),
                  ),
                );
              },*/
            ),
            // Divider(indent: 12, endIndent: 12),
            ListTile(
              leading: Icon(Icons.shop_rounded),
              title: Text('Next Pick @Playstore'),
              subtitle: Text("App Version: 0.1.0"),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap:
                  () => launchUrl(
                    Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.bit.randomizer',
                    ),
                  ),
              onLongPress: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text:
                        'https://play.google.com/store/apps/details?id=com.bit.randomizer',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Playstore link copied in the clipboard.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            // Divider(indent: 24, endIndent: 24),
            ListTile(
              leading: Image.network(
                "https://logo.clearbit.com/github.com",
                fit: BoxFit.fill,
                height: 24,
              ),
              title: Text('Meauh @Github'),
              subtitle: Text("Discover more on the Developer’s Page."),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () => launchUrl(Uri.parse('https://github.com/Meauh')),
              onLongPress: () async {
                await Clipboard.setData(
                  ClipboardData(text: 'https://github.com/Meauh'),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Dev github link copied in the clipboard.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.content_paste_rounded),
            tooltip:
                (_randomValue != null)
                    ? 'Copy to clipboard'
                    : 'Pick something first',
            onPressed: (_randomValue != null) ? copyClipboard : null,
          ),
          /*IconButton(
            icon: modes[activeMode].$4,
            tooltip: '${modes[activeMode].$1} mode',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${modes[activeMode].$1} mode: pick random ${modes[activeMode].$3}',
                  ),
                ),
              );
            },
            onLongPress: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Open side menu to change modes.'),
                ),
              );
            },
          ),*/
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_randomValue == null) ...[
              Text(
                '"Roll the Dice"\n To get your next pick.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              // Text('${modes[activeMode].$1} type',textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelMedium,              ),
            ] else ...[
              const Text('Your pick is:'),
              if (modes[activeMode].$2 == "img") ...[
                _randomValue != null
                    ? Image.network(
                      _randomValue!,
                      fit: BoxFit.fill,
                      height: 500,
                    )
                    : const Text('No image yet'),
              ] else ...[
                InkWell(
                  onLongPress: () => copyClipboard(),
                  child: Text(
                    _randomValue ?? 'Not picked',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickRandom,
        tooltip: "Random ${modes[activeMode].$1}",
        label: Text('Pick'),
        icon: modes[activeMode].$4,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
