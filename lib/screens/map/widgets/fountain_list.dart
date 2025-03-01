// fountain_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toerst/models/nearest_fountain.dart';
import 'package:toerst/services/maps_launcher_service.dart';
import 'package:toerst/widgets/star_rating_builder.dart';

import '../../view_fountain/view_fountain_screen.dart';

class FountainList extends StatelessWidget {
  final Color listedItemColor;
  final Color listedItemBorderColor;
  final Color listedItemTextColor;
  final List<NearestFountain> nearestFountains;

  const FountainList({
    super.key,
    required this.listedItemColor,
    required this.listedItemBorderColor,
    required this.listedItemTextColor,
    required this.nearestFountains,
  });

  @override
  Widget build(BuildContext context) {
    return _buildListView(context);
  }

  ListView _buildListView(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 70.0),
      itemCount: nearestFountains.length,
      itemBuilder: (BuildContext context, int index) {
        final item = nearestFountains[index];
        return _buildListItem(context, item);
      },
    );
  }

  GestureDetector _buildListItem(
      BuildContext context, NearestFountain fountainData) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: listedItemColor,
          borderRadius: BorderRadius.circular(90.0),
          border: Border.all(color: listedItemBorderColor, width: 1.0),
        ),
        child: _buildListItemRow(fountainData),
      ),
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FocusFountainScreen(fountainId: fountainData.id),
          ),
        )
      },
    );
  }

  Row _buildListItemRow(fountainData) {
    final double latitude = fountainData.latitude;
    final double longitude = fountainData.longitude;

    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 25.0,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 4.0), // Adjust the value as needed
            child: SvgPicture.asset(
              "assets/Icons/Regular_Drinking_Fountain_Icon.svg",
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              semanticsLabel: 'Regular Drinking Fountain',
            ),
          ),
        ),
        Expanded(child: _buildListItemTextColumn(fountainData)),
        _buildDirectionsButton(latitude, longitude),
      ],
    );
  }

  Column _buildListItemTextColumn(NearestFountain fountainData) {
    final String distance = fountainData.distance.toStringAsFixed(1);
    final String distanceText = "$distance km";
    final String address = fountainData.address ?? "Address not Found";
    final double starRating = fountainData.score;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(distanceText),
        StarRatingBuilder(
          rating: starRating,
        ),
        SizedBox(
          width: double.infinity, // or a specific width
          child: Text(
            address,
            overflow: TextOverflow.ellipsis,
            maxLines: 1, // You can adjust this to show more or fewer lines
          ),
        ),
      ],
    );
  }

  CircleAvatar _buildDirectionsButton(double latitude, double longitude) {
    return CircleAvatar(
      // DirectionsButton
      radius: 25.0,
      backgroundColor: Colors.green,
      child: IconButton.filled(
        onPressed: () {
          getDirectionsFromCoordinates(latitude, longitude);
        },
        icon: const Icon(
          Icons.navigation_sharp,
          color: Colors.white,
        ),
      ),
    );
  }
}
