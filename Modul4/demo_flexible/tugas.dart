import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Text('Pemutar Musik', style: TextStyle(fontSize: 24)),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          color: Colors.black54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Icon(Icons.shuffle, color: Colors.white, size: 30),
              ),
              Expanded(
                child: Icon(Icons.skip_previous, color: Colors.white, size: 30),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              Expanded(
                child: Icon(Icons.skip_next, color: Colors.white, size: 30),
              ),
              Expanded(
                child: Icon(Icons.repeat, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
