import 'package:flutter/material.dart';

import 'package:randomizer/domain/entities/picker_result.dart';

class WidgetImagePick extends StatelessWidget {
  final PickerResult? currentResult;

  const WidgetImagePick({super.key, required this.currentResult});

  @override
  Widget build(BuildContext context) {
    // Safety check to ensure we have an ImageResult
    if (currentResult is! ImageResult) {
      return const SizedBox.shrink(); // or return some placeholder widget
    }

    final imageResult = currentResult as ImageResult;

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageResult.url,
                    fit: BoxFit.fitHeight,
                    width: 400,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
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
                SizedBox(height: 8),
                Text(imageResult.caption ?? "No caption !"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
