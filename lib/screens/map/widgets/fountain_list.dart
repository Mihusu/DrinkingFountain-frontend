// fountain_list.dart
import 'package:flutter/material.dart';

class FountainList extends StatelessWidget {
  final Color listedItemColor;
  final Color listedItemBorderColor;
  final Color listedItemTextColor;

  const FountainList({
    super.key,
    required this.listedItemColor,
    required this.listedItemBorderColor,
    required this.listedItemTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  ListView _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 13.0, bottom: 70.0),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem();
      },
    );
  }

  Container _buildListItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: listedItemColor,
        borderRadius: BorderRadius.circular(90.0),
        border: Border.all(color: listedItemBorderColor, width: 1.0),
      ),
      child: _buildListItemRow(),
    );
  }

  Row _buildListItemRow() {
    return Row(
      children: <Widget>[
        const Icon(Icons.question_mark_outlined,
            size: 50.0, color: Colors.black),
        const SizedBox(width: 10.0),
        Expanded(child: _buildListItemTextColumn()),
        _buildDirectionsButton(),
      ],
    );
  }

  Column _buildListItemTextColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("\"Distance here\""),
        Row(
          children: List.generate(
            5,
            (index) => Icon(Icons.star, size: 15.0, color: listedItemTextColor),
          ),
        ),
        const Text("\"Address here\""),
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
