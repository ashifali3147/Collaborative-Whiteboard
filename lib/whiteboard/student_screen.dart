import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whiteboard/whiteboard/point_data.dart';
import 'package:whiteboard/whiteboard/whiteboard_painter.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StudentScreenState();
  }
}

class _StudentScreenState extends State<StudentScreen> {
  List<PointData> points = []; // List of maps with points and strokeId
  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance.ref("whiteboard_data");

    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final newPoint = Offset(
          (data["x"] as num).toDouble(),
          (data["y"] as num).toDouble(),
        );
        final strokeId = data["strokeId"];

        // Add point with strokeId for comparison
        setState(() {
          points.add(PointData(newPoint, strokeId));
        });
      }
    });

    // Use onValue to handle full whiteboard clearing
    databaseRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        setState(() {
          points.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student View')),
      body: CustomPaint(
        painter: WhiteboardPainter(points),
        size: Size.infinite,
      ),
    );
  }
}
