// PATH: lib/config/fountain_types.dart

import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart';

class FountainTypes {
  static List<FountainType> values = [
    FountainType(
        id: 'DRINKING',
        icon: const Icon(Icons.local_drink, size: 40),
        description: 'Select this for stand-up sips directly from the source.',
        title: 'Regular Drinking Fountain'),

    FountainType(
        id: 'FILLING',
        icon: const Icon(Icons.local_gas_station, size: 40),
        description:
            'Select this for stations to fill up your bottle or container.',
        title: 'Filling Station'),

    // Add more fountain types as needed
  ];
}
