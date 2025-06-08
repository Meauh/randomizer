import 'package:flutter/material.dart';

import 'package:randomizer/domain/entities/picker_result.dart';

class WidgetLocalImagePick extends StatelessWidget {
  final PickerResult? currentResult;

  const WidgetLocalImagePick({super.key, required this.currentResult});

  @override
  Widget build(BuildContext context) {
    // Safety check to ensure we have an LocalImageResult
    if (currentResult is! LocalImageResult) {
      return const SizedBox.shrink(); // or return some placeholder widget
    }

    final localimageResult = currentResult as LocalImageResult;

    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localimageResult.caption ?? "No caption !",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'lib/presentation/assets/images/${localimageResult.name}',
                    fit: BoxFit.fitHeight,
                    width: 400,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
