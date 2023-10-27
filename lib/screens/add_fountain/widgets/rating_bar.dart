import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  final int initialRating;

  const RatingBar({super.key, this.initialRating = 0});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              currentRating = index + 1;
            });
          },
          child: Icon(
            index < currentRating ? Icons.star : Icons.star_border_rounded,
            color: index < currentRating ? Colors.yellow : Colors.grey,
            size: 40.0,
          ),
        );
      }),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: RatingBar(
            initialRating: 3,
          ),
        ),
      ),
    ),
  );
}
