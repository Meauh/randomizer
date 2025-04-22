import 'package:flutter/material.dart';
import 'dart:math';
import 'package:word_generator/word_generator.dart';

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

  final wordGenerator = WordGenerator();

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
    (
      "Numbers",
      "int",
      "integer number from 0 to 99.",
      Icon(Icons.sixty_fps_rounded),
    ),
    (
      "Order",
      "order",
      "integer number from 1 to 10.",
      Icon(Icons.looks_one_rounded),
    ),
    ("Dice", "dice", "integer number from 1 to 6.", Icon(Icons.casino_rounded)),
    (
      "Letters",
      "caract",
      "letter from the alphabet.",
      Icon(Icons.title_rounded),
    ),
    ("Words", "word", "english verbe.", Icon(Icons.raw_on_rounded)),
    (
      "Colors",
      "color",
      "color from the seven colors.",
      Icon(Icons.palette_rounded),
    ),
    ("Images", "img", "image from pintrest.", Icon(Icons.landscape_rounded)),
    (
      "Videos",
      "vid",
      "video from youtube playlist.",
      Icon(Icons.ondemand_video_rounded),
    ),
    ("Coin", "coin", "heads or tails.", Icon(Icons.paid_rounded)),
  ];

  void _pickRandom() {
    String currentMode = "int";
    currentMode = modes[activeMode].$2;

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
        default:
          _pickRandomInt();
          break;
      }
    });
  }

  void _changeMode({int modeIndex = 0}) {
    setState(() {
      activeMode = modeIndex;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Picking type set to: ${modes[activeMode].$1}.',
          ),
        ),
      );
    });
  }

  void _pickRandomOrder() =>
      _randomValue = (Random().nextInt(10) + 1).toString();
  void _pickRandomDice() => _randomValue = (Random().nextInt(6) + 1).toString();
  void _pickRandomInt() => _randomValue = Random().nextInt(100).toString();
  void _pickRandomCaracter() =>
      _randomValue = wordGenerator.randomName().substring(0, 1);
  void _pickRandomWord() => _randomValue = wordGenerator.randomVerb();
  void _pickRandomColor() =>
      _randomValue = colors[Random().nextInt(colors.length)];

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
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.amberAccent),
              child: Text('Picking Type'),
            ),
            ListTile(
              leading: modes[0].$4,
              title: Text(modes[0].$1),
              subtitle: Text('Random ${modes[0].$3}'),
              selected: activeMode == 0,
              onTap: () => _changeMode(modeIndex: 0),
            ),
            ListTile(
              leading: modes[1].$4,
              title: Text(modes[1].$1),
              subtitle: Text('Random ${modes[1].$3}'),
              selected: activeMode == 1,
              onTap: () => _changeMode(modeIndex: 1),
              // enabled: false,
            ),
            ListTile(
              leading: modes[2].$4,
              title: Text(modes[2].$1),
              subtitle: Text('Random ${modes[2].$3}'),
              selected: activeMode == 2,
              onTap: () => _changeMode(modeIndex: 2),
              // enabled: false,
            ),
            ListTile(
              leading: modes[3].$4,
              title: Text(modes[3].$1),
              subtitle: Text('Random ${modes[3].$3}'),
              selected: activeMode == 3,
              onTap: () => _changeMode(modeIndex: 3),
              // enabled: false,
            ),
            ListTile(
              leading: modes[4].$4,
              title: Text(modes[4].$1),
              subtitle: Text('Random ${modes[4].$3}'),
              selected: activeMode == 4,
              onTap: () => _changeMode(modeIndex: 4),
              // enabled: false,
            ),
            ListTile(
              leading: modes[5].$4,
              title: Text(modes[5].$1),
              subtitle: Text('Random ${modes[5].$3}'),
              selected: activeMode == 5,
              onTap: () => _changeMode(modeIndex: 5),
              // enabled: false,
            ),
            ListTile(
              leading: modes[6].$4,
              title: Text(modes[6].$1),
              subtitle: Text('Random ${modes[6].$3}'),
              selected: activeMode == 6,
              onTap: () => _changeMode(modeIndex: 6),
              enabled: false,
            ),
            ListTile(
              leading: modes[7].$4,
              title: Text(modes[7].$1),
              subtitle: Text('Random ${modes[7].$3}'),
              selected: activeMode == 7,
              onTap: () => _changeMode(modeIndex: 7),
              enabled: false,
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
          ),
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
                'Press the random button \n "Roll the Dice"',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ] else ...[
              const Text('Your pick is:'),
              Text(
                _randomValue ?? 'Not picked',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickRandom,
        tooltip: 'Pick Random',
        child: const Icon(Icons.casino_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
