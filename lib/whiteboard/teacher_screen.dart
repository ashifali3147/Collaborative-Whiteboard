import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'whiteboard_painter.dart'; // Ensure correct import path

class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  List<Offset> points = [];
  final databaseRef = FirebaseDatabase.instance.ref("whiteboard_data");

  void savePointsToFirebase(Offset point) {
    final newPoint = {"x": point.dx, "y": point.dy};
    print("Data Send: ${newPoint}");
    databaseRef.push().set(newPoint);
  }

  void clearWhiteboard() {
    databaseRef.remove();
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Whiteboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearWhiteboard,
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            points.add(details.localPosition); // Use actual coordinates
            savePointsToFirebase(details.localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(Offset.zero); // Adding a separator for new strokes
          });
        },
        child: CustomPaint(
          painter: WhiteboardPainter(points),
          size: Size.infinite,
        ),
      ),
    );
  }
}
