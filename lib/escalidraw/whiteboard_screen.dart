import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'model/draw_point.dart';
import 'whiteboard_painter.dart';

class WhiteboardScreen extends StatefulWidget {
  @override
  _WhiteboardScreenState createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  List<DrawPoint> _points = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;
  bool _isEraser = false;
  bool _allowEdit = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _docId = "whiteboard_data";

  @override
  void initState() {
    super.initState();
    _listenToWhiteboard();
  }

  void _listenToWhiteboard() {
    _firestore.collection('whiteboard').doc(_docId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        List<dynamic> data = snapshot.get('points') ?? [];
        setState(() {
          _points = data.map((e) => DrawPoint.fromJson(e)).toList();
        });
      }
    });
  }

  void _addPoint(Offset position) {
    if (!_allowEdit) return;

    DrawPoint point = DrawPoint(
      position: position,
      color: _selectedColor,
      strokeWidth: _strokeWidth,
      isEraser: _isEraser,
    );

    _points.add(point);
    _updateFirestore();
  }

  void _updateFirestore() {
    _firestore.collection('whiteboard').doc(_docId).set({
      'points': _points.map((e) => e.toJson()).toList(),
    });
  }

  void _clearBoard() {
    setState(() {
      _points.clear();
    });
    _updateFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Collaborative Whiteboard")),
      body: GestureDetector(
        onPanUpdate: (details) {
          _addPoint(details.localPosition);
        },
        onPanEnd: (details) {
          _points.add(DrawPoint(
            position: Offset(-1, -1),
            color: Colors.transparent,
            strokeWidth: 0,
          ));
          _updateFirestore();
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: WhiteboardPainter(_points),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Row(
                children: [
                  FloatingActionButton(
                    onPressed: _clearBoard,
                    child: Icon(Icons.delete),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () => setState(() => _isEraser = !_isEraser),
                    child: Icon(_isEraser ? Icons.brush : FontAwesomeIcons.eraser),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () => setState(() => _allowEdit = !_allowEdit),
                    child: Icon(_allowEdit ? Icons.lock_open : Icons.lock),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
