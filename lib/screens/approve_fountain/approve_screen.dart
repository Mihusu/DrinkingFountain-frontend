import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:toerst/models/viewed_fountain.dart';
import 'package:toerst/services/location_service.dart';
import 'package:toerst/services/network_service.dart';
import 'package:toerst/widgets/standard_button.dart';

// Declare constants for easy adjustments and maintainability
const double imageScaleFactor = 1.2;
const double imagePadding = 22.0;
const double addressPadding = 15.0;
const double cardOuterPadding = 16.0;
const double containerBottomPadding = 125.0;

class ApproveScreen extends StatefulWidget {
  ApproveScreen({Key? key}) : super(key: key);

  @override 
  _ApproveScreen createState() => _ApproveScreen();
}

class _ApproveScreen extends State<ApproveScreen> {
  final NetworkService networkService = NetworkService();
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  MatchEngine? _matchEngine;

  List<CurrentFountain> fountains = [];

  Future<void> _initialize() async {
    final LocationService locationService = LocationService();
    final fountainData = await networkService.getUnapproveFountains();

    List<SwipeItem> swipeItems = [];

    fountains = fountainData;

    for (int i = 0; i < fountains.length; i++) {
      for (int j = 0; j < fountains[i].reviews.length; j++) {
        String username = fountains[i].reviews[j].username;
        String review = fountains[i].reviews[j].text;
        String base64Image = fountains[i].fountainImages[j].base64;
        String address = await locationService.fetchAddress(fountains[i].latitude, fountains[i].longitude) ?? "No Address Found";

        swipeItems.add(SwipeItem(
          content: Content(
            id: fountains[i].id,
            username: username,
            imageBase64Format: base64Image,
            type: fountains[i].type,
            rating: fountains[i].score,
            address: address,
            review: review,
          ),
          likeAction: () async {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Liked ${fountains[i].reviews[j].username}'s fountain request"),
              duration: const Duration(milliseconds: 500),
            ));

            await networkService.approveFountain(fountains[i].id);
            i--;
            j--;
          },
          nopeAction: () async {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Nope ${fountains[i].reviews[j].username}'s fountain request"),
              duration: const Duration(milliseconds: 500),
            ));
            await networkService.unApproveFountain(fountains[i].id);
            i--;
            j--;
          },
        ));
      }
    }

    setState(() {
      _swipeItems.clear();
      _swipeItems.addAll(swipeItems);
      _matchEngine = MatchEngine(swipeItems: _swipeItems);
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_matchEngine == null) {
      // Return a loading indicator or handle the null case accordingly
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Approve fountains'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white, // Set the color of the back button icon
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(cardOuterPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the image at the top
                      SizedBox(
                        height: 500, // Set a fixed height for SwipeCards
                        child: _swipeItems.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "No more drinking fountains to be approved.",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : SwipeCards(
                          matchEngine: _matchEngine!, 
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(imagePadding),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Transform.scale(
                                        scale: imageScaleFactor,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: _decodeImage(_swipeItems[index]
                                                  .content
                                                  .imageBase64Format) ??
                                              Container(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text("By: ${_swipeItems[index].content.username}"),
                                  const SizedBox(height: 20),
                                  Text("${_swipeItems[index].content.type}"),
                                  const SizedBox(height: 20),
                                  _buildStarRating((_swipeItems[index].content.rating).toInt()),
                                  Padding(
                                    padding: const EdgeInsets.all(addressPadding),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _swipeItems[index].content.address ?? 'No fountain found',
                                        textAlign: TextAlign.center, // Align the text center within the Text widget
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text("${_swipeItems[index].content.review ?? 'No review provided.'}"),
                                ],
                              ),
                            );
                          },
                          onStackFinished: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text("No more drinking or filling fountains"),
                              duration: Duration(milliseconds: 500),
                            ));
                          },
                          itemChanged: (SwipeItem item, int index) {
                            print("Fountain request from: ${item.content.username}");
                          },
                          leftSwipeAllowed: true,
                          rightSwipeAllowed: true,
                          fillSpace: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _swipeItems.isEmpty 
          ? Container() // Empty container when _swipeItems is empty
          : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StandardButton(
                onPressed: () async {
                  // Calls unApproveFountain function here
                  await networkService.unApproveFountain(_matchEngine!.currentItem!.content.id);

                  // Perform the nope action
                  _matchEngine!.currentItem!.nope();
                },
                label: "Nope",
                borderColor: Colors.black,
                textColor: Colors.black,
              ),
              StandardButton(
                onPressed: () async {
                  // Calls approveFountain function here
                  await networkService.approveFountain(_matchEngine!.currentItem!.content.id);

                  // Perform the like action
                  _matchEngine!.currentItem!.like();
                },
                label: "Like",
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: containerBottomPadding), // Add some space at the bottom
        ],
      ),
    );
  }
}

class Content {
  final int? id;
  final String? username;
  final String? imageBase64Format; // the image in base 64 format
  final String? type; // type of the fountain
  final double? rating; // rating from flutter_rating_bar
  final double? latitude; // latitude of the fountain
  final double? longitude; // longitude of the fountain
  final String? review; // textual review
  final String? address;

  Content(
      {this.username,
      this.imageBase64Format,
      this.type,
      this.rating,
      this.latitude,
      this.longitude,
      this.review,
      this.address, 
      this.id});
}

Widget _buildStarRating(int rating) {
  return Align(
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the Row horizontally
      children: List.generate(
        rating,
        (index) => const Icon(
          Icons.star,
          color: Colors.black,
        ),
      ),
    ),
  );
}

// This function takes a base64 encoded string and converts it into an Image widget.
// If the string is null or decoding fails, it returns null.
Image? _decodeImage(String? base64String) {
  // Check if the input base64String is null. If it is, return null.
  if (base64String == null) return null;

  try {
    // Attempt to decode the base64 encoded string to a Uint8List,
    // and then create an Image widget from it.
    return Image.memory(base64Decode(base64String));
  } catch (e) {
    // If decoding fails, print an error message and return null.
    print("Failed to decode base64 image: $e");
    return null;
  }
}