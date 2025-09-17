import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Malang ', style: TextStyle(fontSize: 30)),
              Text('25\u00B0C', style: TextStyle(fontSize: 75)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  harian('Minggu', Icons.sunny, '20\u00B0C'),
                  harian('Senin', Icons.cloudy_snowing, '23\u00B0C'),
                  harian('Selasa', Icons.cloud, '22\u00B0C'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Container harian(String hari, IconData icon, String suhu) {
  return Container(
    width: 100,
    height: 100,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(hari, style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        Icon(icon, color: Colors.black, size: 30),
        SizedBox(height: 10),
        Text(suhu, style: TextStyle(fontSize: 16)),
      ],
    ),
  );
}
