/*
// PATH: lib/screens/add_fountain/step_2_select_type_screen.dart

import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart'; // Import fountain type model
import 'package:toerst/screens/add_fountain/add_fountain_screen.dart';
import 'package:toerst/screens/add_fountain/step_1_add_photo_screen.dart';
import 'package:toerst/screens/add_fountain/step_3_rate_fountain.dart';
import 'package:toerst/screens/add_fountain/widgets/fountain_type_selector.dart';

class SelectTypeScreen extends StatefulWidget {
  const SelectTypeScreen({Key? key}) : super(key: key);

  @override
  _SelectTypeScreenState createState() => _SelectTypeScreenState();
}

class _SelectTypeScreenState extends State<SelectTypeScreen> {
  String selectedFountainType =
      'regularDrinkingFountainIcon'; // Initialize to a default value

  // Initialize the list of FountainTypes
  final List<FountainType> fountainTypes = [
    FountainType(
        id: 'regularDrinkingFountainIcon',
        icon: const Icon(Icons.local_drink, size: 40),
        description: 'Select this for stand-up sips directly from the source.',
        title: 'Regular Drinking Fountain'),
    FountainType(
        id: 'fillingStationIcon',
        icon: const Icon(Icons.local_gas_station, size: 40),
        description:
            'Select this for stations to fill up your bottle or container.',
        title: 'Filling Station'),
    // Add More types if needed
  ];

  @override
  Widget build(BuildContext context) {
    return AddFountainScreen(
      content: FountainTypeSelector(
        fountainTypes: fountainTypes, // Pass the list of FountainTypes
        onTypeSelected: (String chosenType) {
          setState(() {
            selectedFountainType = chosenType;
          });
        },
      ),
      currentStep:
          1, // We are on step 2, which translates to 1, since we count from 0
      stepText:
          "Select the type of the fountain.", // Text for this specific step
      nextDestination:
          const RateFountainScreen(), // The screen to navigate to when 'Next' is pressed
      //showPreviousButton: true, // Show the 'Previous' button because this is not the first step
    );
  }
}
*/