import 'package:flutter/material.dart';
import 'package:toerst/models/nearest_fountain.dart';
import 'fountain_list.dart'; // Ensure this import is correct
import 'package:toerst/themes/app_colors.dart'; // Ensure this import is correct

class DraggableFountainList extends StatelessWidget {
  final double sheetPosition;
  final Function(double) onVerticalDragUpdate;
  final Function(DragEndDetails)
      onVerticalDragEnd; // Updated function signature
  final Color listedItemColor;
  final Color listedItemBorderColor;
  final Color listedItemTextColor;
  final bool loading;
  final List<NearestFountain> nearestFountains;

  const DraggableFountainList(
      {super.key,
      required this.sheetPosition,
      required this.onVerticalDragUpdate,
      required this.onVerticalDragEnd, // Updated function signature
      required this.listedItemColor,
      required this.listedItemBorderColor,
      required this.listedItemTextColor,
      required this.loading,
      required this.nearestFountains});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    if (loading) {
      return Container();
    }
    return Positioned(
      top: sheetPosition * screenHeight,
      child: GestureDetector(
        onVerticalDragUpdate: (details) =>
            onVerticalDragUpdate(details.delta.dy / screenHeight),
        onVerticalDragEnd: onVerticalDragEnd, // Updated function call
        child: _buildSheetContent(context, screenHeight), // pass context here
      ),
    );
  }

  Container _buildSheetContent(BuildContext context, double screenHeight) {
    // receive context here
    return Container(
      height: screenHeight * (1 - sheetPosition),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: draggableSheetColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: _buildSheetColumn(),
    );
  }

  Column _buildSheetColumn() {
    return Column(
      children: [
        const DragHandle(),
        Expanded(
          child: FountainList(
            listedItemColor: listedItemColor,
            listedItemBorderColor: listedItemBorderColor,
            listedItemTextColor: listedItemTextColor,
            nearestFountains: nearestFountains,
          ),
        ),
      ],
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: draggablePillColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
