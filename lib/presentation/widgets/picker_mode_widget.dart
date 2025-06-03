import 'package:flutter/material.dart';

import 'package:randomizer/domain/entities/picker_mode.dart';

class WidgetPickerMode extends StatelessWidget {
  final PickerMode mode;
  final bool status;
  final VoidCallback onTap;

  const WidgetPickerMode({
    required this.mode,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(mode.icon),
      title: Text('${mode.name} mode'),
      subtitle: Text('Random ${mode.description}'),
      selected: status,
      onTap: onTap,
      trailing:
          mode.isNew
              ? const Icon(Icons.fiber_new_outlined, color: Colors.redAccent)
              : null,
      // tileColor: Theme.of(context).colorScheme.background,
    );
  }
}
