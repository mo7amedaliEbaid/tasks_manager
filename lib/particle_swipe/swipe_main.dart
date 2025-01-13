import 'package:flutter/material.dart';

import 'components/particle_app_bar.dart';
import 'demo.dart';

class SwipeScreen extends StatelessWidget {
  const SwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          ParticleAppBar(),
          Flexible(child: ParticleSwipeDemo()),
        ]),
      ),
    );
  }
}

/*
void main() => runApp(App());

class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ));
    final theme = ThemeData(
      brightness: Brightness.dark,
      canvasColor: Color(0xFF161719),
      textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white, fontFamily: 'OpenSans'),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
    );
    return MaterialApp(
      title: 'Particle Swipe',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Color(0xffc932d9),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(children: [
            ParticleAppBar(),
            Flexible(child: ParticleSwipeDemo()),
          ]),
        ),
      ),
    );
  }
}
*/
