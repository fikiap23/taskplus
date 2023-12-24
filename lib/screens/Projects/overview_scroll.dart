import 'package:flutter/material.dart';
import 'package:taskplus/screens/Projects/over_view_card.dart';

class OverView extends StatelessWidget {
  const OverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content for the "My tasks" section
          Container(
            height: 250,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return const OvervewCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
