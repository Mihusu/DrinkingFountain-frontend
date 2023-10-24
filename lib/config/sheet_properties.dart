// lib/config/sheet_properties.dart
import 'package:flutter/material.dart';

enum SheetPositionState {
  top,
  middle,
  bottom,
}

class SheetProperties {
  final IconData icon;
  final String text;
  final void Function() action;

  SheetProperties({
    required this.icon,
    required this.text,
    required this.action,
  });
}