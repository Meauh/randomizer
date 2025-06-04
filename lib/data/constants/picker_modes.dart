// === CONSTANTS (Configuration Data) ===
import 'package:flutter/material.dart';
import 'package:randomizer/domain/entities/picker_mode.dart';

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
    /*PickerMode(
      id: 'order',
      name: 'Order',
      description: 'integer number from 1 to 10',
      category: PickerCategory.offline,
      icon: Icons.looks_one_rounded,
    ),*/
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