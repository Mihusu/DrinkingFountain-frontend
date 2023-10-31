// PATH: lib/screens/add_fountain/multi_step_form.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toerst/models/fountain.dart';
import 'package:toerst/screens/add_fountain/form_overview.dart';
import 'package:toerst/screens/add_fountain/widgets/address_input_widget.dart';
import 'package:toerst/screens/add_fountain/widgets/address_typing_field.dart';
import 'package:toerst/screens/add_fountain/widgets/back_to_map_button.dart';
import 'package:toerst/screens/add_fountain/widgets/capture_photo_button.dart';
import 'package:toerst/screens/add_fountain/widgets/fountain_rating_bar.dart';
import 'package:toerst/screens/add_fountain/widgets/fountain_type_selector.dart';
import 'package:toerst/screens/add_fountain/widgets/step_indicator.dart';
import 'package:toerst/screens/add_fountain/widgets/text_input_field.dart';
import 'package:toerst/screens/add_fountain/widgets/navigation_buttons.dart'; // Import navigation buttons
import 'package:toerst/config/fountain_types.dart';

/// [MultiStepForm] is a widget that encapsulates a multi-step form process.
/// Each step has its own content and navigation controls.
class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  bool isNextButtonEnabled = false; // Initialize as false
  int currentStep = 0;
  String selectedFountainType = 'regularDrinkingFountainIcon';
  List<Widget>? stepContents;

  // Fountain field variables
  String? selectedAddress; // For display in FormOverview
  String? imageBase64Format;
  String? type;
  double? rating;
  double? latitude;
  double? longitude;
  String? review;

  // callback methods
  void _setImage(String image) {
    setState(() {
      imageBase64Format = image;
      if (currentStep == 0) {
        isNextButtonEnabled = true;
      }
      stepContents![0] =
          CapturePhotoButton(imageBase64: image, onImageCaptured: _setImage);
    });
  }

  void _setType(String chosenType) {
    setState(() {
      type = chosenType;
    });
  }

  void _setRating(double givenRating) {
    setState(() {
      rating = givenRating;
    });
  }

  void _setLocation(String description, double lat, double lon) {
    setState(() {
      selectedAddress = description;
      latitude = lat;
      longitude = lon;
      if (currentStep == 3) {
        // Check if it's the fourth step (0-indexed)
        isNextButtonEnabled = true; // Enable the button after inserting address
      }
    });
  }

  void _setReview(String userReview) {
    setState(() {
      review = userReview;
    });
  }

  // Adjust the behavior of the Next button based on the current step and data
  void _handleNextButton() {
    if (currentStep == 0 && imageBase64Format == null) {
      isNextButtonEnabled = false; // Ensure button is disabled if no image
    } else if (currentStep == 3 &&
        (selectedAddress == null || latitude == null || longitude == null)) {
      isNextButtonEnabled = false; // Ensure button is disabled if no address
    } else {
      isNextButtonEnabled = true; // Enable in all other scenarios
    }
  }

  @override
  void initState() {
    super.initState();

    stepContents = [
      CapturePhotoButton(imageBase64: null, onImageCaptured: _setImage),
      FountainTypeSelector(
        fountainTypes: FountainTypes.values,
        onTypeSelected: _setType,
      ),

      FountainRatingBar(onRatingChanged: _setRating),
      //AddressSearchWidget(onLocationSelected: _setLocation),
      AddressInputWidget(
          onAddressSelected: _setLocation), // Use the widget here
      CustomTextField(charLimit: 200, onReviewSubmitted: _setReview),
      // ... Add more steps as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(),
              _buildStepContent(),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
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
              width: 250,
              child: StepIndicator(
                totalSteps: stepContents!.length,
                currentStep: currentStep,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Step ${currentStep + 1}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: stepContents![currentStep],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    _handleNextButton(); // Call this function to manage the Next button's state
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentStep > 0)
            PreviousButton(
              onPressed: () {
                setState(() {
                  currentStep--;
                });
              },
            ),
          if (currentStep > 0) const SizedBox(width: 40.0),
          NextButton(
            enabled: isNextButtonEnabled, // Pass the button state to NextButton
            onNext: () {
              if (currentStep < stepContents!.length - 1) {
                setState(() {
                  currentStep++;
                });
              } else {
                // All steps are complete
                Fountain fountainData = Fountain(
                  imageBase64Format: imageBase64Format ?? "Unknown",
                  type: type ?? "Unknown",
                  rating: rating ?? 0.0,
                  latitude: latitude ?? 0.0,
                  longitude: longitude ?? 0.0,
                  review: review ?? "Unknown",
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        FormOverview(fountainData: fountainData),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
