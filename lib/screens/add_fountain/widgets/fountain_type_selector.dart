import 'package:flutter/material.dart';
import 'package:toerst/models/fountain_type.dart'; // Import the FountainType model
import 'package:toerst/themes/app_colors.dart'; // Import color definitions

// Define a function type for the callback when a type is selected
typedef OnTypeSelected = void Function(String chosenType);

// Create a StatefulWidget named FountainTypeSelector
class FountainTypeSelector extends StatefulWidget {
  final List<FountainType> fountainTypes;
  final OnTypeSelected onTypeSelected;
  final String? initialType; // Add this line

  const FountainTypeSelector({
    Key? key,
    required this.fountainTypes,
    required this.onTypeSelected,
    this.initialType, // And this line
  }) : super(key: key);

  @override
  _FountainTypeSelectorState createState() => _FountainTypeSelectorState();
}

class _FountainTypeSelectorState extends State<FountainTypeSelector> {
  late String chosenType;

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      // Add this block
      chosenType = widget.initialType!;
    } else if (widget.fountainTypes.isNotEmpty) {
      chosenType = widget.fountainTypes.first.id;
    }
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
                  radius: 30.0,
                  child: Icon(
                    type.icon.icon,
                    color: isSelected ? Colors.white : Colors.black,
                    size: 48.0,
                  ), // Adjust as needed
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
