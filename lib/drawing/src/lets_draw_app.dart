import 'package:flutter/material.dart';
import 'package:whiteboard/drawing/src/src.dart';

class LetsDrawApp extends StatelessWidget {
  const LetsDrawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Let/'s Draw",
      theme: lightTheme,
      home: const DrawingPage(),
    );
  }
}
