// === ENTITIES (Core Business Objects) ===
import 'package:flutter/material.dart';

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
