import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart'; // Import the FountainType model
import 'package:toerst/themes/app_colors.dart'; // Import color definitions

// Define a function type for the callback when a type is selected
typedef OnTypeSelected = void Function(String chosenType);

// Create a StatefulWidget named FountainTypeSelector
class FountainTypeSelector extends StatefulWidget {
  final List<FountainType> fountainTypes;
  final OnTypeSelected onTypeSelected;
  final String? initialType; // Add this field to accept an initial type

  const FountainTypeSelector({
    Key? key,
    required this.fountainTypes,
    required this.onTypeSelected,
    this.initialType, // Add this parameter
  }) : super(key: key);

  @override
  _FountainTypeSelectorState createState() => _FountainTypeSelectorState();
}

class _FountainTypeSelectorState extends State<FountainTypeSelector> {
  late String chosenType;

  @override
  void initState() {
    super.initState();
    // Use the initialType if provided, else default to the first type
    chosenType = widget.initialType ?? widget.fountainTypes.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // Grey container
            borderRadius:
                BorderRadius.circular(50.0), // Completely rounded corners
          ),
          child: Wrap(
            spacing: 8.0, // spacing between the icons
            children: widget.fountainTypes.map((FountainType type) {
              bool isSelected = chosenType == type.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    chosenType = type.id;
                    widget.onTypeSelected(chosenType);
                  });
                },
                child: CircleAvatar(
                  backgroundColor:
                      isSelected ? Colors.blue : Colors.transparent,
                  child: Icon(
                    type.icon.icon,
                    color: isSelected ? Colors.white : Colors.black,
                    size: 48.0,
                  ),
                  radius: 30.0, // Adjust as needed
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Display the title and description of the chosen fountain type
        Text(
          widget.fountainTypes
              .firstWhere((type) => type.id == chosenType)
              .title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.fountainTypes
              .firstWhere((type) => type.id == chosenType)
              .description,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}





/*
import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart'; // Import the FountainType model
import 'package:toerst/themes/app_colors.dart'; // Import color definitions

// Define a function type for the callback when a type is selected
typedef OnTypeSelected = void Function(String chosenType);

// Create a StatefulWidget named FountainTypeSelector
class FountainTypeSelector extends StatefulWidget {
  final List<FountainType> fountainTypes;
  final OnTypeSelected onTypeSelected;

  const FountainTypeSelector({
    Key? key,
    required this.fountainTypes,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  _FountainTypeSelectorState createState() => _FountainTypeSelectorState();
}

class _FountainTypeSelectorState extends State<FountainTypeSelector> {
  late String chosenType;

  @override
  void initState() {
    super.initState();
    if (widget.fountainTypes.isNotEmpty) {
      chosenType = widget.fountainTypes.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8.0, // spacing between the icons
          children: widget.fountainTypes.map((FountainType type) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  chosenType = type.id;
                  widget.onTypeSelected(chosenType);
                });
              },
              child: Column(
                children: [
                  Icon(
                    type.icon.icon,
                    color: chosenType == type.id ? Colors.blue : Colors.grey,
                    size: 48.0,
                  ),
                  Text(type.title)
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Display the title and description of the chosen fountain type
        Text(
          widget.fountainTypes
              .firstWhere((type) => type.id == chosenType)
              .title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.fountainTypes
              .firstWhere((type) => type.id == chosenType)
              .description,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart'; // Import the FountainType model
import 'package:toerst/themes/app_colors.dart'; // Import color definitions

// Define a function type for the callback when a type is selected
typedef OnTypeSelected = void Function(String chosenType);

// Create a StatefulWidget named FountainTypeSelector
class FountainTypeSelector extends StatefulWidget {
  final List<FountainType> fountainTypes;
  final OnTypeSelected onTypeSelected;

  const FountainTypeSelector({
    Key? key,
    required this.fountainTypes,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  _FountainTypeSelectorState createState() => _FountainTypeSelectorState();
}

class _FountainTypeSelectorState extends State<FountainTypeSelector> {
  late String chosenType;

  @override
  void initState() {
    super.initState();
    if (widget.fountainTypes.isNotEmpty) {
      chosenType = widget.fountainTypes.first.id;
    }
  }

  // Function to get the title and description of the chosen fountain type
  Map<String, String> getDescriptionAndTitle() {
    final type = widget.fountainTypes.firstWhere(
      (type) => type.id == chosenType,
      orElse: () => FountainType(
        id: '',
        icon: const Icon(Icons.error),
        description: 'Unknown',
        title: 'Error',
      ),
    );
    return {'title': type.title, 'description': type.description};
  }

  @override
  Widget build(BuildContext context) {
    final typeDetails =
        getDescriptionAndTitle(); // Get the title and description

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: chosenType,
          items: widget.fountainTypes.map((FountainType type) {
            return DropdownMenuItem<String>(
              value: type.id,
              child: Text(type.title),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                chosenType = newValue;
              });
              widget.onTypeSelected(
                  chosenType); // notify the parent widget about the selection
            }
          },
        ),
        const SizedBox(height: 16),
        // Display the title of the chosen fountain type
        Text(
          typeDetails['title']!,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(
            height: 8), // Add some spacing between the title and description
        // Display the description of the chosen fountain type
        Text(
          typeDetails['description']!,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
*/


/*

import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart'; // Import the FountainType model
import 'package:toerst/themes/app_colors.dart'; // Import color definitions

// Define a function type for the callback when a type is selected
typedef OnTypeSelected = void Function(String chosenType);

// Create a StatefulWidget named FountainTypeSelector
class FountainTypeSelector extends StatefulWidget {
  final List<FountainType> fountainTypes;
  final OnTypeSelected onTypeSelected;

  const FountainTypeSelector({
    Key? key,
    required this.fountainTypes,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  _FountainTypeSelectorState createState() {
    
    return _FountainTypeSelectorState(
    
  );
  }
}

class _FountainTypeSelectorState extends State<FountainTypeSelector> {
  late String chosenType;

  @override
  void initState() {
    super.initState();
    if (widget.fountainTypes.isNotEmpty) {
      chosenType = widget.fountainTypes.first.id;
    }
  }

  // Function to get the title and description of the chosen fountain type
  Map<String, String> getDescriptionAndTitle() {
    final type = widget.fountainTypes.firstWhere(
      (type) => type.id == chosenType,
      orElse: () => FountainType(
        id: '',
        icon: const Icon(Icons.error),
        description: 'Unknown',
        title: 'Error',
      ),
    );
    return {'title': type.title, 'description': type.description};
  }

  @override
  Widget build(BuildContext context) {
    final typeDetails = getDescriptionAndTitle();  // Get the title and description

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: Container(
            // ... rest of the code ...
          ),
        ),
        const SizedBox(height: 16),
        // Display the title of the chosen fountain type
        Text(
          typeDetails['title']!,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),  // Add some spacing between the title and description
        // Display the description of the chosen fountain type
        Text(
          typeDetails['description']!,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
*/