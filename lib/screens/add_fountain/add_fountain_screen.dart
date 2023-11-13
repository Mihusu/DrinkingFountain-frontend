import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/widgets/back_to_map_button.dart';
import 'package:toerst/screens/add_fountain/widgets/next_button.dart';
import 'package:toerst/screens/add_fountain/widgets/previous_button.dart';
import 'package:toerst/screens/add_fountain/widgets/step_indicator.dart';

class AddFountainScreen extends StatelessWidget {
  final Widget content; // The unique content for each step
  final int currentStep;
  final String stepText; // Text specific to the current step
  final Widget nextDestination; // The destination widget for the 'Next' button
  final bool showPreviousButton;

  const AddFountainScreen({
    Key? key,
    required this.content,
    required this.currentStep,
    required this.stepText,
    required this.nextDestination,
    this.showPreviousButton = true, // Default value is true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: const BackToMapButton(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StepIndicator(
              totalSteps: 5, // Total number of steps
              currentStep: currentStep,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text specific to the current step
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              stepText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          // Invisible container in the middle
          Expanded(
            child: Center(
              child: content,
            ),
          ),
          // Buttons at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showPreviousButton) // Only show if true
                  const PreviousButton(),
                if (showPreviousButton) // Only add spacing if PreviousButton is visible
                  const SizedBox(width: 40.0), // 40.0 distance between buttons
                NextButton(
                  onNext: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            nextDestination,
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
