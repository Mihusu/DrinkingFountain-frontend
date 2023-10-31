// PATH: lib/screens/add_fountain/multi_step_form.dart

import 'package:flutter/material.dart';
import 'package:toerst/models/fountain.dart';
import 'package:toerst/screens/add_fountain/form_overview_screen.dart';
import 'package:toerst/screens/add_fountain/widgets/address_input_widget.dart';
import 'package:toerst/screens/add_fountain/widgets/back_to_map_button.dart';
import 'package:toerst/screens/add_fountain/widgets/capture_photo_button.dart';
import 'package:toerst/screens/add_fountain/widgets/fountain_rating_bar.dart';
import 'package:toerst/screens/add_fountain/widgets/fountain_type_selector.dart';
import 'package:toerst/screens/add_fountain/widgets/step_indicator.dart';
import 'package:toerst/screens/add_fountain/widgets/text_input_field.dart';
import 'package:toerst/screens/add_fountain/widgets/navigation_buttons.dart';
import 'package:toerst/config/fountain_types.dart';

// Define a StatefulWidget named MultiStepForm
class MultiStepForm extends StatefulWidget {
  // Default constructor
  const MultiStepForm({super.key});

  // Create state for this widget
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

// Define the state class for MultiStepForm
class _MultiStepFormState extends State<MultiStepForm> {
  // Variable to manage the "Next" button's enabled state
  bool isNextButtonEnabled = false;

  // Variable to manage the current step index
  int currentStep = 0;

  // Variables to hold user input data for each step
  String? selectedAddress;
  String? imageBase64Format;
  String? type;
  double? rating;
  double? latitude;
  double? longitude;
  String? review;

  // Callback to set the image base64 string
  void _setImage(String image) {
    setState(() {
      imageBase64Format = image;
      if (currentStep == 0) {
        isNextButtonEnabled = true;
      }
    });
  }

  // Callback to set the fountain type
  void _setType(String chosenType) {
    setState(() {
      type = chosenType;
    });
  }

  // Callback to set the fountain rating
  void _setRating(double givenRating) {
    setState(() {
      rating = givenRating;
    });
  }

  // Callback to set the location data
  void _setLocation(String description, double lat, double lon) {
    setState(() {
      selectedAddress = description;
      latitude = lat;
      longitude = lon;
      if (currentStep == 3) {
        isNextButtonEnabled = true;
      }
    });
  }

  // Callback to set the review text
  void _setReview(String userReview) {
    setState(() {
      review = userReview;
    });
  }

  // Function to handle the "Next" button's enabled state
  void _handleNextButton() {
    // Check conditions to enable or disable the "Next" button
    if (currentStep == 0 && imageBase64Format == null) {
      isNextButtonEnabled = false;
    } else if (currentStep == 3 &&
        (selectedAddress == null || latitude == null || longitude == null)) {
      isNextButtonEnabled = false;
    } else {
      isNextButtonEnabled = true;
    }
  }

  // Function to build the custom AppBar
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Back button
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackToMapButton(),
            ],
          ),
          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: SizedBox(
              width: 250,
              child: StepIndicator(
                totalSteps: 5,
                currentStep: currentStep,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build the step content
  Widget _buildStepContent(List<Widget> stepContents) {
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
        // Display the current step's widget
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: stepContents[currentStep],
          ),
        ),
      ],
    );
  }

  // Function to build the navigation buttons
  Widget _buildNavigationButtons() {
    // Handle the "Next" button's enabled state
    _handleNextButton();
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "Previous" button
          if (currentStep > 0)
            PreviousButton(
              onPressed: () {
                setState(() {
                  currentStep--;
                });
              },
            ),
          // Spacer
          if (currentStep > 0) const SizedBox(width: 40.0),
          // "Next" button
          NextButton(
            enabled: isNextButtonEnabled,
            onNext: () {
              if (currentStep < 4) {
                setState(() {
                  currentStep++;
                });
              } else {
                // Create Fountain object and navigate
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

  // Main build function
  @override
  Widget build(BuildContext context) {
    // Create list of step widgets
    List<Widget> stepContents = [
      CapturePhotoButton(
          imageBase64: imageBase64Format, onImageCaptured: _setImage),
      FountainTypeSelector(
        initialType: type,
        fountainTypes: FountainTypes.values,
        onTypeSelected: _setType,
      ),
      FountainRatingBar(
        initialRating: rating,
        onRatingChanged: _setRating,
      ),
      AddressInputWidget(onAddressSelected: _setLocation),
      CustomTextField(charLimit: 200, onReviewSubmitted: _setReview),
    ];

    // Return the main Scaffold
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(),
              _buildStepContent(stepContents),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
