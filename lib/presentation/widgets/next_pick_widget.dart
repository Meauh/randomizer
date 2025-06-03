import 'package:flutter/material.dart';

class WidgetNextPick extends StatelessWidget {
  final String currentMode;
  const WidgetNextPick({super.key, required this.currentMode});

  @override
  Widget build(BuildContext context) {
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
          'Current mode: ${currentMode}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
