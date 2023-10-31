/*
import 'package:audioplayers/audioplayers.dart';
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
    final player = AudioPlayer();
    final nextButtonAudio = AssetSource("sounds/next_button_sound.mp3");

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackToMapButton(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: SizedBox(
                        width: 250, // Set to desired width
                        child: StepIndicator(
                          totalSteps: 5,
                          currentStep: currentStep,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Remaining Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  stepText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
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
                      onNext: () async {
                        print("\n_____________________________________\n");
                        await player.play(nextButtonAudio);
                        await Future.delayed(Duration(seconds: 1));
                        print("\n_____________________________________\n");
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                nextDestination,
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return child;
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
      ),
    );
  }
}
*/