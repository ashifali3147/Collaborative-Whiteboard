import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'whiteboard_painter.dart'; // Ensure correct import path
import 'point_data.dart'; // Import the PointData class

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TeacherScreenState();
  }
}

class _TeacherScreenState extends State<TeacherScreen> {
  List<PointData> points = [];  // List of PointData instead of just Offsets
  final databaseRef = FirebaseDatabase.instance.ref("whiteboard_data");
  String strokeId = '';  // Variable to hold the current stroke ID

  @override
  void initState() {
    super.initState();
    strokeId = DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID for each stroke
  }

  // Save points to Firebase with strokeId
  void savePointsToFirebase(Offset point) {
    final newPoint = {"x": point.dx, "y": point.dy, "strokeId": strokeId};
    databaseRef.push().set(newPoint);
  }

  // Clear the whiteboard
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
            points.add(PointData(details.localPosition, strokeId)); // Store the point with its strokeId
            savePointsToFirebase(details.localPosition); // Send the point to Firebase
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(PointData(Offset.zero, strokeId)); // Adding a separator for new strokes
            strokeId = DateTime.now().millisecondsSinceEpoch.toString(); // New stroke ID for next stroke
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
