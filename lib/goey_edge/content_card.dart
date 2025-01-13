import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/scheduler.dart';

import 'main.dart';

class ContentCard extends StatefulWidget {
  final String color;
  final Color altColor;
  final String title;
  final String subtitle;

  ContentCard({required this.color, this.title = "", required this.subtitle, required this.altColor}) : super();

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  late Ticker _ticker;

  @override
  void initState() {
    _ticker = Ticker((d) {
      setState(() {});
    })
      ..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        var time = DateTime.now().millisecondsSinceEpoch / 2000;
        var scaleX = 1.2 + sin(time) * .05;
        var scaleY = 1.2 + cos(time) * .07;
        var offsetY = 20 + cos(time) * 20;
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Transform.translate(
              offset: Offset(-(scaleX - 1) / 2 * width, -(scaleY - 1) / 2 * height + offsetY),
              child: Transform(
                transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
                child: Image.asset('images/Bg-${widget.color}.png', fit: BoxFit.cover, ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 75.0, bottom: 25.0),
                child: Column(
                  children: <Widget>[
                    //Top Image
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Image.asset(
                          'images/Illustration-${widget.color}.png',
                          fit: BoxFit.contain,

                        ),
                      ),
                    ),

                    //Slider circles
                    Container(height: 14, child: Image.asset('images/Slider-${widget.color}.png', )),

                    //Bottom content
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: _buildBottomContent(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildBottomContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.2, fontSize: 30.0, fontFamily: 'DMSerifDisplay', color: Colors.white,)),
        Text(widget.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'OpenSans',
                color: Colors.white,
               )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: MaterialButton(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: widget.altColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Get Started',
                  style: TextStyle(
                      fontSize: 16,
                      letterSpacing: .8,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      )),
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
