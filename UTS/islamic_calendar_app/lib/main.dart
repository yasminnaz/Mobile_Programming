import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hijri Calendar',
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Poppins'),
      home: const CalendarPage(),
    );
  }
}
