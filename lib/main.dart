// lib/main.dart
import 'package:flutter/material.dart';
import 'package:tasks_manager/presentation/screens/tasks.dart';

import 'di/di.dart';

void main() {
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TaskScreen(),
    );
  }
}
