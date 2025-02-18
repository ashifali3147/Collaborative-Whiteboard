import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whiteboard/whiteboard/whiteboard_painter.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  List<Offset> points = [];
  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance.ref("whiteboard_data");

    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        print("Data Received: ${data.toString()}");

        final newPoint = Offset((data["x"] as num).toDouble(), (data["y"] as num).toDouble());

        // Ignore Offset.zero separators sent from the teacher's screen
        if (newPoint != Offset.zero) {
          setState(() {
            points.add(newPoint);
          });
        } else {
          setState(() {
            points.add(Offset.zero); // Preserve stroke separation
          });
        }
      }
    });

    // Instead of onChildRemoved, use onValue to handle full whiteboard clearing
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
