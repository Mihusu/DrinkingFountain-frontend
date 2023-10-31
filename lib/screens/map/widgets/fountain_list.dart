// fountain_list.dart
import 'package:flutter/material.dart';
import 'package:toerst/models/nearest_fountain.dart';

class FountainList extends StatelessWidget {
  final Color listedItemColor;
  final Color listedItemBorderColor;
  final Color listedItemTextColor;
  final List<NearestFountain> nearestFountains;

  const FountainList(
      {super.key,
      required this.listedItemColor,
      required this.listedItemBorderColor,
      required this.listedItemTextColor,
      required this.nearestFountains});

  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  ListView _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 13.0, bottom: 70.0),
      itemCount: nearestFountains.length,
      itemBuilder: (BuildContext context, int index) {
        final item = nearestFountains[index];
        return _buildListItem(item);
      },
    );
  }

  Container _buildListItem(fountainData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: listedItemColor,
        borderRadius: BorderRadius.circular(90.0),
        border: Border.all(color: listedItemBorderColor, width: 1.0),
      ),
      child: _buildListItemRow(fountainData),
    );
  }

  Row _buildListItemRow(fountainData) {
    return Row(
      children: <Widget>[
        const Icon(Icons.question_mark_outlined, //TODO add photo for type
            size: 50.0,
            color: Colors.black),
        const SizedBox(width: 10.0),
        Expanded(child: _buildListItemTextColumn(fountainData)),
        _buildDirectionsButton(),
      ],
    );
  }

  Column _buildListItemTextColumn(NearestFountain fountainData) {
    final String distance = fountainData.distance.toStringAsFixed(2);
    final String distanceText = "$distance km";
    final String address = fountainData.address ?? "Address not Found";
    final int starRating = fountainData.score.toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(distanceText),
        Row(
          children: List.generate(
            starRating,
            (index) => Icon(Icons.star, size: 15.0, color: listedItemTextColor),
          ),
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

  // Should perhaps be a button that that launches google maps with
  //the coordinates typed in.
  CircleAvatar _buildDirectionsButton() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: Colors.green,
      child: Icon(Icons.arrow_forward, color: Colors.white),
    );
  }
}
