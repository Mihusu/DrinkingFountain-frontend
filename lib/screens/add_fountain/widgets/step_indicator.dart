import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepIndicator({super.key, 
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _line(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            return SizedBox(
              width: 22.0, // Set to the width of the largest dot
              height: 22.0, // Set to the height of the largest dot
              child: Center(
                child: index == currentStep ? _currentStepDot() : _defaultDot(),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _currentStepDot() {
    return Container(
      width: 22.0,
      height: 22.0,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue, // Replace with your border color
          width: 6.0,
        ),
      ),
    );
  }

  Widget _defaultDot() {
    return Container(
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
      height: 4.0,
      color: Colors.black,
      margin: const EdgeInsets.symmetric(
          horizontal:
              11.0), // Adjust margin to align with the center of the dots
    );
  }
}
