// PATH: lib/config/draggable_sheet_config/sheet_properties_config.dart

import 'package:flutter/material.dart';
import 'package:toerst/controllers/sheet_controller.dart'; // Import the controller that manages the sheet's position and animations.

/// Enum representing the possible positions of the draggable sheet.
enum SheetPositionState { top, middle, bottom }

/// Class representing the properties of a draggable sheet at a particular state.
class SheetProperties {
  // Icon to display according to the sheet's current state.
  final IconData icon;
  // Descriptive text according to the sheet's current state.
  final String text;
  // Action to perform according to the sheet's state.
  final VoidCallback action;

  // Constructor for defining properties of a sheet state.
  SheetProperties(
      {required this.icon, required this.text, required this.action});
}

/// Class that provides a configuration map for different sheet positions.
class SheetPropertiesConfig {
  // Controller for handling the sheet's position and animations.
  final SheetController sheetController;

  // Constructor that accepts a sheet controller.
  SheetPropertiesConfig(this.sheetController);

  /// Getter that provides a map of sheet positions to their properties.
  /// This map is used to configure UI elements based on the sheet state.
  Map<SheetPositionState, SheetProperties> get propertiesMap {
    return {
      // Configuration for when the sheet is at the top position.
      SheetPositionState.top: SheetProperties(
        icon: Icons.arrow_downward,
        text: "Shrink List",
        // Defines an action to snap the sheet to the middle position.
        action: () => sheetController.snapSheet(sheetController.middlePosition),
      ),
      // Configuration for when the sheet is in the middle position.
      SheetPositionState.middle: SheetProperties(
        icon: Icons.map,
        text: "Expand Map",
        // Defines an action to snap the sheet to the bottom position.
        action: () => sheetController.snapSheet(sheetController.bottomPosition),
      ),
      // Configuration for when the sheet is at the bottom position.
      SheetPositionState.bottom: SheetProperties(
        icon: Icons.list,
        text: "Expand List",
        // Defines an action to snap the sheet back to the middle position.
        action: () => sheetController.snapSheet(sheetController.middlePosition),
      ),
    };
  }
}
