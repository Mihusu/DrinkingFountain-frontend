import 'package:flutter/material.dart';
import 'package:toerst/screens/add_fountain/widgets/back_to_map_button.dart';
import 'package:toerst/screens/add_fountain/widgets/next_button.dart';
import 'package:toerst/screens/add_fountain/widgets/previous_button.dart';
import 'package:toerst/screens/add_fountain/widgets/step_indicator.dart';

class AddFountainScreen extends StatelessWidget {
  final Widget content;
  final int currentStep;
  final String stepText;
  final Widget nextDestination;
  final bool showPreviousButton;

  const AddFountainScreen({
    Key? key,
    required this.content,
    required this.currentStep,
    required this.stepText,
    required this.nextDestination,
    this.showPreviousButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: BackToMapButton(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StepIndicator(
              totalSteps: 5,
              currentStep: currentStep,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                stepText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            Container(
              // Replaced Expanded with Container
              height: MediaQuery.of(context).size.height *
                  0.5, // Set a fixed height
              child: Center(
                child: content,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showPreviousButton) const PreviousButton(),
                  if (showPreviousButton) const SizedBox(width: 40.0),
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
      ),
    );
  }
}
