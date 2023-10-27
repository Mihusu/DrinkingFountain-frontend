import 'package:flutter/material.dart';
import 'package:toerst/themes/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  StepIndicator({
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          // Render the dots
          return index ~/ 2 == currentStep ? _currentStepDot() : _defaultDot();
        } else {
          // Render the line in between the dots
          return _line();
        }
      }),
    );
  }

  Widget _currentStepDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      width: 22.0,
      height: 22.0,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(
          color:
              primaryButtonColor, // Make sure 'primaryButtonColor' is defined in this scope
          width: 6.0,
        ),
      ),
    );
  }

  Widget _defaultDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      width: 10.0,
      height: 10.0,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _line() {
    return Container(
      width: 40.0,
      height: 4.0,
      color: Colors.black,
    );
  }
}
