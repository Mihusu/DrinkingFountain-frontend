// PATH: lib/models/fountain_type.dart

import 'package:flutter/material.dart';

class FountainType {
  final String id; // Unique identifier
  final Icon icon; // The associated icon
  final String description; // The description
  final String title;

  FountainType(
      {required this.id,
      required this.icon,
      required this.description,
      required this.title});
}
