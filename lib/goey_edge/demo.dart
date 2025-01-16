import 'package:flutter/material.dart';

import 'content_card.dart';
import 'gooey_carousel.dart';

class GooeyEdgeDemo extends StatefulWidget {
  const GooeyEdgeDemo({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _GooeyEdgeDemoState createState() => _GooeyEdgeDemoState();
}

class _GooeyEdgeDemoState extends State<GooeyEdgeDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GooeyCarousel(
        children: <Widget>[
          ContentCard(
            color: 'Red',
            altColor: Color(0xFF4259B2),
            title: "Organize Your Day \nwith Smart Planning",
            subtitle: 'Prioritize your tasks and streamline your workflow for maximum productivity.',
          ),
          ContentCard(
            color: 'Yellow',
            altColor: Color(0xFF904E93),
            title: "Track Progress \nwith Real-Time Updates",
            subtitle: 'Stay on top of your goals with visual progress tracking and reminders.',
          ),
          ContentCard(
            color: 'Blue',
            altColor: Color(0xFFFFB138),
            title: "Collaborate Seamlessly \nwith Your Team",
            subtitle: 'Boost teamwork with shared task lists, updates, and real-time collaboration.',
          ),
        ],

      ),
    );
  }
}
