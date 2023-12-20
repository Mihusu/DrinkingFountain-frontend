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

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  bool isNextButtonEnabled = false;
  int currentStep = 0;
  String? selectedAddress;
  String? imageBase64Format;
  String? type;
  double? rating;
  double? latitude;
  double? longitude;
  String? review;

  void _setImage(String image) {
    setState(() {
      imageBase64Format = image;
      if (currentStep == 0) {
        isNextButtonEnabled = true;
      }
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
        isNextButtonEnabled = true;
      }
    });
  }

  void _setReview(String userReview) {
    setState(() {
      review = userReview;
    });
  }

  void _handleNextButton() {
    if (currentStep == 0 && imageBase64Format == null) {
      isNextButtonEnabled = false;
    } else if (currentStep == 3 &&
        (selectedAddress == null || latitude == null || longitude == null)) {
      isNextButtonEnabled = false;
    } else if (currentStep == 2 && rating == null) {
      isNextButtonEnabled = false;
    } else {
      isNextButtonEnabled = true;
    }
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
                totalSteps: 5,
                currentStep: currentStep,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: stepContents[currentStep],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    _handleNextButton();
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
            enabled: isNextButtonEnabled,
            onNext: () {
              if (currentStep < 4) {
                setState(() {
                  currentStep++;
                });
              } else {
                Fountain fountainData = Fountain(
                  imageBase64Format: imageBase64Format ?? "Unknown",
                  type: type ?? "DRINKING",
                  rating: rating ?? 0.0,
                  latitude: latitude ?? 0.0,
                  longitude: longitude ?? 0.0,
                  review: review ?? "",
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

  @override
  Widget build(BuildContext context) {
    List<Widget> stepContents = [
      CapturePhotoButton(
          imageBase64: imageBase64Format, onImageCaptured: _setImage),
      FountainTypeSelector(
        initialType: type,
        fountainTypes: FountainTypes.values,
        onTypeSelected: _setType,
      ),
      FountainRatingBar(
        initialRating: rating, // Pass the initial rating here
        onRatingChanged: _setRating,
      ),
      AddressInputWidget(onAddressSelected: _setLocation),
      CustomTextField(charLimit: 200, onReviewSubmitted: _setReview),
    ];

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
