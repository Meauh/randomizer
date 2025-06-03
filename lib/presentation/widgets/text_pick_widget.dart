import 'package:flutter/material.dart';

import 'package:randomizer/domain/entities/picker_result.dart';

class WidgetTextPick extends StatelessWidget {
  final PickerResult? currentResult;
  final VoidCallback pressMethod;

  const WidgetTextPick({super.key, required this.currentResult, required this.pressMethod});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onLongPress: pressMethod,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                currentResult.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
