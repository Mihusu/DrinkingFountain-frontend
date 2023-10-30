import 'package:flutter/material.dart';

// CustomTextField Widget
class CustomTextField extends StatefulWidget {
  // Maximum allowed characters for the text field
  final int charLimit;

  // Callback to handle review submission
  final Function(String) onReviewSubmitted;

  // Constructor to initialize the character limit and callback
  const CustomTextField(
      {super.key, required this.charLimit, required this.onReviewSubmitted});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Controller for the text field
  late TextEditingController _controller;

  // Variable to store the current length of the text in the text field
  late int _currentLength;

  // Initialize state
  @override
  void initState() {
    super.initState();
    // Initialize the text controller and current length
    _controller = TextEditingController();
    _currentLength = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the height and width of the container
      height: 200.0,
      width: 300.0,

      // Add border and rounded corners to the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey,
        ),
      ),

      // Padding around the text field
      padding: const EdgeInsets.all(8.0),

      // Use a Column to stack TextField and character count text
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Align text to the end (right)
        children: [
          // The text field
          Expanded(
            child: TextField(
              // Set the text controller
              controller: _controller,

              // Set the maximum allowed characters
              maxLength: widget.charLimit,

              // Allows multiple lines
              maxLines: null,

              // Design of the text field
              decoration: InputDecoration(
                // Padding inside the text field (left and right)
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),

                // Remove default counter text
                counterText: '',

                // Remove default border
                border: InputBorder.none,

                // Set the hint text if the text field is empty
                hintText: _currentLength < 1 ? 'Any additional thought?' : null,
                hintStyle: const TextStyle(color: Colors.grey),
              ),

              // Function to update the current length of the text and review
              onChanged: (text) {
                setState(() {
                  _currentLength = text.length;
                  widget.onReviewSubmitted(text);
                });
              },
            ),
          ),

          // Display current character count and limit
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$_currentLength/${widget.charLimit}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';

// CustomTextField Widget
class CustomTextField extends StatefulWidget {
  // Maximum allowed characters for the text field
  final int charLimit;

  // Constructor to initialize the character limit
  const CustomTextField({super.key, required this.charLimit});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Controller for the text field
  late TextEditingController _controller;

  // Variable to store the current length of the text in the text field
  late int _currentLength;

  // Initialize state
  @override
  void initState() {
    super.initState();
    // Initialize the text controller and current length
    _controller = TextEditingController();
    _currentLength = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the height and width of the container
      height: 200.0, // Increased to accommodate the character count text
      width: 300.0,

      // Add border and rounded corners to the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey,
        ),
      ),

      // Padding around the text field
      padding: const EdgeInsets.all(8.0),

      // Use a Column to stack TextField and character count text
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Align text to the end (right)
        children: [
          // The text field
          Expanded(
            child: TextField(
              // Set the text controller
              controller: _controller,

              // Set the maximum allowed characters
              maxLength: widget.charLimit,

              // Allows multiple lines
              maxLines: null,

              // Design of the text field
              decoration: InputDecoration(
                // Padding inside the text field (left and right)
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),

                // Remove default counter text
                counterText: '',

                // Remove default border
                border: InputBorder.none,

                // Set the hint text if the text field is empty
                hintText: _currentLength < 1 ? 'Any additional thought?' : null,
                hintStyle: const TextStyle(color: Colors.grey),
              ),

              // Function to update the current length of the text
              onChanged: (text) {
                setState(() {
                  _currentLength = text.length;
                });
              },
            ),
          ),

          // Display current character count and limit
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$_currentLength/${widget.charLimit}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/