import 'package:flutter/material.dart';
import 'package:whiteboard/whiteboard/student_screen.dart';
import 'package:whiteboard/whiteboard/teacher_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Whiteboard App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeacherScreen()),
                  ),
              child: Text('Teacher'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentScreen()),
                  ),
              child: Text('Student'),
            ),
          ],
        ),
      ),
    );
  }
}
