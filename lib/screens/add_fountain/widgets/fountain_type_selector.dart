import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart'; // Import the FountainType model
import 'package:toerst/themes/app_colors.dart'; // Import color definitions

// Define a function type for the callback when a type is selected
typedef OnTypeSelected = void Function(String chosenType);

// Create a StatefulWidget named FountainTypeSelector
class FountainTypeSelector extends StatefulWidget {
  // Declare the list of available fountain types and the callback function
  final List<FountainType> fountainTypes;
  final OnTypeSelected onTypeSelected;

  // Constructor to initialize the class members
  const FountainTypeSelector({
    Key? key,
    required this.fountainTypes,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  _FountainTypeSelectorState createState() => _FountainTypeSelectorState();
}

// State class for the FountainTypeSelector StatefulWidget
class _FountainTypeSelectorState extends State<FountainTypeSelector> {
  // Variable to store the ID of the chosen fountain type
  late String chosenType;

  // Initialize chosenType to the first item's ID if the list is not empty
  @override
  void initState() {
    super.initState();
    if (widget.fountainTypes.isNotEmpty) {
      chosenType = widget.fountainTypes.first.id;
    }
  }

  // Function to get the description of the chosen fountain type
  String getDescription() {
    return widget.fountainTypes
        .firstWhere(
          // Find the type with the chosen ID
          (type) => type.id == chosenType,
          // Fallback case if the ID is not found
          orElse: () => FountainType(
            id: '',
            icon: const Icon(Icons.error),
            description: 'Unknown',
          ),
        )
        .description;
  }

  @override
  Widget build(BuildContext context) {
    // Build the main UI inside a Column
    return Column(
      // Center the children vertically
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Use IntrinsicWidth to limit the width to its child's needs
        IntrinsicWidth(
          // Container with rounded corners and light gray background
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(100.0),
            ),
            // Create a row of icons for each fountain type
            child: Row(
              // Center the icons horizontally
              mainAxisAlignment: MainAxisAlignment.center,
              // Iterate over each fountain type to create its corresponding icon
              children: widget.fountainTypes.map((FountainType fountainType) {
                return GestureDetector(
                  // Update chosenType on tap and invoke the callback
                  onTap: () {
                    setState(() {
                      chosenType = fountainType.id;
                    });
                    widget.onTypeSelected(chosenType);
                  },
                  // Container to style each individual icon
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Highlight the selected item with a different background color
                      color: chosenType == fountainType.id
                          ? primaryButtonColor
                          : Colors.transparent,
                    ),
                    // Display the icon
                    child: Icon(
                      fountainType.icon.icon,
                      // Change the color depending on whether the item is selected or not
                      color: chosenType == fountainType.id
                          ? Colors.white
                          : Colors.black,
                      size: 40, // Set icon size
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Add some vertical spacing
        const SizedBox(height: 16),
        // Display the description of the chosen fountain type
        Text(
          getDescription(),
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
