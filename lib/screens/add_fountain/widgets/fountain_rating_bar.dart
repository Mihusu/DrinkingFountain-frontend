import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart'; // For Material widgets
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // For the RatingBar widget

// Define a StatefulWidget named FountainRatingBar
class FountainRatingBar extends StatefulWidget {
  // Callback function to handle rating change
  final Function(double) onRatingChanged;

  // Optional initial rating to display
  final double? initialRating;

  // Constructor for the widget
  const FountainRatingBar({
    super.key,
    required this.onRatingChanged,
    this.initialRating, // Initialize the optional parameter
  });

  // Create state for this widget
  @override
  _FountainRatingBar createState() => _FountainRatingBar();
}

// Define the state class for FountainRatingBar
class _FountainRatingBar extends State<FountainRatingBar> {
  // Variable to hold the current rating
  late double _rating;

  // Initialize the state
  @override
  void initState() {
    super.initState();
    // Set _rating to the initialRating if provided, otherwise default to 0.0
    _rating = widget.initialRating ?? 0.0;
  }

  // Build the UI
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _rating, // Set the initial rating
      minRating: 1, // Minimum rating
      direction: Axis.horizontal, // Use a horizontal layout
      allowHalfRating: false, // Do not allow half ratings
      itemCount: 5, // Number of rating stars
      itemPadding:
          const EdgeInsets.symmetric(horizontal: 3.0), // Padding between stars
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.black, // Star color
      ),
      // Callback when the rating is updated
      onRatingUpdate: (rating) {
        // Update the state to reflect the new rating
        setState(() {
          _rating = rating;
        });

        // Invoke the callback to notify the parent widget about the rating change
        widget.onRatingChanged(_rating);

        // Debug print the rating (only in debug mode)
        if (kDebugMode) {
          print(_rating);
        }
      },
    );
  }
}
