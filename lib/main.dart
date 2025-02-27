import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigation_bar.dart..dart';

void main() => runApp(ScheduleApp());

class ScheduleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14),
          titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: NavigationBarScreen(),
    );
  }
}