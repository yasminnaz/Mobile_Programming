import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Row and Column',
      home: Scaffold(
        appBar: AppBar(title: Text('Row and Column')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Kotak(Colors.red, Icons.favorite),
                      SizedBox(height: 8),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Kotak(Colors.grey, Icons.settings),
                      SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Kotak(Colors.blue, Icons.thumb_up),
                      SizedBox(height: 8),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Kotak(Colors.black, Icons.thumb_down),
                      SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Container Kotak(Color color, IconData icon) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),

    child: Icon(icon, color: Colors.white, size: 40),
  );
}
