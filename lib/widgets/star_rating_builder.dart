// PATH: lib/widgets/star_rating_builder.dart
import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';

class StarRatingBuilder extends StatelessWidget {
  final double rating;
  final int maxStars;
  final bool displayRatingValue;

  static const int decimalPrecision =
      1; // Defines the number format precision for the rating text.

  const StarRatingBuilder({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.displayRatingValue = true,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> starWidgets = List.generate(maxStars, _buildStar);
    if (displayRatingValue) {
      starWidgets.add(Text(rating.toStringAsFixed(decimalPrecision)));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: starWidgets);
  }

  Widget _buildStar(int index) {
    int fullStars = rating.floor();
    double partialFill = rating % 1;
    bool isFullStar = index < fullStars;
    return isFullStar
        ? Icon(Icons.star, color: starFilledColor)
        : index == fullStars
            ? Stack(children: [
                _PartialStar(percentageFilled: partialFill),
                Icon(Icons.star_border, color: starFilledColor)
              ])
            : Icon(Icons.star_border, color: starFilledColor);
  }
}

class _PartialStar extends StatelessWidget {
  final double percentageFilled;
  final Color fillColor;

  const _PartialStar({
    required this.percentageFilled,
    this.fillColor = starFilledColor,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        // The gradient has two stops at the same point to create a sharp transition.
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [fillColor, fillColor, Colors.transparent],
          stops: [0, percentageFilled, percentageFilled],
        ).createShader(bounds);
      },
      child: const Icon(Icons.star, color: Colors.white),
    );
  }
}
