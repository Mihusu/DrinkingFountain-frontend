// Import necessary packages and models
import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart'; // Import the FountainType model

// Define constants for easy adjustment
const double iconSpacing = 8.0; // Spacing between icons
const double iconWidth = 64.0; // Width of icons including padding
const double iconRadius = 32.0; // Radius of the circle avatar
const double iconSize = 48.0; // Size of the icon inside the circle avatar
const double containerPaddingHorizontal =
    10.0; // Horizontal padding of the container
const double containerPaddingVertical =
    8.0; // Vertical padding of the container
const double textSpacing = 16.0; // Spacing between text widgets
const int animationDurationMilliseconds =
    150; // Duration of animation in milliseconds
const double titleDescriptionSpacing =
    16.0; // Spacing between title and description
const double titleFontSize = 24.0; // Font size of title
const double descriptionSpacing =
    8.0; // Spacing between description and next widget
const double descriptionFontSize = 16.0; // Font size of description

// Type definition for the callback function when a type is selected
typedef OnTypeSelected = void Function(String chosenType);

// StatefulWidget to create an interactive fountain type selector
class FountainTypeSelector extends StatefulWidget {
  final List<FountainType> fountainTypes; // List of fountain types
  final OnTypeSelected onTypeSelected; // Callback function for type selection
  final String? initialType; // Optional initial selected type

  // Constructor to initialize the fields
  const FountainTypeSelector({
    super.key,
    required this.fountainTypes,
    required this.onTypeSelected,
    this.initialType,
  });

  // Create the state object for this widget
  @override
  _FountainTypeSelectorState createState() => _FountainTypeSelectorState();
}

// State class for the FountainTypeSelector widget
class _FountainTypeSelectorState extends State<FountainTypeSelector> {
  late String chosenType; // Currently selected type
  double offset = 0; // Horizontal offset for the blue circle

  // Initialize the state object
  @override
  void initState() {
    super.initState();
    // Set the initial chosen type, or default to the first type if none is provided
    chosenType = widget.initialType ?? widget.fountainTypes.first.id;
    // Find the index of the initial chosen type to calculate its offset
    final index =
        widget.fountainTypes.indexWhere((type) => type.id == chosenType);
    // Calculate the initial offset based on the index
    offset = iconWidth * index + iconSpacing * index;
  }

  // Build the UI for this widget
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: containerPaddingHorizontal,
              vertical: containerPaddingVertical),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Stack(
            children: [
              // Animated container to move the blue circle
              AnimatedContainer(
                duration:
                    const Duration(milliseconds: animationDurationMilliseconds),
                // Translate the blue circle horizontally based on the offset
                transform: Matrix4.translationValues(offset, 0, 0),
                child: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: iconRadius,
                ),
              ),
              // Wrap widget to layout the icons horizontally with spacing
              Wrap(
                spacing: iconSpacing,
                children: widget.fountainTypes.map((FountainType type) {
                  bool isSelected = chosenType == type.id;
                  return GestureDetector(
                    onTap: () {
                      // Find the index of the tapped type to calculate its offset
                      final index = widget.fountainTypes.indexOf(type);
                      // Calculate the new offset based on the index
                      final newOffset = iconWidth * index + iconSpacing * index;
                      // Update the state to reflect the new chosen type and offset
                      setState(() {
                        chosenType = type.id;
                        offset = newOffset;
                        widget.onTypeSelected(chosenType);
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: iconRadius,
                      child: Icon(
                        type.icon.icon,
                        color: isSelected ? Colors.white : Colors.black,
                        size: iconSize,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: textSpacing),
        // Display the title of the chosen fountain type
        const SizedBox(height: titleDescriptionSpacing), // Adjusted spacing
        Text(
          widget.fountainTypes
              .firstWhere((type) => type.id == chosenType)
              .title,
          style: const TextStyle(
            fontSize: titleFontSize, // Adjusted font size
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        // Spacing between title and description
        const SizedBox(height: descriptionSpacing), // Adjusted spacing
        // Display the description of the chosen fountain type
        Text(
          widget.fountainTypes
              .firstWhere((type) => type.id == chosenType)
              .description,
          style: const TextStyle(
            fontSize: descriptionFontSize, // Adjusted font size
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
