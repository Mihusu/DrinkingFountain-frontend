// PATH: lib/widgets/star_rating_builder.dart
import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart'; // Importing star colors

/// StarRatingBuilder is a widget that builds a row of star icons based on a rating value.
class StarRatingBuilder extends StatelessWidget {
  final double rating; // The current rating value.
  final int maxStars; // The maximum number of stars to display.
  final bool
      displayRatingValue; // Flag to control the display of the rating value.

  static const Color starColor = starFilledColor; // Color for the star icons.
  static const int decimalPrecision = 1; // Precision for the rating text.

  const StarRatingBuilder({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.displayRatingValue = true,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a list of widgets that will represent the stars.
    List<Widget> starWidgets =
        List.generate(maxStars, (index) => _buildStar(index));

    // If the flag is true, add the textual representation of the rating to the list.
    if (displayRatingValue) {
      starWidgets.add(Text(rating.toStringAsFixed(decimalPrecision)));
    }

    // The row of stars (and optional rating text) is returned as the widget's main build.
    return Row(mainAxisSize: MainAxisSize.min, children: starWidgets);
  }

  /// Builds an individual star, determining if it should be full, empty, or partially filled.
  Widget _buildStar(int index) {
    int fullStars = rating.floor(); // Number of completely filled stars.
    double partialFill =
        rating % 1; // Amount of partial fill for the last star, if any.
    bool isFullStar = index < fullStars; // Should this star be fully filled?
    bool isPartialStar = index == fullStars &&
        partialFill > 0; // Is this the partially filled star?

    // Returns the appropriate star icon based on its filled status.
    return isFullStar
        ? const Icon(Icons.star, color: starColor) // Full star
        : isPartialStar
            ? Stack(children: [
                // Partial star uses a stack to overlay the filled part on top of an outlined icon.
                PartialStar(percentageFilled: partialFill),
                const Icon(Icons.star_border_outlined, color: starColor)
              ])
            : const Icon(Icons.star_border, color: starColor); // Empty star
  }
}

/// PartialStar is a widget used to create the partially filled star effect.
class PartialStar extends StatelessWidget {
  final double
      percentageFilled; // The percentage of the star that should appear filled.
  final Color fillColor; // The color used for the filled portion of the star.

  static const Color baseStarColor =
      Colors.white; // The background color of the star.

  const PartialStar({
    required this.percentageFilled,
    this.fillColor = starFilledColor, // Default fill color.
  });

  @override
  Widget build(BuildContext context) {
    // ShaderMask is used to apply a gradient shader that creates the fill effect.
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        // Gradient from full color to transparent to create the partial fill effect.
        return LinearGradient(
          stops: [0, percentageFilled, percentageFilled],
          colors: [fillColor, fillColor, Colors.transparent],
        ).createShader(bounds);
      },
      child: const Icon(
        Icons.star,
        color:
            baseStarColor, // This is the base color, will be "under" the shader.
      ),
    );
  }
}
