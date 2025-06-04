import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:randomizer/domain/entities/user_preferences.dart';
import 'package:randomizer/domain/usecases/save_active_mode_usecase.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:randomizer/domain/entities/picker_mode.dart';
import 'package:randomizer/domain/entities/picker_result.dart';
import 'package:randomizer/domain/usecases/get_picker_modes_usecase.dart';
import 'package:randomizer/domain/usecases/pick_random_usecase.dart';
import 'package:randomizer/domain/usecases/get_preferences_usecase.dart';
import 'package:randomizer/data/repositories/preferences_repository.dart';
import 'package:randomizer/data/repositories/picker_repository.dart';

import 'package:randomizer/presentation/widgets/next_pick_widget.dart';
import 'package:randomizer/presentation/widgets/image_pick_widget.dart';
import 'package:randomizer/presentation/widgets/text_pick_widget.dart';
import 'package:randomizer/presentation/widgets/picker_mode_widget.dart';

// =========================================================================
// DOMAIN LAYER - Business Logic & Entities (Independent of external concerns)
// =========================================================================
// Files in /domain/
// File in /core/

// =========================================================================
// DATA LAYER - External Data Sources & Repository Implementation
// =========================================================================
// Files in /data/

// =========================================================================
// PRESENTATION LAYER - UI Components, Controllers, and State Management
// =========================================================================

// === UI CONTROLLER (Page State Management) ===
class _PageHomeState extends State<PageHome> {
  // State variables
  PickerResult? _currentResult;
  late String _currentModeId = "flag";
  bool _isLoading = false;

  // Dependencies (injected in real app)
  late final PickRandomUseCase _pickRandomUseCase;
  late final GetPickerModesUseCase _getPickerModesUseCase;
  late final GetPreferencesUseCase _getPreferencesUseCase;
  late final SaveActiveModeUseCase _setActiveModeUseCase;
  late final UserPreferences _userPreferences;

  @override
  void initState() async {
    super.initState();
    // Dependency injection would happen here in a real app
    final pickerRepo = PickerRepository();
    final prefRepo = PreferencesRepository();
    _pickRandomUseCase = PickRandomUseCase(pickerRepo);
    _getPickerModesUseCase = GetPickerModesUseCase();
    _setActiveModeUseCase = SaveActiveModeUseCase(prefRepo);
    _getPreferencesUseCase = GetPreferencesUseCase(prefRepo);
    _loadPreferences();
  }

  // Computed properties
  PickerMode get _currentMode => _getPickerModesUseCase.execute().firstWhere(
    (mode) => mode.id == _currentModeId,
  );

  // Event handlers
  Future<void> _loadPreferences() async {
    _userPreferences = await _getPreferencesUseCase.execute();
    _currentModeId = _userPreferences.activeMode;
  }

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
      _setActiveModeUseCase.execute(modeId);
    });
    Navigator.pop(context);
  }

  Future<void> _copyToClipboard() async {
    if (_currentResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to copy, pick something first.')),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: _currentResult.toString()));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Copied to clipboard!')));
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
      return WidgetNextPick(currentMode: _currentMode.name);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Your pick is:'),
        const SizedBox(height: 16),
        if (_currentResult is ImageResult) ...[
          WidgetImagePick(currentResult: _currentResult),
        ] else ...[
          WidgetTextPick(
            currentResult: _currentResult,
            pressMethod: _copyToClipboard,
          ),
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
        ...modes
            .sublist(0, modes.length - 1)
            .map(
              (mode) => WidgetPickerMode(
                mode: mode,
                status: _currentMode.id == mode.id,
                onTap: () => _changeMode(mode.id),
              ),
            ),
        const Divider(),
        WidgetPickerMode(
          mode: modes.last,
          status: _currentMode.id == modes.last.id,
          onTap: () => _changeMode(modes.last.id),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language_rounded),
          title: const Text('Custom Collections!'),
          subtitle: const Text('Want to try example custom collections?'),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          onTap: () => launchUrl(Uri.parse('https://randomizer-app.carrd.co/')),
        ),
        ListTile(
          leading: const Icon(Icons.shop_rounded),
          title: const Text('Next Pick @Playstore'),
          subtitle: const Text('App Version: 0.1.0'),
          trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          onTap:
              () => launchUrl(
                Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.bit.randomizer',
                ),
              ),
        ),
        ListTile(
          leading: Image.network(
            "https://logo.clearbit.com/github.com",
            fit: BoxFit.fill,
            height: 24,
          ),
          title: Text('Meauh @Github'),
          subtitle: Text("Discover more on the Developer’s Page."),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          onTap:
              () => launchUrl(Uri.parse('https://github.com/Meauh/randomizer')),
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
            tooltip:
                _currentResult != null
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
        icon:
            _isLoading
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
